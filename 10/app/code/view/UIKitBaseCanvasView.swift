//
//  UIKitBaseCanvasView.swift
//
//  Created by ToKoRo on 2018-09-14.
//

import UIKit

class UIKitBaseCanvasView: UIView {
}

extension UIKitBaseCanvasView { //< UIFocusItemContainer
    override func focusItems(in rect: CGRect) -> [UIFocusItem] {
        // 厳密にはrectの範囲にあるItemのみ返す
        // このデモでは常に全てのItemがrect内にある前提のため全て返す
        return subviews
    }
}

// MARK: - TransformedView

class TransformedView: UIView {
    override var canBecomeFocused: Bool {
        return true
    }

    override weak var parentFocusEnvironment: UIFocusEnvironment? {
        return superview
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            if context.nextFocusedItem as? TransformedView == self {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            } else {
                self.transform = CGAffineTransform.identity
            }
        })
    }

    override func didHintFocusMovement(_ hint: UIFocusMovementHint) {
        layer.transform = CATransform3DScale(hint.interactionTransform, 1.2, 1.2, 1)
    }
}
