//
//  IdentityListViewController.swift
//  ProviderDemo
//
//  Created by Yosuke Ishikawa on 2018/09/18.
//

import UIKit
import AuthenticationServices
import ProviderDemoFramework

public final class IdentityListViewController: UIViewController {
    public static func makeInstance() -> IdentityListViewController {
        let storyboard = UIStoryboard(name: "IdentityList", bundle: Bundle(for: self))
        let viewController = storyboard.instantiateInitialViewController() as! IdentityListViewController
        return viewController
    }
    
    @IBOutlet private var tableView: UITableView!

    private let dataSource = IdentityDataSource()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
    }
    
    @IBAction private func showEditStoreActions() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Save current identities into store", style: .default) { _ in
            self.saveCredentialIdentitiesIntoStore()
        })
        alertController.addAction(UIAlertAction(title: "Remove all identities in store", style: .destructive) { _ in
            self.removeCredentialIdentitiesInStore()
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
    }

    private func saveCredentialIdentitiesIntoStore() {
        let store = ASCredentialIdentityStore.shared
        let identities = dataSource.identities
        store.getState { [weak self] state in
            guard state.isEnabled else {
                self?.indicateAppExtensionIsDisabled()
                return
            }
            
            store.saveCredentialIdentities(identities) { [weak self] _, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.indicateSavingError(error)
                    } else {
                        self?.indicateSavingSuccess()
                    }
                }
            }
        }
    }
    
    private func removeCredentialIdentitiesInStore() {
        let store = ASCredentialIdentityStore.shared
        store.removeAllCredentialIdentities()
    }
    
    private func indicateAppExtensionIsDisabled() {
        let alertController = UIAlertController(
            title: "ProviderDemoによる\nパスワードの自動入力が\n無効になっています",
            message: "設定アプリの「パスワードとアカウント」→「パスワードを自動入力」から、ProviderDemoによるパスワードの自動入力を有効にしてください。",
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }
    
    private func indicateSavingError(_ error: Error) {
        let alertController = UIAlertController(
            title: "ストアに保存できませんでした",
            message: error.localizedDescription,
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }
    
    private func indicateSavingSuccess() {
        let alertController = UIAlertController(
            title: "ストアに保存しました",
            message: "このアプリが持っているパスワードがQuickType barの候補に表示されます。",
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }
}
