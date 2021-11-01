//
//  CollectionViewCounterCell.swift
//  MCounter
//
//  Created by Muhammad Ahmad on 22/03/2019.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import UIKit

class CollectionViewCounterCell: UICollectionViewCell {
    
    @IBOutlet weak var centerCircle: CircleTimer!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupCell() {
    }

}
