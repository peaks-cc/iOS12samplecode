//
//  FocusableCollectionViewSampleController.swift
//
//  Created by ToKoRo on 2018-08-31.
//

import UIKit

class FocusableCollectionViewSampleController: RawCollectionViewSampleController {
    override func adoptSubview(to cell: UICollectionViewCell, for indexPath: IndexPath) {
        super.adoptSubview(to: cell, for: indexPath)

        guard let imageView = cell.contentView.searchSubview(for: UIImageView.self) else {
            return
        }

        imageView.adjustsImageWhenAncestorFocused = true
    }

    func focus(_ cell: UICollectionViewCell) {
        guard let imageView = cell.contentView.searchSubview(for: UIImageView.self) else {
            return
        }

        imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }

    func unfocus(_ cell: UICollectionViewCell) {
        guard let imageView = cell.contentView.searchSubview(for: UIImageView.self) else {
            return
        }

        imageView.transform = CGAffineTransform.identity
    }
}

// MARK: - UICollectionViewDelegate

extension FocusableCollectionViewSampleController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didUpdateFocusIn context: UICollectionViewFocusUpdateContext,
                        with coordinator: UIFocusAnimationCoordinator) {

        if let indexPath = context.previouslyFocusedIndexPath,
           let previously = collectionView.cellForItem(at: indexPath) {

            coordinator.addCoordinatedAnimations({
                self.unfocus(previously)
            })
        }

        if let indexPath = context.nextFocusedIndexPath,
           let next = collectionView.cellForItem(at: indexPath) {

            coordinator.addCoordinatedAnimations({
                self.focus(next)
            })
        }
    }
}
