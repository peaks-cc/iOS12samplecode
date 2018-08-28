//
//  SampleBooks.swift
//
//  Created by ToKoRo on 2018-08-26.
//

import Foundation

class SampleBooks {
    static let shared = SampleBooks()

    let samples: [Book] = [
        Book(title: "iOS 11 Programming", subtitle: "第一線の開発者陣による「iOS 11 Programming」執筆プロジェクト！", imageName: "ios11", smallImageName: "ios11_small"),
        Book(title: "iOS 12 Programming", subtitle: "モダンなアプリを実現する「iOS 12 Programming」執筆プロジェクト！", imageName: "ios12", smallImageName: "ios12_small"),
        Book(title: "はじめてのUIデザイン", subtitle: "UIデザインを本質から解説する「はじめてのUIデザイン」執筆プロジェクト！", imageName: "ui", smallImageName: "ui_small"),
        Book(title: "Android アプリ設計パターン入門", subtitle: "TechBoosterの新刊！「Android アプリ設計パターン入門」執筆プロジェクト", imageName: "android_design", smallImageName: "android_design_small"),
        Book(title: "ゼロから創る暗号通貨", subtitle: "ブロックチェーンの理論と実装を理解する入門書「ゼロから創る暗号通貨」執筆プロジェクト！", imageName: "blockchain", smallImageName: "blockchain_small"),
        Book(title: "Androidテスト全書", subtitle: "Androidテストのバイブル「Androidテスト全書」執筆プロジェクト！", imageName: "android_test", smallImageName: "android_test_small"),
        Book(title: "iOSアプリ設計パターン入門", subtitle: "iOSの設計パターンを入門から徹底解説「iOSアプリ設計パターン入門」執筆プロジェクト！", imageName: "ios_design", smallImageName: "ios_design_small"),
    ]
}
