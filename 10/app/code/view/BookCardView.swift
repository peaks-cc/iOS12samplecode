//
//  BookCardView.swift
//
//  Created by ToKoRo on 2018-08-26.
//

import UIKit

class BookCardView: UIView {
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var subtitleLabel: UILabel?
    @IBOutlet weak var imageView: UIImageView?

    var title: String? {
        get {
            return titleLabel?.text
        }
        set {
            titleLabel?.text = newValue
        }
    }

    var subtitle: String? {
        get {
            return subtitleLabel?.text
        }
        set {
            subtitleLabel?.text = newValue
        }
    }

    var image: UIImage? {
        get {
            return imageView?.image
        }
        set {
            imageView?.image = newValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel?.enablesMarqueeWhenAncestorFocused = true
        subtitleLabel?.enablesMarqueeWhenAncestorFocused = true
    }
}
