//
//  FaceView.swift
//
//  Created by ToKoRo on 2018-08-28.
//

import UIKit
import TVUIKit

@IBDesignable class FaceView: UIView {
    @IBOutlet weak var imageView: UIImageView?

    var animationsForFocused: (() -> Void)?
    var animationsForNormal: (() -> Void)?

    var image: UIImage? {
        get {
            return imageView?.image
        }
        set {
            imageView?.image = newValue
        }
    }
}

// MARK: - TVLockupViewComponent

extension FaceView: TVLockupViewComponent {
    func updateAppearance(forLockupViewState state: UIControl.State) {
        guard let animations = animations(for: state) else {
            return
        }

        UIView.animate(withDuration: 0.25, animations: animations)
    }

    private func animations(for state: UIControl.State) -> (() -> Void)? {
        switch state {
        case .normal:
            return animationsForNormal
        case .focused:
            return animationsForFocused
        default:
            return nil
        }
    }
}
