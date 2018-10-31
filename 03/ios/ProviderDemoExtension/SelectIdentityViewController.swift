//
//  SelectCredentialViewController.swift
//  ProviderDemoExtension
//
//  Created by Yosuke Ishikawa on 2018/09/18.
//

import UIKit
import AuthenticationServices
import ProviderDemoFramework

final class SelectIdentityViewController: UIViewController {
    static func makeInstance(
        cancelationHandler: @escaping () -> Void,
        selectionHandler: @escaping (ASPasswordCredentialIdentity) -> Void) -> SelectIdentityViewController {
        let storyboard = UIStoryboard(name: "SelectIdentity", bundle: Bundle(for: self))
        let viewController = storyboard.instantiateInitialViewController() as! SelectIdentityViewController
        viewController.cancelationHandler = cancelationHandler
        viewController.selectionHandler = selectionHandler
        return viewController
    }
    
    @IBOutlet private var tableView: UITableView!

    private var cancelationHandler: (() -> Void)!
    private var selectionHandler: ((ASPasswordCredentialIdentity) -> Void)!
    
    private let dataSource = IdentityDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    @IBAction private func cancel() {
        cancelationHandler()
    }
}

extension SelectIdentityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let identity = dataSource.identities[indexPath.row]
        selectionHandler(identity)
    }
}
