//
//  ModeSelectionViewController.swift
//  MCounter
//
//  Created by apple on 11/4/19.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import UIKit
import PickerView

enum ThemeModes:String, CaseIterable {
    case alwaysWhite = "Always light"
    case alwaysDark = "Always dark"
    case phoneUse   = "Use iPhone settings"
    
}


class ModeSelectionViewController: UIViewController, UIPickerViewDelegate {
    
    static func instance() -> ModeSelectionViewController {
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        
        let ModeSelectionViewController = storyboard.instantiateViewController(withIdentifier: "ModeSelectionViewController") as! ModeSelectionViewController
        return ModeSelectionViewController
    }
    @IBOutlet weak var pickerView: PickerView!
    @IBOutlet weak var pickerViewTop: UIView!
    @IBOutlet weak var pickerViewBottom: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var actionBar: UIView!
    @IBOutlet weak var pickerviewBottomView: UIView!
    @IBOutlet weak var actionBarSeperator: UIView!
    
    @IBOutlet weak var pickerviewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var actionbarHeightConstraint: NSLayoutConstraint!
    
        
    var pickerDataSource:[String] = []
    var initialTwoChecks = 0
    var reloadSettingsHandler: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerViewTop.isUserInteractionEnabled = false
        pickerViewBottom.isUserInteractionEnabled = false 
        if #available(iOS 13.0, *) {
            for name in ThemeModes.allCases {
                pickerDataSource.append(name.rawValue)
            }
        } else {
            pickerDataSource.append(ThemeModes.alwaysWhite.rawValue)
            pickerDataSource.append(ThemeModes.alwaysDark.rawValue)
            
        }
        pickerView.selectRow(getNumberFromEnum(mode: AppStateStore.shared.selectedMode), animated: false)
        pickerView.backgroundColor = ThemeSettings.sharedInstance.backgroundColor
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(backToSettingsAction))
        singleTap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(singleTap)
        view.backgroundColor = .clear
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        
        pickerView.backgroundColor = ThemeSettings.sharedInstance.pickerActionBarColor
        pickerViewTop.backgroundColor = ThemeSettings.sharedInstance.pickerActionBarColor
        pickerViewBottom.backgroundColor = ThemeSettings.sharedInstance.pickerActionBarColor
        
        actionBar.backgroundColor = ThemeSettings.sharedInstance.pickerActionBarColor
        
        doneButton.setTitleColor(ThemeSettings.sharedInstance.themeButtonColor, for: .normal)

        cancelButton.setTitleColor(ThemeSettings.sharedInstance.fadedButtonTextColor, for: .normal)
        actionBarSeperator.backgroundColor = ThemeSettings.sharedInstance.pickerActionBarSeprator
        pickerviewBottomView.backgroundColor = ThemeSettings.sharedInstance.pickerActionBarColor

                if !ThemeSettings.sharedInstance.darkTheme {
                    pickerViewBottom.alpha = 0.8
                    pickerViewTop.alpha = 0.8
                }
                else {
                    pickerViewBottom.alpha = 0.7
                    pickerViewTop.alpha = 0.7
                }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UIScreen.main.bounds.width > 413 || (UIScreen.main.bounds.width == 375.0 && UIScreen.main.bounds.height == 812.0){
            actionbarHeightConstraint.constant = 0.3
        }
        else {
            actionbarHeightConstraint.constant = 0.5
        }
        pickerviewBottomConstraint.constant = 0
        
            UIView.animate(withDuration: 0.3) {
                self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
                self.view.layoutIfNeeded()
                
            }
    }
    

    func setupView() {
        
        for name in soundType.allCases {
            pickerDataSource.append(name.rawValue)
        }
    }

    @objc func backToSettingsAction(_ sender: Any) {
        pickerviewBottomConstraint.constant = -300
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }) { (flag) in
            self.dismiss(animated: false, completion: nil)
        }
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        
        let row = pickerView.currentSelectedRow ?? 0
        
        let mode = getEnum(number: row)

        AppStateStore.shared.selectedMode = mode
        
        pickerviewBottomConstraint.constant = -300
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }) { (flag) in
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        pickerviewBottomConstraint.constant = -300
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }) { (flag) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        checkUserSelectedMode()
        if let handler = self.reloadSettingsHandler {
            handler()
        }
    }
    
}

extension ModeSelectionViewController:PickerViewDelegate, PickerViewDataSource{
    

    func pickerViewHeightForRows(_ pickerView: PickerView) -> CGFloat {
            return 32
        }
        
    func pickerViewNumberOfRows(_ pickerView: PickerView) -> Int {
            return pickerDataSource.count
        }
        
        
    func pickerView(_ pickerView: PickerView, titleForRow row: Int) -> String {
            return String(pickerDataSource[row])
        }
        
    func pickerView(_ pickerView: PickerView, styleForLabel label: UILabel, highlighted: Bool) {

                label.textColor = ThemeSettings.sharedInstance.fontColor
                label.font = ThemeSettings.sharedInstance.font21
            }
        
    func pickerView(_ pickerView: PickerView, didSelectRow row: Int) {
            
            if initialTwoChecks < 2 {
                initialTwoChecks += 1
                return
            }
        
        }
        
    
    func getEnum(number:Int) -> ThemeModes {
        switch number {
        case 0:
            return ThemeModes.alwaysWhite
        case 1:
            return ThemeModes.alwaysDark
        case 2:
            return ThemeModes.phoneUse
        default:
            return ThemeModes.alwaysWhite
        }
    }
    
    func getNumberFromEnum(mode:ThemeModes) ->Int {
        switch mode {
        case .alwaysWhite:
            return 0
        case .alwaysDark:
            return 1
        case .phoneUse:
            return 2
       
        }
    }
    
    
    func checkUserSelectedMode() {
        if AppStateStore.shared.selectedMode == .alwaysDark {
            ThemeSettings.sharedInstance.setDarkTheme()
        }
        else if AppStateStore.shared.selectedMode == .alwaysWhite {
            ThemeSettings.sharedInstance.setLightTheme()
        }
        else if AppStateStore.shared.selectedMode == .phoneUse {
            if #available(iOS 13.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    // User Interface is Dark
                    ThemeSettings.sharedInstance.setDarkTheme()
                } else {
                    ThemeSettings.sharedInstance.setLightTheme()
                    print("Light shines")
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    
}

