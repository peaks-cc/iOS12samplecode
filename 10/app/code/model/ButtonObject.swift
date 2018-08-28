//
//  ButtonObject.swift
//
//  Created by ToKoRo on 2018-08-26.
//

import Foundation

struct ButtonObject {
    let content: Content
    let title: String?
    let subtitle: String?
}

// MARK: - Content

extension ButtonObject {
    enum Content {
        case text(String)
        case image(String)
    }
}
