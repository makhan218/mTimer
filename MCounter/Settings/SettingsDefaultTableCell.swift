//
//  SettingsDefaultTableCell.swift
//  MCounter
//
//  Created by apple on 4/23/19.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import UIKit

class SettingsDefaultTableCell: UITableViewCell {
    @IBOutlet weak var switchOutlet: UISwitch!
    @IBOutlet weak var leftLabel: UILabel!
//    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var selectedDataLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var seprator: UIView!
    @IBOutlet weak var sepratorLeadingConstraint: NSLayoutConstraint!
    
    var autoDayNightCell = false
    var darkTheme = false 
    var isSwitchHidden = false
    var isDataLabelHidden = true
    var historyCell = false 
    var switchChange:(()-> Void)?
    var isLastCell = false 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        switchOutlet.tintColor = ThemeSettings.sharedInstance.themeSwitchColor
        switchOutlet.onTintColor = ThemeSettings.sharedInstance.themeSwitchColor
        setInitialData()
        switchOutlet.addTarget(self, action: #selector(onSwitchValueChanged), for: .touchUpInside)
        
    }
    @objc func onSwitchValueChanged(_ switch: UISwitch) {
        if let switchchange = switchChange,  !autoDayNightCell{
            switchchange()
        }
        else {
            if LocationServices.sharedInstance.locationAllowed {
                AppStateStore.shared.autoDayNightOn = !AppStateStore.shared.autoDayNightOn
                if let switchchange = switchChange {
                    switchchange()
                }
            }
            else {
                LocationServices.sharedInstance.checkAndManageAccess()
                if let switchchange = switchChange {
                    switchchange()
                }
            }
        }
        
    }
    
    func setInitialData() {
        seprator.backgroundColor = ThemeSettings.sharedInstance.seperatorColor
        self.contentView.backgroundColor = ThemeSettings.sharedInstance.cellBackgroundColor
        leftLabel.textColor = ThemeSettings.sharedInstance.fontColor
//        leftLabel.font = ThemeSettings.sharedInstance.font17
        selectedDataLabel.textColor = ThemeSettings.sharedInstance.settingsHeaderCellFontColor
        
        selectedDataLabel.textColor = ThemeSettings.sharedInstance.blueFontColor
        
        seprator.alpha = 1
        
        if isSwitchHidden {
            switchOutlet.alpha = 0
//            arrowImage.alpha = 1
            
            if isDataLabelHidden {
                selectedDataLabel.alpha = 0
            }
            else {
                selectedDataLabel.alpha = 1
            }
            
//            arrowImage.image = ThemeSettings.sharedInstance.arrowImage
//            arrowImage.tintColor = ThemeSettings.sharedInstance.srrowTintColor

        }
        else {
            switchOutlet.alpha = 1
//            arrowImage.alpha = 0
            selectedDataLabel.alpha = 0
        }
        if historyCell {
            streakLabel.alpha = 1
            topConstraint.constant = 10
            bottomConstraint.constant = 30
            streakLabel.textColor = ThemeSettings.sharedInstance.settingsHeaderCellFontColor
            sepratorLeadingConstraint.constant = 0
            streakLabel.text = "Streak " + String(AppStateStore.shared.streakDays) + " days"
            
        }
        else {
            streakLabel.alpha = 0
            topConstraint.constant = 11
            bottomConstraint.constant = 11
            sepratorLeadingConstraint.constant = 16
            if isLastCell {
//                    sepratorLeadingConstraint.constant = 0
                seprator.alpha = 0
            }
        }
        
    }
    
    func setLabels(mainLabel:String, dataLabel:String) {
        leftLabel.text = mainLabel
        selectedDataLabel.text = dataLabel
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
