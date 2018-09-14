//
//  MoveCanvasView.swift
//
//  Created by ToKoRo on 2018-09-14.
//

import UIKit

class MoveCanvasView: CanvasView {
    override func createRects() -> [Rect] {
        return [
            MoveRect(x: 100, y: 100, color: UIColor.red.cgColor, parent: self),
            MoveRect(x: 300, y: 100, color: UIColor.blue.cgColor, parent: self),
            MoveRect(x: 100, y: 300, color: UIColor.green.cgColor, parent: self),
            MoveRect(x: 300, y: 300, color: UIColor.red.cgColor, parent: self)
        ]
    }
}

// MARK: - MoveRect

class MoveRect: Rect {
    var translation: CGVector?

    override var renderFrame: CGRect {
        if let translation = translation {
            let transform = CGAffineTransform(translationX: translation.dx, y: translation.dy)
            return super.renderFrame.applying(transform)
        } else {
            return super.renderFrame
        }
    }
}

extension MoveRect { //< UIFocusItem
    func didHintFocusMovement(_ hint: UIFocusMovementHint) {
        self.translation = hint.translation
        parentView?.setNeedsDisplay()
    }
}
