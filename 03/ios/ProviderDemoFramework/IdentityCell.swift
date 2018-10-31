//
//  IdentityCell.swift
//  ProviderDemoFramework
//
//  Created by Yosuke Ishikawa on 2018/09/18.
//

import UIKit
import AuthenticationServices

final class IdentityCell: UITableViewCell {
    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var serviceIdentifierLabel: UILabel!
    
    func setValues(with identity: ASPasswordCredentialIdentity) {
        userLabel.text = identity.user
        serviceIdentifierLabel.text = identity.serviceIdentifier.identifier
    }
}
