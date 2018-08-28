//
//  TVMonogramViewSampleViewController.swift
//
//  Created by ToKoRo on 2018-08-26.
//

import UIKit
import TVUIKit

class TVMonogramViewSampleViewController: UIViewController {
    lazy var samples: [Author] = SampleAuthors.shared.samples

    private func author(for indexPath: IndexPath) -> Author? {
        let index = indexPath.item
        guard let author = samples.indices.contains(index) ? samples[index] : nil else {
            return nil
        }
        return author
    }

    private func adoptSubview(to cell: UICollectionViewCell, for indexPath: IndexPath) {
        let monogramView: TVMonogramView = {
            let contentView = cell.contentView
            if let monogramView = contentView.searchSubview(for: TVMonogramView.self) {
                return monogramView
            }
            let monogramView = TVMonogramView()
            monogramView.frame = contentView.bounds
            monogramView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
            contentView.addSubview(monogramView)
            return monogramView
        }()

        guard let author = author(for: indexPath) else {
            return
        }

        monogramView.title = author.name
        monogramView.subtitle = author.category
        monogramView.personNameComponents = author.personNameComponents

        if let imageName = author.imageName {
            monogramView.image = UIImage(named: imageName)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension TVMonogramViewSampleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return samples.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        adoptSubview(to: cell, for: indexPath)
        return cell
    }
}
