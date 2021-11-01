//
//  DisplayViewController.swift
//  MCounter
//
//  Created by apple on 4/8/20.
//  Copyright © 2020 WeOverOne. All rights reserved.
//

import UIKit

class DisplayViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var lightTopView: UIView!
    @IBOutlet weak var lightBottomView: UIView!
   
    @IBOutlet weak var darkTopView: UIView!
    @IBOutlet weak var darkBottomView: UIView!
    @IBOutlet weak var lightLabel: UILabel!
    @IBOutlet weak var darkLabel: UILabel!
    @IBOutlet weak var firstStrioView: UIView!
    @IBOutlet weak var firstStripLeftLabel: UILabel!
   
    @IBOutlet weak var firstStripRightLabel: UILabel!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var secondStripView: UIView!
    @IBOutlet weak var graphicLabel: UILabel!
    
    @IBOutlet weak var graphicsInfoLabel: UILabel!
    @IBOutlet weak var lightDot1: UIView!
    @IBOutlet weak var lightDot2: UIView!
    @IBOutlet weak var lightDot3: UIView!
    @IBOutlet weak var lightDot4: UIView!
    @IBOutlet weak var lightDot5: UIView!
    @IBOutlet weak var lightDot6: UIView!
    @IBOutlet weak var lightDot7: UIView!
    @IBOutlet weak var lightDot8: UIView!
    
    @IBOutlet weak var darkDot1: UIView!
    @IBOutlet weak var darkDot2: UIView!
    @IBOutlet weak var darkDot3: UIView!
    @IBOutlet weak var darkDot4: UIView!
    @IBOutlet weak var darkDot5: UIView!
    @IBOutlet weak var darkDot6: UIView!
    @IBOutlet weak var darkDot7: UIView!
    @IBOutlet weak var darkDot8: UIView!
    
    var themeColorSelected:ThemeColor!
    var reloadTimerHandler: (()-> Void)?
    
    static func instance() -> DisplayViewController {
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        
        let DisplayViewController = storyboard.instantiateViewController(withIdentifier: "DisplayViewController") as! DisplayViewController
        return DisplayViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        themeColorSelected = ThemeSettings.sharedInstance.selectedColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
       firstStrioView.addGestureRecognizer(tap)

        setupView()

    }
    
    func setPreview() {
        lightTopView.backgroundColor = themeColorSelected.lightTop
        lightBottomView.backgroundColor = themeColorSelected.lightBottom
        lightDot(color:themeColorSelected.lightDot)
        
        darkTopView.backgroundColor = themeColorSelected.darkTop
        darkBottomView.backgroundColor = themeColorSelected.darkBottom
        darktDot(color: themeColorSelected.darkDot)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setPreview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let handler = reloadTimerHandler {
            handler()
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        let VC = ColorCollectionViewController.instance()
        
        VC.reloadTimerHandler = self.reloadTimerHandler
        VC.reloadSuperView = { [weak self] colorNumber in
            
            self?.setupView()
            self?.view.layoutSubviews()
            self?.view.layoutIfNeeded()
            self?.themeColorSelected = ThemeSettings.sharedInstance.colorsArray[colorNumber]
            ThemeSettings.sharedInstance.updateTheme()
            self?.firstStripRightLabel.text = ThemeSettings.sharedInstance.selectedColor.name
            
        }
      
        let modalViewController = VC
        modalViewController.modalPresentationStyle = .overCurrentContext

        self.present(modalViewController, animated: true, completion: nil)
        CFRunLoopWakeUp(CFRunLoopGetCurrent())
        
    }
    
    func lightDot(color:UIColor) {
        lightDot1.layer.cornerRadius = lightDot1.bounds.width / 2
        lightDot2.layer.cornerRadius = lightDot2.bounds.width / 2
        lightDot3.layer.cornerRadius = lightDot3.bounds.width / 2
        lightDot4.layer.cornerRadius = lightDot4.bounds.width / 2
        lightDot5.layer.cornerRadius = lightDot5.bounds.width / 2
        lightDot6.layer.cornerRadius = lightDot6.bounds.width / 2
        lightDot7.layer.cornerRadius = lightDot7.bounds.width / 2
        lightDot8.layer.cornerRadius = lightDot8.bounds.width / 2
        
        lightDot1.backgroundColor = color
        lightDot2.backgroundColor = color
        lightDot3.backgroundColor = color
        lightDot4.backgroundColor = color
        lightDot5.backgroundColor = color
        lightDot6.backgroundColor = color
        lightDot7.backgroundColor = color
        lightDot8.backgroundColor = color
        
    }
    
    func darktDot(color:UIColor) {
        darkDot1.layer.cornerRadius = darkDot1.bounds.width / 2
        darkDot2.layer.cornerRadius = darkDot2.bounds.width / 2
        darkDot3.layer.cornerRadius = darkDot3.bounds.width / 2
        darkDot4.layer.cornerRadius = darkDot4.bounds.width / 2
        darkDot5.layer.cornerRadius = darkDot5.bounds.width / 2
        darkDot6.layer.cornerRadius = darkDot6.bounds.width / 2
        darkDot7.layer.cornerRadius = darkDot7.bounds.width / 2
        darkDot8.layer.cornerRadius = darkDot8.bounds.width / 2
        
        darkDot1.backgroundColor = color
        darkDot2.backgroundColor = color
        darkDot3.backgroundColor = color
        darkDot4.backgroundColor = color
        darkDot5.backgroundColor = color
        darkDot6.backgroundColor = color
        darkDot7.backgroundColor = color
        darkDot8.backgroundColor = color
    }

    func setupView() {
        
        self.view.backgroundColor = ThemeSettings.sharedInstance.weeklyCellBackColor
        headerView.backgroundColor = ThemeSettings.sharedInstance.cellBackgroundColor
        headerLabel.textColor = ThemeSettings.sharedInstance.fontColor
        
        darkLabel.textColor = ThemeSettings.sharedInstance.fontColor
        lightLabel.textColor = ThemeSettings.sharedInstance.fontColor
        
        secondStripView.backgroundColor = ThemeSettings.sharedInstance.historyLogBackColor
        firstStrioView.backgroundColor = ThemeSettings.sharedInstance.historyLogBackColor
        
        firstStripLeftLabel.textColor = ThemeSettings.sharedInstance.fontColor
        graphicLabel.textColor = ThemeSettings.sharedInstance.historyLogFontColor
        
        previewLabel.textColor = ThemeSettings.sharedInstance.settingsHeaderCellFontColor
        selectLabel.textColor = ThemeSettings.sharedInstance.settingsHeaderCellFontColor
        firstStripRightLabel.textColor = ThemeSettings.sharedInstance.blueFontColor
        
        firstStripRightLabel.text = ThemeSettings.sharedInstance.selectedColor.name
        
        lightTopView.clipsToBounds = true
        lightTopView.layer.cornerRadius = 5
        if #available(iOS 11.0, *) {
            lightTopView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
        
        darkTopView.clipsToBounds = true
        darkTopView.layer.cornerRadius = 5
        if #available(iOS 11.0, *) {
            darkTopView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
        
        lightBottomView.clipsToBounds = true
        lightBottomView.layer.cornerRadius = 5
        if #available(iOS 11.0, *) {
            lightBottomView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
        
        darkBottomView.clipsToBounds = true
        darkBottomView.layer.cornerRadius = 5
        if #available(iOS 11.0, *) {
            darkBottomView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
        
        backButton.setTitleColor(ThemeSettings.sharedInstance.backButtonColor, for: .normal)
        backButton.setImage(ThemeSettings.sharedInstance.arrowImageLeft, for: .normal)
        backButton.tintColor = ThemeSettings.sharedInstance.backButtonColor
        backButton.imageView?.alpha = 0.5
        setPreview()
        
    }
    @IBAction func backAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
