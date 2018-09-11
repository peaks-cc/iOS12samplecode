//
//  ToggleConstraintTableViewCell.swift
//  TryXcode10
//
//  Created by satoutakeshi on 2018/08/23.
//  Copyright © 2018年 Personal Factory. All rights reserved.
//

import UIKit

class ToggleConstraintTableViewCell: UITableViewCell {
    @IBOutlet var bottomConstraintForTopLabel: NSLayoutConstraint!
    @IBOutlet weak var tobLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var topConstraintForBottomLabel: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintForBottomLabel: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraintForBottomLabel: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraintForBottomLabel: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func updateConstraints() {
        // 制約を付け替え
        bottomConstraintForTopLabel.isActive = true
        topConstraintForBottomLabel.isActive = false
        bottomConstraintForBottomLabel.isActive = false
        leadingConstraintForBottomLabel.isActive = false
        trailingConstraintForBottomLabel.isActive = false

        // ビューを非表示
        bottomLabel.isHidden = true
        super.updateConstraints()
    }

}
