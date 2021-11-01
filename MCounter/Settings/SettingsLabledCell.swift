//
//  SettingsLabledCell.swift
//  MCounter
//
//  Created by apple on 4/23/19.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import UIKit

class SettingsLabledCell: UITableViewCell {
    @IBOutlet weak var tapLeftLabel: UILabel!
    @IBOutlet weak var seprator: UIView!
    @IBOutlet weak var topSeprator: UIView!
    @IBOutlet weak var topSepratorConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomSepratorConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    func initialData() {
        
        if UIScreen.main.bounds.width > 413 || (UIScreen.main.bounds.width == 375.0 && UIScreen.main.bounds.height == 812.0) {
            topSepratorConstraint.constant = 0.3
            bottomSepratorConstraint.constant = 0.3
        }
        else {
            topSepratorConstraint.constant = 0.5
            bottomSepratorConstraint.constant = 0.5
        }

        seprator.backgroundColor = ThemeSettings.sharedInstance.seperatorColor
        seprator.alpha = 1
        topSeprator.backgroundColor = ThemeSettings.sharedInstance.seperatorColor
        topSeprator.alpha = 1
        tapLeftLabel.text = ""
        tapLeftLabel.font = ThemeSettings.sharedInstance.settingsHeaderCellFont
        tapLeftLabel.textColor = ThemeSettings.sharedInstance.settingsHeaderCellFontColor
    
        self.backgroundColor = ThemeSettings.sharedInstance.settingsHeaderCellBackgroung
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
