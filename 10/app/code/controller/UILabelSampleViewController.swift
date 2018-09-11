//
//  UILabelSampleViewController.swift
//
//  Created by ToKoRo on 2018-09-11.
//

import UIKit

class UILabelSampleViewController: UITableViewController {
    @IBOutlet weak var withoutMarqueeLabel: UILabel?
    @IBOutlet weak var withMarqueeLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        withoutMarqueeLabel?.enablesMarqueeWhenAncestorFocused = false
        withMarqueeLabel?.enablesMarqueeWhenAncestorFocused = true
    }
}
