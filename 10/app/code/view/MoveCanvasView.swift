//
//  MoveCanvasView.swift
//
//  Created by ToKoRo on 2018-09-14.
//

import UIKit

class MoveCanvasView: CanvasView {
    override func createRects() -> [Rect] {
        return [
            ShakableRect(x: 100, y: 100, color: UIColor.red.cgColor, parent: self),
            ShakableRect(x: 300, y: 100, color: UIColor.blue.cgColor, parent: self),
            ShakableRect(x: 100, y: 300, color: UIColor.green.cgColor, parent: self),
            ShakableRect(x: 300, y: 300, color: UIColor.red.cgColor, parent: self)
        ]
    }
}

// MARK: - ShakableRect

class ShakableRect: Rect {
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

extension ShakableRect { //< UIFocusItem
    func didHintFocusMovement(_ hint: UIFocusMovementHint) {
        self.translation = hint.translation
        parentView?.setNeedsDisplay()
    }
}
