//
//  logDataCell.swift
//  MCounter
//
//  Created by apple on 5/6/19.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import UIKit

class logDataCell: UITableViewCell {
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var cellStyle:LogCellStyle = .log
    var lastCell = false
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var rightLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var topBorder: UIView!
    @IBOutlet weak var bottomBorder: UIView!
    @IBOutlet weak var leftConstraintSeprator: NSLayoutConstraint!
    @IBOutlet weak var topBoarderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomBoarderHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code


    }
    
    func setUpCell() {
        
        if UIScreen.main.bounds.width > 413 || (UIScreen.main.bounds.width == 375.0 && UIScreen.main.bounds.height == 812.0) {
            topBoarderHeightConstraint.constant = 0.3
            bottomBoarderHeightConstraint.constant = 0.3
        }
        else {
            topBoarderHeightConstraint.constant = 0.5
            bottomBoarderHeightConstraint.constant = 0.5
        }
        
        topBorder.backgroundColor = ThemeSettings.sharedInstance.seperatorColor
        if lastCell {
            bottomBorder.backgroundColor = .clear
        
        }
        else {
            bottomBorder.backgroundColor = ThemeSettings.sharedInstance.seperatorColor
            
//                ThemeSettings.sharedInstance.seperatorColor
        }
        
            
        self.contentView.backgroundColor = ThemeSettings.sharedInstance.historyLogBackColor
        self.backgroundColor = ThemeSettings.sharedInstance.historyLogBackColor
        self.backgroundView?.backgroundColor = ThemeSettings.sharedInstance.historyLogBackColor
        arrowImage.alpha = 0
        bottomBorder.alpha = 1
        if cellStyle == .headding {
            
            topBorder.alpha = 1
            self.backgroundColor = ThemeSettings.sharedInstance.weeklyCellBackColor
            self.backgroundView?.backgroundColor = ThemeSettings.sharedInstance.weeklyCellBackColor
         
            topConstraint.constant = 13
            bottomConstraint.constant = 10
//            rightLabel.font = ThemeSettings.sharedInstance.font17
            leftLabel.font = ThemeSettings.sharedInstance.font17
            rightLabel.textColor = ThemeSettings.sharedInstance.settingsHeaderCellFontColor
            leftLabel.textColor = ThemeSettings.sharedInstance.settingsHeaderCellFontColor
            rightLabel.textColor = ThemeSettings.sharedInstance.settingsHeaderCellFontColor
            leftLabel.textColor = ThemeSettings.sharedInstance.fontColor
            rightLabelConstraint.constant = -7
            self.contentView.backgroundColor = ThemeSettings.sharedInstance.historyLogBackColor
            leftConstraintSeprator.constant = 0
        }
        else if cellStyle == .week {
            
           
     //       self.contentView.backgroundColor = ThemeSettings.sharedInstance.historyLogBackColor
            
       //     topConstraint.constant = 23
         //               bottomConstraint.constant = 7
            //            rightLabel.font = ThemeSettings.sharedInstance.font17
      //                  leftLabel.font = ThemeSettings.sharedInstance.font17
    //                    rightLabel.textColor = ThemeSettings.sharedInstance.historyLogFontColor
  //                      leftLabel.textColor = ThemeSettings.sharedInstance.historyLogFontColor
            
        }
        else {
            leftConstraintSeprator.constant = 16
            topBorder.alpha = 0
//            arrowImage.alpha = 1
            topConstraint.constant = 13
            bottomConstraint.constant = 10
//            rightLabel.font = ThemeSettings.sharedInstance.font15
            leftLabel.font = ThemeSettings.sharedInstance.fontMono17
            rightLabelConstraint.constant = -7
            self.contentView.backgroundColor = ThemeSettings.sharedInstance.historyLogBackColor
            rightLabel.textColor = ThemeSettings.sharedInstance.settingsHeaderCellFontColor
            leftLabel.textColor = ThemeSettings.sharedInstance.fontColor
            
            if lastCell {
//                bottomBorder.backgroundColor = UIColor(alp)
                bottomConstraint.constant = 7
                
            }
            
        }
        self.backgroundView?.backgroundColor  = ThemeSettings.sharedInstance.historyLogBackColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
