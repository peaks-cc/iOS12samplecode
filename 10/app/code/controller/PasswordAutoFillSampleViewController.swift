//
//  PasswordAutoFillSampleViewController.swift
//
//  Created by ToKoRo on 2018-08-30.
//

import UIKit

class PasswordAutoFillSampleViewController: UIViewController {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!

    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        if idTextField.text?.isEmpty ?? true {
            return [idTextField]
        } else if passwordTextField?.text?.isEmpty ?? true {
            return [passwordTextField]
        } else {
            return [logInButton]
        }
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        // preferredFocusEnvironmentsだけを使った方法ではtvOS 12 beta 9ではうまくいかないため無理やり
        let previously = context.previouslyFocusedItem as? UIView
        if previously != idTextField && previously != passwordTextField && previously != logInButton {
            setNeedsFocusUpdate()
        }
    }
}
