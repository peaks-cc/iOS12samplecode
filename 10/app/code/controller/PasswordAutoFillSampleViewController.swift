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

    override func viewDidLoad() {
        super.viewDidLoad()

        // これが重要
        // これをしないとテキスト入力画面から戻ってきたときに強制的にテキストフィールドにフォーカスが当たってしまう
        self.restoresFocusAfterTransition = false
    }

    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        if idTextField.text?.isEmpty ?? true {
            return [idTextField]
        } else if passwordTextField?.text?.isEmpty ?? true {
            return [passwordTextField]
        } else {
            return [logInButton]
        }
    }
}
