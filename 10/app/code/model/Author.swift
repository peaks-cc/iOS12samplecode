//
//  Author.swift
//
//  Created by ToKoRo on 2018-08-27.
//

import Foundation

struct Author {
    let name: String?
    let category: String?
    let imageName: String?
    let personNameComponents: PersonNameComponents?

    init(name: String? = nil, category: String? = nil, imageName: String? = nil, personNameComponents: PersonNameComponents? = nil) {
        self.name = name
        self.category = category
        self.imageName = imageName
        self.personNameComponents = personNameComponents
    }
}
