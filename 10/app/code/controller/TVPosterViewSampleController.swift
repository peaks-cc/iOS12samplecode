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
        let posterView: TVPosterView = {
            let contentView = cell.contentView
            if let posterView = contentView.searchSubview(for: TVPosterView.self) {
                return posterView
            }

            let posterView = TVPosterView(image: nil)
            posterView.frame = contentView.bounds

            /*
            print("### contentView: \(posterView.contentView)")
            print("### contentSize: \(posterView.contentSize)")
            print("### contentViewInsets: \(posterView.contentViewInsets)")
            print("### headerView: \(posterView.headerView)")
            print("### footerView: \(posterView.footerView)")
            print("### focusSizeIncrease: \(posterView.focusSizeIncrease)")
            */

            // 画像部分のsizeを指定
            // posterView.imageView.frame.size = CGSize(width: 50, height: 100)
            // posterView.imageView.contentMode = .scaleAspectFit
            // print("### xxx: \(posterView.imageView.contentMode.rawValue)")

            posterView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
            contentView.addSubview(posterView)
            return posterView
        }()

        guard let book = book(for: indexPath) else {
            return
        }

        posterView.title = book.title
        posterView.subtitle = book.subtitle
        posterView.image = UIImage(named: book.imageName)
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
