//
//  RemoveConstrainTableViewCell.swift
//  TryXcode10
//
//  Created by satoutakeshi on 2018/08/23.
//  Copyright © 2018年 Personal Factory. All rights reserved.
//

import UIKit

class RemoveConstrainTableViewCell: UITableViewCell {
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func config() {
    }

    override func updateConstraintsIfNeeded() {

    }
    override func updateConstraints() {
        // 制約を削除する
        NSLayoutConstraint.deactivate(bottomLabel.constraints)
        bottomLabel.removeConstraints(bottomLabel.constraints)
        // 子ビューを削除
        bottomLabel.removeFromSuperview()
        // 再びつける
        let constraint = NSLayoutConstraint(item: topLabel,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .bottom,
                                            multiplier: 1.0,
                                            constant: 0)
        self.addConstraint(constraint)
        super.updateConstraints()
    }
}
