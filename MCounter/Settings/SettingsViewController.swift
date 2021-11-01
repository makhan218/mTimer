//
//  SettingsViewController.swift
//  MCounter
//
//  Created by apple on 4/23/19.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var topBackground: UIView!
    @IBOutlet weak var topSeperator: UIView!
    @IBOutlet weak var headerSeprator: UIView!
    @IBOutlet weak var sepratorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topSepratorHeightConstraint: NSLayoutConstraint!
    
    var reloadTimerHandler: (()-> Void)?
    
    var darkTheme = false
    var numberOfRows = 8
    
    static func instance() -> SettingsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let settingsViewController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        return settingsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "SettingsDefaultTableCell", bundle: nil), forCellReuseIdentifier: "SettingsDefaultTableCell")
        tableView.register(UINib(nibName: "SettingsLabledCell", bundle: nil), forCellReuseIdentifier: "SettingsLabledCell")
        tableView.register(UINib(nibName: "DoubleTextTableViewCell", bundle: nil), forCellReuseIdentifier: "DoubleTextTableViewCell")
        
        
        
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    @IBAction func CloseButtonAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let handler = self.reloadTimerHandler {
            handler()
        }
    }
    
    func setupView() {
        
        if UIScreen.main.bounds.width > 413 || (UIScreen.main.bounds.width == 375.0 && UIScreen.main.bounds.height == 812.0) {
            sepratorHeightConstraint.constant = 0.3
            topSepratorHeightConstraint.constant = 0.3
        }
        else {
            sepratorHeightConstraint.constant = 0.5
            topSepratorHeightConstraint.constant = 0.5
        }

        
        tableView.separatorColor = .clear
//            ThemeSettings.sharedInstance.seperatorColor
        self.topSeperator.backgroundColor = ThemeSettings.sharedInstance.seperatorColor
        headerSeprator.backgroundColor = ThemeSettings.sharedInstance.seperatorColor
        self.topBackground.backgroundColor = ThemeSettings.sharedInstance.cellBackgroundColor
//        closeButton.titleLabel?.textColor = ThemeSettings.sharedInstance.fontColor
        self.view.backgroundColor = ThemeSettings.sharedInstance.settingsHeaderCellBackgroung
        darkTheme = ThemeSettings.sharedInstance.darkTheme
        tableView.backgroundColor = ThemeSettings.sharedInstance.backgroundColor
        settingsLabel.textColor = ThemeSettings.sharedInstance.fontColor
        
        
//        closeButton.setTitleColor(ThemeSettings.sharedInstance.fontColor, for: .normal)
 

//        closeButton.setImage(ThemeSettings.sharedInstance.crossImage, for: .normal)
        
        
        let tableFooterView = UIView()
        let tvFrame = self.view.frame
        let height = tvFrame.size.height - ((0.19 * self.view.frame.height) + 205 )
        if (height > 20) { // MIN_HEIGHT is your minimum tableViewFooter height
        let frame = tableFooterView.frame
            tableFooterView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: height)
            tableFooterView.backgroundColor = ThemeSettings.sharedInstance.settingsHeaderCellBackgroung
            }
        if AppStateStore.shared.isProUser {
            let footerLabel = UILabel()
            footerLabel.text = "Thank you for supporting While."
            footerLabel.font = ThemeSettings.sharedInstance.settingsHeaderCellFont
            footerLabel.textColor = ThemeSettings.sharedInstance.settingsHeaderCellFontColor
                
            tableFooterView.addSubview(footerLabel)
            // Constraints of label to footer
            footerLabel.translatesAutoresizingMaskIntoConstraints = false
            footerLabel.leadingAnchor.constraint(equalTo: tableFooterView.leadingAnchor, constant: 16).isActive = true
            footerLabel.topAnchor.constraint(equalTo: tableFooterView.topAnchor, constant: 7).isActive = true
        }
        
        do {
            // adding seperator to footer
            let seprator = UIView()
            seprator.backgroundColor = ThemeSettings.sharedInstance.seperatorColor
            seprator.translatesAutoresizingMaskIntoConstraints = false
            
            tableFooterView.addSubview(seprator)
            if UIScreen.main.bounds.width > 413 || (UIScreen.main.bounds.width == 375.0 && UIScreen.main.bounds.height == 812.0){
                seprator.heightAnchor.constraint(equalToConstant: 0.3).isActive = true

            }
            else {
                seprator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true

            }
                        seprator.widthAnchor.constraint(equalTo: tableFooterView.widthAnchor, multiplier: 1).isActive = true
            seprator.topAnchor.constraint(equalTo: tableFooterView.topAnchor).isActive = true
            seprator.trailingAnchor.constraint(equalTo: tableFooterView.trailingAnchor, constant: 0).isActive = true
            
        }
            
        tableView.tableFooterView = tableFooterView
        
        
        closeButton.tintColor = ThemeSettings.sharedInstance.backButtonColor
        closeButton.imageView?.alpha = 0.5
        tableView.reloadData()
    }
    
}

extension SettingsViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AppStateStore.shared.isProUser {
            numberOfRows = 9
            return 9
        }
        else {
            return 7
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if !AppStateStore.shared.isProUser {
            return self.proCellForRowAtIndex(indexPath: indexPath)
        }
        
//        indexPath.row == 0 ||
        
        if  indexPath.row == 3 || indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsLabledCell") as! SettingsLabledCell
            cell.initialData()
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsDefaultTableCell") as! SettingsDefaultTableCell
            
        cell.darkTheme = self.darkTheme
        cell.autoDayNightCell = false
        cell.historyCell = false
        cell.selectionStyle = .none
        cell.isLastCell = false
        if indexPath.row == numberOfRows - 1 {
            cell.isLastCell = true 
        }
        
            switch indexPath.row {
            case 10:
                cell.leftLabel.text = "History"
                cell.isSwitchHidden = true
                cell.historyCell = true
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                cell.setInitialData()
            case 0:
                cell.leftLabel.text = "Sound"
                cell.isSwitchHidden = false
                cell.historyCell = false
                cell.setInitialData()
                cell.switchOutlet.isOn = AppStateStore.shared.soundOn
                cell.switchChange = { [weak self] in
                    AppStateStore.shared.soundOn = !AppStateStore.shared.soundOn
                    self?.tableView.reloadData()
                    
                }
            case 1:
                cell.leftLabel.text = "Vibration"
                cell.isSwitchHidden = false
                cell.historyCell = false
                cell.setInitialData()
                cell.switchOutlet.isOn = AppStateStore.shared.vibrationOn
                cell.switchChange = { [weak self] in
                    AppStateStore.shared.vibrationOn = !AppStateStore.shared.vibrationOn
                    self?.tableView.reloadData()
                }
            case 2:
                cell.selectionStyle = .none
                cell.isSwitchHidden = true
                cell.isDataLabelHidden = false
                cell.historyCell = false
                cell.setLabels(mainLabel:"Light or dark", dataLabel:AppStateStore.shared.selectedMode.rawValue)
                cell.setInitialData()
                cell.seprator.alpha = 0
                
            case 4:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "DoubleTextTableViewCell") as! DoubleTextTableViewCell
                cell.topTitleLabel.text = "Color and graphics"
                cell.bottomLabel.text = "Choose color themes & graphical shapes"
                cell.selectionStyle = .none
                cell.hideImage = false
                cell.sepratorView.alpha = 1
                cell.fullSeprator = false
                cell.initialDataSetUp()
                
                return cell
                
//                cell.selectionStyle = .none
//                cell.isSwitchHidden = true
//                cell.isDataLabelHidden = false
//                cell.historyCell = false
//                cell.setLabels(mainLabel:"Chime", dataLabel:AppStateStore.shared.selectedSound.rawValue)
//                cell.setInitialData()
            case 5:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "DoubleTextTableViewCell") as! DoubleTextTableViewCell
                cell.topTitleLabel.text = "Intervals and chimes"
                cell.bottomLabel.text = "Configure timer durations and controls"
                cell.selectionStyle = .none
                cell.hideImage = false
                cell.fullSeprator = false
                cell.initialDataSetUp()
                cell.sepratorView.alpha = 0
                
                return cell
//                cell.selectionStyle = .none
//                cell.isSwitchHidden = true
//                cell.isDataLabelHidden = false
//                cell.historyCell = false
//                cell.setLabels(mainLabel:"Warmup", dataLabel:String(AppStateStore.shared.warmupTimerIntervel) + " seconds")
//                cell.setInitialData()
                
            case 8:
                cell.leftLabel.text = "Privacy"
                cell.isSwitchHidden = true
                cell.historyCell = false
                cell.setInitialData()
                
                
            case 11:
                cell.leftLabel.text = "Membership"
                cell.isSwitchHidden = true
                cell.historyCell = false
                cell.setInitialData()
                
            case 9:
                cell.leftLabel.text = "Privacy"
                cell.isSwitchHidden = true
                cell.historyCell = false
                cell.setInitialData()
                
                
            case 7:
                cell.leftLabel.text = "Feedback"
                cell.isSwitchHidden = true
                cell.historyCell = false
                cell.setInitialData()
//            cell.leftLabel.text = "Sync Data"
//            cell.switchOutlet.isOn = AppStateStore.shared.autoDayNightOn && LocationServices.sharedInstance.locationAllowed
//
//            cell.autoDayNightCell = true
//            cell.switchChange = {
//
//            }
            default:
                cell.leftLabel.text = "History"
            }
            
            
            return cell

        
    }
    
    func proCellForRowAtIndex(indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsDefaultTableCell") as! SettingsDefaultTableCell
        cell.darkTheme = self.darkTheme
        cell.autoDayNightCell = false
        cell.selectionStyle = .none
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsLabledCell") as! SettingsLabledCell
            cell.initialData()
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            return cell
        }
        
        switch indexPath.row {
        case 1:
            cell.leftLabel.text = "Sound"
            cell.isSwitchHidden = false
            cell.historyCell = false
            cell.setInitialData()
            cell.switchOutlet.isOn = AppStateStore.shared.soundOn
            cell.switchChange = { [weak self] in
                AppStateStore.shared.soundOn = !AppStateStore.shared.soundOn
                self?.tableView.reloadData()
            }
        case 2:
            cell.leftLabel.text = "Vibration"
            cell.isSwitchHidden = false
            cell.historyCell = false
            cell.setInitialData()
            cell.switchOutlet.isOn = AppStateStore.shared.vibrationOn
            cell.switchChange = { [weak self] in
                AppStateStore.shared.vibrationOn = !AppStateStore.shared.vibrationOn
                self?.tableView.reloadData()
            }
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsLabledCell") as! SettingsLabledCell
            cell.initialData()
            cell.tapLeftLabel.text = " "
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            return cell
        case 4:
            cell.leftLabel.text = "Feedback"
            cell.isSwitchHidden = true
            cell.historyCell = false
            cell.setInitialData()
        case 5:
            cell.leftLabel.text = "Membership"
            cell.isSwitchHidden = true
            cell.historyCell = false
            cell.setInitialData()
        case 6:
            cell.leftLabel.text = "Privacy"
            cell.isSwitchHidden = true
            cell.historyCell = false
            cell.setInitialData()
//            cell.arrowImage.image = ThemeSettings.sharedInstance.toLink
//            cell.arrowImage.tintColor = ThemeSettings.sharedInstance.srrowTintColor
            
        default:
            cell.leftLabel.text = "History"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !AppStateStore.shared.isProUser {
            if indexPath.row == 4 {

                self.navigationController?.pushViewController(FeedBackViewController.instance(), animated: true)
//                self.present(FeedBackViewController.instance(), animated: true, completion: nil)
            
            }
            else if indexPath.row == 5 {
                self.navigationController?.pushViewController(MemberViewController.instance(), animated: true)
//                self.present(MemberViewController.instance(), animated: true, completion: nil)
            }
            else if indexPath.row == 8 {
                
                if let link = URL(string: "https://meditation.itsastudio.co/") {
                  UIApplication.shared.open(link)
                }
//                self.navigationController?.pushViewController(PrivacyViewController.instance(), animated: true)
            }
            return 
        }
        
        if indexPath.row == 5 {
           
            let viewController = TimerControlViewController.instance()
            self.navigationController?.pushViewController(viewController, animated: true)
            
//            let viewController = DailyLogsViewController.instance()
//        self.navigationController?.pushViewController(viewController, animated: true)
            
//            self.present(WeeklyHistoryViewController.instance(), animated: true, completion: nil)
        }
        else if indexPath.row == 4 {
            let viewController = DisplayViewController.instance()
            
            viewController.reloadTimerHandler = reloadTimerHandler
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if indexPath.row == 2 {
            
            let VC = ModeSelectionViewController.instance()
                VC.reloadSettingsHandler = { [weak self] in
                self?.reloadTimerHandler?()
                self?.setupView()
            }
            let modalViewController = VC
            modalViewController.modalPresentationStyle = .overCurrentContext
            self.present(modalViewController, animated: true, completion: nil)
            CFRunLoopWakeUp(CFRunLoopGetCurrent())
//            self.navigationController?.pushViewController(IntervelViewController.instance(), animated: true)
            
//            let VC = IntervelViewController.instance()
//            VC.reloadSettingsHandler = { [weak self] in
//                self?.setupView()
//            }
//            let modalViewController = VC
//            modalViewController.modalPresentationStyle = .overCurrentContext
//
//            self.present(modalViewController, animated: true, completion: nil)
//            CFRunLoopWakeUp(CFRunLoopGetCurrent())
        }
        else if indexPath.row == 5 {
//            self.navigationController?.pushViewController(SoundSelectorViewController.instance(), animated: true)
            let VC = SoundSelectorViewController.instance()
            VC.reloadSettingsHandler = { [weak self] in
                self?.setupView()
            }
            let modalViewController = VC
            modalViewController.modalPresentationStyle = .overCurrentContext
            self.present(modalViewController, animated: false, completion: nil)
            CFRunLoopWakeUp(CFRunLoopGetCurrent()) 
        }
//        else if indexPath.row == 6 {
//            SyncTOCloud.shared.downloadingData()
//        }
        else if indexPath.row == 7 {
            self.navigationController?.pushViewController(FeedBackViewController.instance(), animated: true)
//            self.present(FeedBackViewController.instance(), animated: true, completion: nil)
        }
        else if indexPath.row == 10 {
            let VC = ModeSelectionViewController.instance()
                VC.reloadSettingsHandler = { [weak self] in
                self?.reloadTimerHandler?()
                self?.setupView()
            }
            let modalViewController = VC
            modalViewController.modalPresentationStyle = .overCurrentContext
            self.present(modalViewController, animated: true, completion: nil)
            CFRunLoopWakeUp(CFRunLoopGetCurrent()) 
        }
            
        else if indexPath.row == 9 {
            self.navigationController?.pushViewController(MemberViewController.instance(), animated: true)
//            self.present(MemberViewController.instance(), animated: true, completion: nil)
        }
        else if indexPath.row == 8 {
            if let link = URL(string: "https://meditation.itsastudio.co/") {
              UIApplication.shared.open(link)
            }
//            self.navigationController?.pushViewController(PrivacyViewController.instance(), animated: true)
//            self.present(PrivacyViewController.instance(), animated: true, completion: nil)
        }
    }
}
