//
//  IdentityDataSource.swift
//  ProviderDemoFramework
//
//  Created by Yosuke Ishikawa on 2018/09/18.
//

import UIKit
import AuthenticationServices

public final class IdentityDataSource: NSObject {
    public let identities: [ASPasswordCredentialIdentity] = (1...3)
        .map { index in
            let serviceIdentifier = ASCredentialServiceIdentifier(
                identifier: "ios12demo.firebaseapp.com",
                type: .domain)
            
            let user = "y+\(index)@ishkawa.org"
            let identity = ASPasswordCredentialIdentity(
                serviceIdentifier: serviceIdentifier,
                user: user,
                recordIdentifier: nil)
            
            identity.rank = index
            
            return identity
        }
    
    private var registeredTableViews = [] as [UITableView]

    public func credential(for targetIdentity: ASPasswordCredentialIdentity) -> ASPasswordCredential? {
        return identities
            .first { identity in
                return (
                    identity.user == targetIdentity.user &&
                    identity.serviceIdentifier.identifier == targetIdentity.serviceIdentifier.identifier &&
                    identity.serviceIdentifier.type == targetIdentity.serviceIdentifier.type)
            }
            .map { identity in
                return ASPasswordCredential(
                    user: identity.user,
                    password: "abcdefg")
            }
    }
}

extension IdentityDataSource: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return identities.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "IdentityCell"
        if !registeredTableViews.contains(tableView) {
            registeredTableViews.append(tableView)
            
            let nib = UINib(nibName: "IdentityCell", bundle: Bundle(for: IdentityCell.self))
            tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! IdentityCell
        let identity = identities[indexPath.row]
        cell.setValues(with: identity)
        
        return cell
    }
}
