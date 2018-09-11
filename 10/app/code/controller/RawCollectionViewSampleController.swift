//
//  RawCollectionViewSampleController.swift
//
//  Created by ToKoRo on 2018-08-31.
//

import UIKit

class RawCollectionViewSampleController: UIViewController {
    lazy var samples: [Author] = SampleAuthors.shared.samples

    func author(for indexPath: IndexPath) -> Author? {
        let index = indexPath.item
        guard let author = samples.indices.contains(index) ? samples[index] : nil else {
            return nil
        }
        return author
    }

    func adoptSubview(to cell: UICollectionViewCell, for indexPath: IndexPath) {
        guard let imageView = cell.contentView.searchSubview(for: UIImageView.self) else {
            return
        }

        guard let author = author(for: indexPath) else {
            return
        }

        if let imageName = author.imageName {
            imageView.image = UIImage(named: imageName)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension RawCollectionViewSampleController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return samples.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        adoptSubview(to: cell, for: indexPath)
        return cell
    }
}
