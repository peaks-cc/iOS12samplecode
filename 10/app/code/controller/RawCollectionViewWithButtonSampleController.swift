//
//  RawCollectionViewWithButtonSampleController.swift
//
//  Created by ToKoRo on 2018-08-31.
//

import UIKit

class RawCollectionViewWithButtonSampleController: RawCollectionViewSampleController {
    override func adoptSubview(to cell: UICollectionViewCell, for indexPath: IndexPath) {
        guard let button = cell.contentView.searchSubview(for: UIButton.self) else {
            return
        }

        guard let author = author(for: indexPath) else {
            return
        }

        if let name = author.name {
            button.setTitle(name, for: .normal)
        }
    }
}
