//
//  IntervelViewController.swift
//  MCounter
//
//  Created by apple on 7/3/19.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import UIKit
import PickerView


class IntervelViewController: UIViewController {
    
    var pickerDataSource:[Int] = []
    
    var initialTwoChecks = 0
    var reloadSettingsHandler: (()->Void)?
    
    static func instance() -> IntervelViewController {
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        
        let intervelViewController = storyboard.instantiateViewController(withIdentifier: "IntervelViewController") as! IntervelViewController
        return intervelViewController
    }

    @IBOutlet weak var customPicker: PickerView!
    @IBOutlet weak var pickerViewTop: UIView!
    @IBOutlet weak var pickerViewBottom: UIView!
    @IBOutlet weak var pickerviewBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pickerActionBar: UIView!
    @IBOutlet weak var pickerBottomView: UIView!
    @IBOutlet weak var actionBarSeperator: UIView!
    @IBOutlet weak var actionbarSepratorConstraint: NSLayoutConstraint!
    
//    @IBOutlet weak var leftTitleLabel: UILabel!
//    @IBOutlet weak var numberLabel: UILabel!
//    @IBOutlet weak var viewControllerTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customPicker.delegate = self
        customPicker.dataSource = self
        pickerViewTop.isUserInteractionEnabled = false

        pickerViewBottom.isUserInteractionEnabled = false
        pickerViewTop.alpha = 0.9
        pickerViewBottom.alpha = 0.9
        
        if !ThemeSettings.sharedInstance.darkTheme {
            if #available(iOS 13.0, *) {
                // Always adopt a light interface style.
                overrideUserInterfaceStyle = .light
            }
        }
        else {
            if #available(iOS 13.0, *) {
                // Always adopt a light interface style.
                overrideUserInterfaceStyle = .dark
            }
            
        }
        
        
        
        
        self.view.backgroundColor = .clear
//        numberLabel.text = String(AppStateStore.shared.warmupTimerIntervel)
//        customPicker.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        for i in 0...60{
            pickerDataSource.append(i)
        }
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(closeButtonAction))
        singleTap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(singleTap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
//            UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        if UIScreen.main.bounds.width > 413 || (UIScreen.main.bounds.width == 375.0 && UIScreen.main.bounds.height == 812.0){
            actionbarSepratorConstraint.constant = 0.3
        }
        else {
            actionbarSepratorConstraint.constant = 0.5
        }

        customPicker.backgroundColor = ThemeSettings.sharedInstance.pickerActionBarColor
        pickerViewTop.backgroundColor = ThemeSettings.sharedInstance.pickerActionBarColor
        pickerViewBottom.backgroundColor = ThemeSettings.sharedInstance.pickerActionBarColor
        cancelButton.setTitleColor(ThemeSettings.sharedInstance.fadedButtonTextColor, for: .normal)
        pickerActionBar.backgroundColor = ThemeSettings.sharedInstance.pickerActionBarColor
        
        doneButton.setTitleColor(ThemeSettings.sharedInstance.backButtonColor, for: .normal)

        actionBarSeperator.backgroundColor = ThemeSettings.sharedInstance.pickerActionBarSeprator
        pickerBottomView.backgroundColor = ThemeSettings.sharedInstance.pickerActionBarColor
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
        customPicker.tableView.scrollToRow(at: IndexPath(row: AppStateStore.shared.warmupTimerIntervel  , section: 0), at: UITableView.ScrollPosition.middle, animated: false)
        
        
        pickerviewBottomConstraint.constant = 0
        
            UIView.animate(withDuration: 0.3) {
                self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
                self.view.layoutIfNeeded()
                
            }
        
        customPicker.tableView.scrollToRow(at: IndexPath(row: AppStateStore.shared.warmupTimerIntervel  , section: 0), at: UITableView.ScrollPosition.middle, animated: false)
    }
    
    @objc func closeButtonAction(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
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
    
    
    @IBAction func doneAction(_ sender: Any) {
        
        
        AppStateStore.shared.warmupTimerIntervel = pickerDataSource[customPicker.currentSelectedRow]
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
        if let handler = self.reloadSettingsHandler {
            handler()
        }
    }

}

extension IntervelViewController: PickerViewDelegate, PickerViewDataSource {
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
    //        pickerView.backgroundColor =
            label.textColor = ThemeSettings.sharedInstance.fontColor
            label.font = ThemeSettings.sharedInstance.font21
        }
    
    func pickerView(_ pickerView: PickerView, didSelectRow row: Int) {
        
        if initialTwoChecks < 2 {
            initialTwoChecks += 1
            return
        }
//        numberLabel.text = String(pickerDataSource[row])
//        AppStateStore.shared.warmupTimerIntervel = pickerDataSource[row]
    }
    
    
}

