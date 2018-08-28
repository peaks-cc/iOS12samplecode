//
//  UIView+Utils.swift
//
//  Created by ToKoRo on 2018-08-25.
//

import UIKit

extension UIView {
    func searchSubview<View: UIView>(for type: View.Type) -> View? {
        for case let matched as View in subviews {
            return matched
        }
        return nil
    }
}
