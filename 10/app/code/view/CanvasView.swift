//
//  CanvasView.swift
//
//  Created by ToKoRo on 2018-09-13.
//

import UIKit

class CanvasView: UIView {
    lazy var rects: [Rect] = createRects()

    func createRects() -> [Rect] {
        return [
            Rect(x: 100, y: 100, color: UIColor.red.cgColor, parent: self),
            Rect(x: 300, y: 100, color: UIColor.blue.cgColor, parent: self),
            Rect(x: 100, y: 300, color: UIColor.green.cgColor, parent: self),
            Rect(x: 300, y: 300, color: UIColor.red.cgColor, parent: self)
        ]
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        for rect in rects {
            rect.draw(in: context)
        }
    }

    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        switch presses.first?.type {
        case .select?:
            guard let rect = UIFocusSystem(for: self)?.focusedItem as? Rect else {
                return
            }
            rect.color = UIColor(
                red: CGFloat(arc4random_uniform(255)) / 255,
                green: CGFloat(arc4random_uniform(255)) / 255,
                blue: CGFloat(arc4random_uniform(255)) / 255,
                alpha: 1
            ).cgColor
            setNeedsDisplay()
        default:
            break
        }
    }
}

extension CanvasView { //< UIFocusItemContainer
    override func focusItems(in rect: CGRect) -> [UIFocusItem] {
        // 厳密にはrectの範囲にあるItemのみ返す
        // このデモでは常に全てのItemがrect内にある前提のため全て返す
        return rects
    }
}

// MARK: - Rect

class Rect: NSObject {
    let frame: CGRect
    var color: CGColor

    weak var parentView: UIView?
    var isFocused: Bool = false

    init(x: CGFloat, y: CGFloat, color: CGColor, parent: UIView?) {
        self.frame = CGRect(x: x, y: y, width: 100, height: 100)
        self.color = color
        self.parentView = parent
    }

    var renderFrame: CGRect {
        if isFocused {
            return frame.insetBy(dx: -20, dy: -20)
        } else {
            return frame
        }
    }

    func draw(in context: CGContext) {
        context.setFillColor(color)
        context.addRect(renderFrame)
        context.fillPath()
    }
}

extension Rect: UIFocusItem {
    // required
    var canBecomeFocused: Bool {
        return true
    }
}

extension Rect: UIFocusEnvironment {
    // required
    weak var parentFocusEnvironment: UIFocusEnvironment? {
        return parentView
    }

    // required
    var focusItemContainer: UIFocusItemContainer? {
        return nil
    }

    // required
    var preferredFocusEnvironments: [UIFocusEnvironment] {
        return []
    }

    // required
    func setNeedsFocusUpdate() {
        // これによりpreferredFocusEnvironmentsが呼ばれる
        // preferredFocusEnvironmentsが空実装なら特に必要なし
        UIFocusSystem(for: self)?.requestFocusUpdate(to: self)
    }

    // required
    func updateFocusIfNeeded() {
        // これによりpreferredFocusEnvironmentsが呼ばれる
        // preferredFocusEnvironmentsが空実装なら特に必要なし
        UIFocusSystem(for: self)?.updateFocusIfNeeded()
    }

    // required
    func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        return true
    }

    // required
    func didUpdateFocus(in context: UIFocusUpdateContext,
                        with coordinator: UIFocusAnimationCoordinator) {

        if context.nextFocusedItem as? Rect == self {
            self.isFocused = true
        } else {
            self.isFocused = false
        }

        parentView?.setNeedsDisplay()
    }
}
