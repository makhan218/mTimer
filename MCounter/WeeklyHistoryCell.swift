//
//  WeeklyHistoryCell.swift
//  MCounter
//
//  Created by apple on 5/3/19.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import UIKit

class WeeklyHistoryCell: UITableViewCell {
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var darkTheme = false 
    @IBOutlet weak var arrowImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if ThemeSettings.sharedInstance.darkTheme {
            arrowImage.image = ThemeSettings.sharedInstance.arrowImage
        }
        else {
            arrowImage.image = ThemeSettings.sharedInstance.arrowImage
        }
        leftLabel.font = ThemeSettings.sharedInstance.font21
        timeLabel.font = ThemeSettings.sharedInstance.font15
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
