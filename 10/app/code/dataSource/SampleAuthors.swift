//
//  SampleAuthors.swift
//
//  Created by ToKoRo on 2018-08-27.
//

import Foundation

class SampleAuthors {
    static let shared = SampleAuthors()

    let samples: [Author] = [
        Author(name: "所 友太", category: "Spinners", imageName: "tokoro"),
        Author(name: "堤 修一", category: "Fyusion", imageName: "tsusumi"),
        Author(name: "吉田 悠一", category: "デンソーアイティーラボラトリ", imageName: "yoshida"),
        Author(name: "加藤 尋樹", category: "はてな", imageName: "kato"),
        Author(name: "池田 翔", category: "はてな", imageName: "ikeda"),
        Author(name: "佐藤 剛士", category: "MAMORIO", imageName: "sato"),

        Author(),
        Author(name: "Title"),
        Author(category: "Subtitle"),
        Author(name: "Yuta Tokoro"),

        Author(name: "Yuta Tokoro", personNameComponents: {
            var components = PersonNameComponents()
            components.givenName = "Yuta"
            components.familyName = "Tokoro"
            return components
        }()),
        Author(personNameComponents: {
            var components = PersonNameComponents()
            components.givenName = "Johnathan"
            components.familyName = "Appleseed"
            return components
        }()),
        Author(name: "Johnathan", personNameComponents: {
            var components = PersonNameComponents()
            components.givenName = "Johnathan"
            components.familyName = "Appleseed"
            return components
        }()),
        Author(name: "Has middleName", personNameComponents: {
            var components = PersonNameComponents()
            components.givenName = "Johnathan"
            components.middleName = "Maple"
            components.familyName = "Appleseed"
            return components
        }()),
        Author(name: "Mr. Smith", personNameComponents: {
            var components = PersonNameComponents()
            components.namePrefix = "Mr."
            components.familyName = "Smith"
            return components
        }()),
        Author(name: "所 友太", personNameComponents: {
            var components = PersonNameComponents()
            components.givenName = "友太"
            components.familyName = "所"
            return components
        }()),
        Author(name: "所 友太", personNameComponents: {
            var components = PersonNameComponents()
            components.familyName = "所"
            return components
        }()),
        Author(name: "所 友太", personNameComponents: {
            var components = PersonNameComponents()
            components.givenName = "友太"
            return components
        }()),
    ]
}
