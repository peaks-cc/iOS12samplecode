//
//  CredentialProviderViewController.swift
//  ProviderDemoExtension
//
//  Created by Yosuke Ishikawa on 2018/09/17.
//

import Foundation
import ProviderDemoFramework
import AuthenticationServices

@objc(CredentialProviderViewController)
final class CredentialProviderViewController: ASCredentialProviderViewController {
    private let dataSource = IdentityDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewController = SelectIdentityViewController.makeInstance(
            cancelationHandler: { [weak self] in
                let error = ASExtensionError(.userCanceled)
                self?.extensionContext.cancelRequest(withError: error)
            },
            selectionHandler: { [weak self] identity in
                self?.provideCredential(with: identity)
            })
        
        let navigationController = UINavigationController(rootViewController: viewController)
        addChild(navigationController)
        navigationController.view.frame = view.bounds
        navigationController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(navigationController.view)
        navigationController.didMove(toParent: self)
    }
    
    override func provideCredentialWithoutUserInteraction(for identity: ASPasswordCredentialIdentity) {
        provideCredential(with: identity)
    }
    
    private func provideCredential(with identity: ASPasswordCredentialIdentity) {
        if let credential = dataSource.credential(for: identity) {
            extensionContext.completeRequest(withSelectedCredential: credential)
        } else {
            let error = ASExtensionError(.credentialIdentityNotFound)
            extensionContext.cancelRequest(withError: error)
        }
    }
}
