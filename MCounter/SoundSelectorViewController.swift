//
//  SoundSelectorViewController.swift
//  MCounter
//
//  Created by apple on 7/19/19.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import UIKit
import PickerView
import AVFoundation
import MediaPlayer

enum soundType:String, CaseIterable {
    case tibetanCrystal = "Tibetan crystal"
    case tibetanSingingBowl = "Crystal bowl"
    case tibetanCrystalBowl = "Singing bowl"
    case singingBirds   = "Bird chirping"
    
}

class SoundSelectorViewController: UIViewController, PickerViewDelegate, PickerViewDataSource {
    
    @IBOutlet weak var pickerViewTop: UIView!
    @IBOutlet weak var pickerViewBottom: UIView!
    @IBOutlet weak var pickerView: PickerView!
    
    var pickerDataSource:[String] = []
    
    var initialTwoChecks = 0
    var reloadSettingsHandler: (()->Void)?
    @IBOutlet weak var pickerviewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pickerActionBar: UIView!
    @IBOutlet weak var pickerBottomView: UIView!
    @IBOutlet weak var actionBarSeperator: UIView!
    @IBOutlet weak var actionbarSepratorConstraint: NSLayoutConstraint!
    
    var player: AVAudioPlayer?
    
    var isWarmup = false
    
    
    static func instance() -> SoundSelectorViewController {
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        
        let SoundSelectorViewController = storyboard.instantiateViewController(withIdentifier: "SoundSelectorViewController") as! SoundSelectorViewController
        return SoundSelectorViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.pickerViewTop.isUserInteractionEnabled = false
        self.pickerViewBottom.isUserInteractionEnabled = false

        self.pickerView.dataSource = self
        self.pickerView.delegate = self

        for name in soundType.allCases {
            pickerDataSource.append(name.rawValue)
        }
        
//        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.view.backgroundColor = .clear
        pickerView.tableView.backgroundColor = ThemeSettings.sharedInstance.backgroundColor
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(backtoSettingsAction))
        singleTap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(singleTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UIScreen.main.bounds.width > 413 || (UIScreen.main.bounds.width == 375.0 && UIScreen.main.bounds.height == 812.0) {
            actionbarSepratorConstraint.constant = 0.3
        }
        else {
            actionbarSepratorConstraint.constant = 0.5
        }
        
        pickerView.backgroundColor = ThemeSettings.sharedInstance.pickerActionBarColor
        pickerViewTop.backgroundColor = ThemeSettings.sharedInstance.pickerActionBarColor
        pickerViewBottom.backgroundColor = ThemeSettings.sharedInstance.pickerActionBarColor
        
        cancelButton.setTitleColor(ThemeSettings.sharedInstance.fadedButtonTextColor, for: .normal)
//        SoundName.font = ThemeSettings.sharedInstance.font21
//        SoundName.textColor = ThemeSettings.sharedInstance.fontColor
//        leftTitleLabel.font = ThemeSettings.sharedInstance.font21
//        leftTitleLabel.textColor = ThemeSettings.sharedInstance.fontColor
//        viewControllerLabel.font = ThemeSettings.sharedInstance.font28
//        viewControllerLabel.textColor = ThemeSettings.sharedInstance.fontColor
        
        if !ThemeSettings.sharedInstance.darkTheme {
            pickerViewBottom.alpha = 0.9
            pickerViewTop.alpha = 0.9
        }
        else {
            pickerViewBottom.alpha = 0.7
            pickerViewTop.alpha = 0.7
        }
        
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

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isWarmup {
            pickerView.tableView.scrollToRow(at: IndexPath(row: getNumberFromEnum(Sound: AppStateStore.shared.selectedWarmupSound) , section: 0), at: UITableView.ScrollPosition.middle, animated: false)
        }
        else {
            pickerView.tableView.scrollToRow(at: IndexPath(row: getNumberFromEnum(Sound: AppStateStore.shared.selectedSound) , section: 0), at: UITableView.ScrollPosition.middle, animated: false)
        }
        
        
        pickerviewBottomConstraint.constant = 0
        
        pickerActionBar.backgroundColor = ThemeSettings.sharedInstance.pickerActionBarColor
        
        doneButton.setTitleColor(ThemeSettings.sharedInstance.themeButtonColor, for: .normal)

        actionBarSeperator.backgroundColor = ThemeSettings.sharedInstance.pickerActionBarSeprator
        pickerBottomView.backgroundColor = ThemeSettings.sharedInstance.pickerActionBarColor
    
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        }
        if isWarmup {
            pickerView.tableView.scrollToRow(at: IndexPath(row: getNumberFromEnum(Sound: AppStateStore.shared.selectedWarmupSound) , section: 0), at: UITableView.ScrollPosition.middle, animated: false)
        }
        else {
            pickerView.tableView.scrollToRow(at: IndexPath(row: getNumberFromEnum(Sound: AppStateStore.shared.selectedSound) , section: 0), at: UITableView.ScrollPosition.middle, animated: false)
        }
//         pickerView.tableView.scrollToRow(at: IndexPath(row: getNumberFromEnum(Sound: AppStateStore.shared.selectedSound) , section: 0), at: UITableView.ScrollPosition.middle, animated: false)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let handler = self.reloadSettingsHandler {
            handler()
        }
        
        self.view.backgroundColor = .clear
        
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
        
        let sound = getEnum(number: pickerView.currentSelectedRow)
        
        if isWarmup {
            AppStateStore.shared.selectedWarmupSound = sound
        }
        else {
            AppStateStore.shared.selectedSound = sound
        }
        
                
        pickerviewBottomConstraint.constant = -300
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }) { (flag) in
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    

    
    @objc func backtoSettingsAction(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        pickerviewBottomConstraint.constant = -300
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }) { (flag) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func getEnum(number:Int) -> soundType {
        switch number {
        case 0:
           return soundType.tibetanCrystal
        case 1:
            return soundType.tibetanSingingBowl
        case 2:
            return soundType.tibetanCrystalBowl
        case 3:
            return soundType.singingBirds
        default:
            return soundType.tibetanCrystal
        }
    }
    
    func getNumberFromEnum(Sound:soundType) ->Int {
        switch Sound {
        case .tibetanCrystal:
            return 0
        case .tibetanSingingBowl:
            return 1
        case .tibetanCrystalBowl:
            return 2
        case .singingBirds:
            return 3
        }
    }
    

}



extension SoundSelectorViewController {
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
        
        let sound = getEnum(number: row)
        
        playSound(playName:soundName(sound: sound))
//        AppStateStore.shared.selectedSound = sound
    }
    
    
    func soundName(sound:soundType)-> String {
        
        switch sound {
        case .tibetanCrystal:
            return "TibetanCrystal"
        case .tibetanCrystalBowl:
            return "Tibetan-Crystal–Singing–Bowl"
        case .tibetanSingingBowl:
            return "Tibetan-Crystal-Singing-Bowl-2"
        case .singingBirds:
            return "Single-Bird-Chirps"
        }
    }
    
    
    func playSound(playName:String) {

            
            guard let url = Bundle.main.url(forResource: playName, withExtension: "mp3") else { return }
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                guard let player = player else { return }
                let volumeView = MPVolumeView()
                
                if let view = volumeView.subviews.first as? UISlider
                {
                    view.value = 0.1   // set b/w 0 t0 1.0
                }
                
                let volume = MPVolumeView()
                
                if let view = volume.subviews.first as? UISlider{
                    view.value = 1.0 //---0 t0 1.0---
                    
                }
                
                player.volume = 1.0
                player.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    
    
}
