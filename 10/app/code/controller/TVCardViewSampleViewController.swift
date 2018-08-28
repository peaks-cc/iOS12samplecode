//
//  TVCardViewSampleController.swift
//
//  Created by ToKoRo on 2018-08-25.
//

import UIKit
import TVUIKit

class TVCardViewSampleController: UIViewController {
    lazy var samples: [Book] = SampleBooks.shared.samples

    private func book(for indexPath: IndexPath) -> Book? {
        let index = indexPath.item
        guard let book = samples.indices.contains(index) ? samples[index] : nil else {
            return nil
        }
        return book
    }

    private func adoptSubview(to cell: UICollectionViewCell, for indexPath: IndexPath) {
        let cardView: TVCardView = {
            let contentView = cell.contentView
            if let cardView = contentView.searchSubview(for: TVCardView.self) {
                return cardView
            }
            let cardView = TVCardView()
            cardView.frame = contentView.bounds
            // cardView.cardBackgroundColor = UIColor.red
            cardView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
            contentView.addSubview(cardView)
            guard let bookCard: BookCardView = UINib.load() else {
                return cardView
            }
            let padding: CGFloat = 20
            bookCard.frame = CGRect(
                x: padding,
                y: padding,
                width: cardView.bounds.width - padding * 2,
                height: cardView.bounds.height - padding * 2
            )
            bookCard.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
            cardView.contentView.addSubview(bookCard)
            return cardView
        }()

        guard let bookCard = cardView.contentView.searchSubview(for: BookCardView.self) else {
            return
        }

        guard let book = book(for: indexPath) else {
            return
        }

        bookCard.title = book.title
        bookCard.subtitle = book.subtitle
        bookCard.image = UIImage(named: book.imageName)
    }
}

// MARK: - UICollectionViewDataSource

extension TVCardViewSampleController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return samples.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        adoptSubview(to: cell, for: indexPath)
        return cell
    }
}
