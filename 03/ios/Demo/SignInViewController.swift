//
//  SignInViewController.swift
//  Demo
//
//  Created by Yosuke Ishikawa on 2018/08/24.
//

import UIKit

final class SignInViewController: UIViewController {
    static func makeInstance() -> SignInViewController {
        let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! SignInViewController
        return viewController
    }
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.becomeFirstResponder()
    }

    @IBAction private func signIn() {
        guard let email = emailTextField.text, !email.isEmpty else {
            indicateInputError(message: "メールアドレスを入力してください。")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            indicateInputError(message: "パスワードを入力してください。")
            return
        }
        
        view.endEditing(true)
        
        indicateSuccess()
    }

    private func indicateInputError(message: String) {
        let alertController = UIAlertController(
            title: "入力内容を確認してください",
            message: message,
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))

        present(alertController, animated: true)
    }
    
    private func indicateSuccess() {
        let alertController = UIAlertController(
            title: "ログインしました",
            message: nil,
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })

        present(alertController, animated: true)
    }
    
    @IBAction private func back() {
        navigationController?.popViewController(animated: true)
    }
}
