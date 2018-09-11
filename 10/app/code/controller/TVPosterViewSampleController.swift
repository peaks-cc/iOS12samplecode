//
//  TVPosterViewSampleController.swift
//
//  Created by ToKoRo on 2018-08-25.
//

import UIKit
import TVUIKit

class TVPosterViewSampleController: UIViewController {
    lazy var samples: [Book] = SampleBooks.shared.samples

    private func book(for indexPath: IndexPath) -> Book? {
        let index = indexPath.item
        guard let book = samples.indices.contains(index) ? samples[index] : nil else {
            return nil
        }
        return book
    }

    private func adoptSubview(to cell: UICollectionViewCell, for indexPath: IndexPath) {
        guard let book = book(for: indexPath) else {
            return
        }

        let contentView = cell.contentView

        let posterView: TVPosterView = {
            if let posterView = contentView.searchSubview(for: TVPosterView.self) {
                return posterView
            }

            let posterView = TVPosterView(image: nil)
            posterView.frame = contentView.bounds
            return posterView
        }()

        posterView.removeFromSuperview()

        posterView.image = UIImage(named: book.imageName)
        posterView.title = book.title
        posterView.subtitle = book.subtitle

        contentView.addSubview(posterView)
    }
}

// MARK: - UICollectionViewDataSource

extension TVPosterViewSampleController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return samples.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        adoptSubview(to: cell, for: indexPath)
        return cell
    }
}
