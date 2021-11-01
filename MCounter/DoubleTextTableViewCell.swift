//
//  DoubleTextTableViewCell.swift
//  MCounter
//
//  Created by apple on 3/23/20.
//  Copyright © 2020 WeOverOne. All rights reserved.
//

import UIKit

class DoubleTextTableViewCell: UITableViewCell {
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var sepratorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingSepratorConstraint: NSLayoutConstraint!
    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    
    var switchOn:(()->Void)?
    var switchOff:(()->Void)?
    var hideSwitch = true
    var hideImage = true
    var fullSeprator = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func onSwitchValueChanged() {
        if switchView.isOn {
            if let handler = switchOn {
                handler()
            }
        }
        else {
            if let handler = switchOff {
                handler()
            }
        }
    }
    
    func initialDataSetUp() {
        
        switchView.tintColor = ThemeSettings.sharedInstance.themeSwitchColor
        switchView.onTintColor = ThemeSettings.sharedInstance.themeSwitchColor
        switchView.addTarget(self, action: #selector(onSwitchValueChanged), for: .touchUpInside)
        
        rightLabel.textColor = ThemeSettings.sharedInstance.blueFontColor
        
        self.topTitleLabel.textColor = ThemeSettings.sharedInstance.fontColor
        self.contentView.backgroundColor = ThemeSettings.sharedInstance.cellBackgroundColor
        topTitleLabel.textColor = ThemeSettings.sharedInstance.fontColor
        bottomLabel.textColor = ThemeSettings.sharedInstance.settingsHeaderCellFontColor
        
        imageview.image = ThemeSettings.sharedInstance.arrowImage
        imageview.tintColor = ThemeSettings.sharedInstance.srrowTintColor
        
        if hideSwitch {
            switchView.alpha = 0
            rightLabel.alpha = 1
        }
        else {
            switchView.alpha = 1
            rightLabel.alpha = 0
        }
        
        if hideImage {
            imageview.alpha = 0
        }
        else {
            imageview.alpha = 1
            switchView.alpha = 0
            rightLabel.alpha = 0
        }
        
        if fullSeprator {
            leadingSepratorConstraint.constant = 0
        }
        else {
            leadingSepratorConstraint.constant = 16
        }
        
    }
    
}
