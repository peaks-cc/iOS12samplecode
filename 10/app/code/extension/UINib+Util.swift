//
//  UINib+Util.swift
//
//  Created by ToKoRo on 2018-08-26.
//

import UIKit

extension UINib {
    class func load<V: UIView>(from nibName: String? = nil, owner: Any? = nil, options: [UINib.OptionsKey: Any]? = nil) -> V? {
        let validNibName = nibName ?? self.nibName(for: V.self)
        let nib = UINib(nibName: validNibName, bundle: nil)
        let objects = nib.instantiate(withOwner: owner, options: options)
        for case let object as V in objects {
            return object
        }
        return nil
    }

    class func nibName<V: UIView>(for type: V.Type) -> String {
        let className = String(describing: type.self)
        guard let lastComponent = className.split(separator: ".").last else {
            fatalError("Invalid xib for: \(type)")
        }
        return String(lastComponent)
    }
}
