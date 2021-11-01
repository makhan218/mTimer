//
//  ColorCollectionViewController.swift
//  MCounter
//
//  Created by apple on 4/8/20.
//  Copyright © 2020 WeOverOne. All rights reserved.
//

import UIKit

class ColorCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var seprator: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var sepratorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionviewBottomConstraint: NSLayoutConstraint!
    
    var selectedIndex:IndexPath?
    
    var reloadSuperView: ((Int)->Void)?
    var reloadTimerHandler: (()-> Void)?
    
    static func instance() -> ColorCollectionViewController {
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        
        let ColorCollectionViewController = storyboard.instantiateViewController(withIdentifier: "ColorCollectionViewController") as! ColorCollectionViewController
        return ColorCollectionViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndex = IndexPath(item: AppStateStore.shared.ThemeNumber, section: 0)
        
        collectionview.register(UINib.init(nibName: "CollectionViewColorCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewColorCell")
        
        view.backgroundColor = .clear
        
        
        if UIScreen.main.bounds.width > 413 || (UIScreen.main.bounds.width == 375.0 && UIScreen.main.bounds.height == 812.0){
            sepratorHeightConstraint.constant = 0.3
        }
        else {
            sepratorHeightConstraint.constant = 0.5
        }
        
        seprator.backgroundColor = ThemeSettings.sharedInstance.pickerActionBarSeprator
        headerView.backgroundColor = ThemeSettings.sharedInstance.pickerActionBarColor
        collectionview.backgroundView?.backgroundColor = ThemeSettings.sharedInstance.pickerActionBarColor
        collectionview.backgroundColor = ThemeSettings.sharedInstance.pickerActionBarColor
        
        cancelButton.setTitleColor(ThemeSettings.sharedInstance.fadedButtonTextColor, for: .normal)
        doneButton.setTitleColor(ThemeSettings.sharedInstance.themeButtonColor, for: .normal)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reloadTimerHandler?()
        reloadTimerHandler?()
        if let handler = reloadSuperView {
            handler(selectedIndex?.row ?? AppStateStore.shared.ThemeNumber)
        }
    }
    
    @objc func dismissAction() {
        collectionviewBottomConstraint.constant = -300
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }) { (flag) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        collectionviewBottomConstraint.constant = -70
        UIView.animate(withDuration: 0.3) {
            
            
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            self.view.layoutIfNeeded()
        }) { (flag) in
//            let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.dismissAction))
//            singleTap.cancelsTouchesInView = false
//
//            self.view.addGestureRecognizer(singleTap)

        }
                
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        collectionviewBottomConstraint.constant = -300
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }) { (flag) in
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        
        if let selectedIndex = selectedIndex {
            AppStateStore.shared.ThemeNumber = selectedIndex.row
        }
    
        
        collectionviewBottomConstraint.constant = -300
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }) { (flag) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
}

extension ColorCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ThemeSettings.sharedInstance.colorsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewColorCell", for: indexPath) as! CollectionViewColorCell
        
            
        cell.centerCircle.colorForLayer =
            
            ThemeSettings.sharedInstance.colorsArray[Int(indexPath.row )].lightTop.cgColor

        cell.bottomSemiCircle.colorForLayer = ThemeSettings.sharedInstance.colorsArray[Int(indexPath.row )].lightBottom.cgColor

        if selectedIndex?.row ?? -1 == indexPath.row {
            cell.isSelectedCell = true
        }
        else {
            cell.isSelectedCell = false
        }
        
        
        cell.selectedCell()
    
        cell.centerCircle.setNeedsLayout()
        cell.centerCircle.layoutIfNeeded()
        cell.bottomSemiCircle.setNeedsLayout()
        cell.bottomSemiCircle.layoutIfNeeded()
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
        self.selectedIndex = indexPath
        collectionview.reloadData()
        
        if let handler = reloadSuperView {
            handler(selectedIndex?.row ?? AppStateStore.shared.ThemeNumber)
        }
        if let handler = reloadSuperView {
            handler(selectedIndex?.row ?? AppStateStore.shared.ThemeNumber)
        }
    }
    
}

extension ColorCollectionViewController:  UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 72, height: 52)
    }
    
    
}
