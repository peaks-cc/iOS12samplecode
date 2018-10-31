//
//  OnetimeCodeViewController.swift
//  Demo
//
//  Created by Yosuke Ishikawa on 2018/08/28.
//

import UIKit

final class OnetimeCodeViewController: UIViewController {
    static func makeInstance() -> OnetimeCodeViewController {
        let storyboard = UIStoryboard(name: "OnetimeCode", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! OnetimeCodeViewController
        return viewController
    }
    
    @IBOutlet private weak var onetimeCodeTextField: UITextField!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onetimeCodeTextField.becomeFirstResponder()
    }
    
    @IBAction private func confirm() {
        guard let email = onetimeCodeTextField.text, !email.isEmpty else {
            indicateInputError(message: "ワンタイムコードを入力してください。")
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
            title: "コードを確認しました",
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
