//
//  IntroductionViewController.swift
//  Demo
//
//  Created by Yosuke Ishikawa on 2018/09/15.
//

import UIKit
import AuthenticationServices

final class IntrodcutionViewController: UIViewController {
    static func makeInstance() -> IntrodcutionViewController {
        let storyboard = UIStoryboard(name: "Introduction", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! IntrodcutionViewController
        return viewController
    }
    
    var session: ASWebAuthenticationSession?
    
    @IBAction private func navigateToSignUpViewController() {
        let viewController = SignUpViewController.makeInstance()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction private func navigateToSignInViewController() {
        let viewController = SignInViewController.makeInstance()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction private func navigateToOnetimeCodeViewController() {
        let viewController = OnetimeCodeViewController.makeInstance()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction private func startGitHubLogin() {
        session = ASWebAuthenticationSession(
            url: URL(string: "https://github.com/login/oauth/authorize?client_id=f1f0167c4961290759d4")!,
            callbackURLScheme: "ios12demo",
            completionHandler: { [weak self] url, error in
                self?.session = nil
                
                let code = url
                    .flatMap { URLComponents(url: $0, resolvingAgainstBaseURL: false) }
                    .flatMap { $0.queryItems?.first { $0.name == "code" } }
                    .flatMap { $0.value }

                if let code = code {
                    self?.indicateGitHubLoginSuccess(code: code)
                } else if let error = error as? ASWebAuthenticationSessionError, error.code != .canceledLogin {
                    self?.indicateGitHubLoginFailure(error: error)
                }
            })

        session?.start()
    }
    
    private func indicateGitHubLoginFailure(error: ASWebAuthenticationSessionError) {
        let alertController = UIAlertController(
            title: "ログインに失敗しました",
            message: error.localizedDescription,
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }

    private func indicateGitHubLoginSuccess(code: String) {
        let alertController = UIAlertController(
            title: "ログインしました",
            message: "コードは\(code)です。",
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        
        present(alertController, animated: true)
    }
}
