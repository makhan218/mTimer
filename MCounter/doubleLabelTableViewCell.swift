//
//  doubleLabelTableViewCell.swift
//  MCounter
//
//  Created by apple on 3/29/20.
//  Copyright © 2020 WeOverOne. All rights reserved.
//

import UIKit

class doubleLabelTableViewCell: UITableViewCell {
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData() {
        leftLabel.textColor = ThemeSettings.sharedInstance.fontColor
        rightLabel.textColor = ThemeSettings.sharedInstance.blueFontColor
        self.contentView.backgroundColor = ThemeSettings.sharedInstance.cellBackgroundColor
    }
    
}
