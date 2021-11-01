//
//  CollectionViewColorCell.swift
//  MCounter
//
//  Created by apple on 4/12/20.
//  Copyright © 2020 WeOverOne. All rights reserved.
//

import UIKit

class CollectionViewColorCell: UICollectionViewCell {



    @IBOutlet weak var centerCircle: SemiCirleView!
    @IBOutlet weak var bottomSemiCircle: SemiCirleView!
    @IBOutlet weak var selectionView: UIView!
    
     
     var isSelectedCell = true
     
     override func awakeFromNib() {
         super.awakeFromNib()
         // Initialization code
         
        bottomSemiCircle.clockWise = false
         
         selectionView.layer.cornerRadius = selectionView.bounds.width / 2

     }
     
     func selectedCell() {
         
         if isSelectedCell {
             selectionView.layer.borderWidth = 2
             selectionView.layer.borderColor = ThemeSettings.sharedInstance.fontColor.cgColor
         }
         else {
             selectionView.layer.borderWidth = 0
             selectionView.layer.borderColor = UIColor.clear.cgColor
         }
         
     }
    

}
