//
//  HeaderLogCell.swift
//  MCounter
//
//  Created by apple on 2/20/20.
//  Copyright © 2020 WeOverOne. All rights reserved.
//

import UIKit

class HeaderLogCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var separator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupView() {
        self.contentView.backgroundColor = ThemeSettings.sharedInstance.weeklyCellBackColor
        label.textColor = ThemeSettings.sharedInstance.settingsHeaderCellFontColor
        separator.backgroundColor = ThemeSettings.sharedInstance.seperatorColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
