//
//  TimerControlViewController.swift
//  MCounter
//
//  Created by apple on 3/19/20.
//  Copyright © 2020 WeOverOne. All rights reserved.
//

import UIKit

class TimerControlViewController: UIViewController {
    @IBOutlet weak var settingsButton: UIButton!

    @IBOutlet weak var headingTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewSeprator: UIView!
    @IBOutlet weak var headerSeprator: UIView!
    @IBOutlet weak var headerSepratorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewSepratorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    
    var cellContentArray = ["Warmup","","End of session chime"]
    var addRows:(() -> Void)?
    var deleteRows: (() -> Void)?
    
    static func instance() -> TimerControlViewController {
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        
        let timerControlViewController = storyboard.instantiateViewController(withIdentifier: "TimerControlViewController") as! TimerControlViewController
        return timerControlViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "DoubleTextTableViewCell", bundle: nil), forCellReuseIdentifier: "DoubleTextTableViewCell")
        tableView.register(UINib(nibName: "doubleLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "doubleLabelTableViewCell")
        tableView.register(UINib(nibName: "SettingsLabledCell", bundle: nil), forCellReuseIdentifier: "SettingsLabledCell")

        addRows =  { [weak self] in
            AppStateStore.shared.isWarmupTimerOn = true
            self?.cellContentArray = ["Warmup","Time","Chime","","End of session chime"]
            self?.tableView.beginUpdates()
            self?.tableView.insertRows(at: [IndexPath(row: 1, section: 0),IndexPath(row: 2, section: 0)], with: .bottom)
            self?.tableView.endUpdates()
        }
        deleteRows = {  [weak self] in
            AppStateStore.shared.isWarmupTimerOn = false
            guard self?.cellContentArray.count ?? 0 > 3 else {
                return
            }
            self?.cellContentArray = ["Warmup","","End of session chime"]
            self?.tableView.beginUpdates()
            self?.tableView.deleteRows(at: [IndexPath(row: 1, section: 0),IndexPath(row: 2, section: 0)], with: .top)
            self?.tableView.endUpdates()
            
        }
        
        if AppStateStore.shared.isWarmupTimerOn {
            cellContentArray = ["Warmup","Time","Chime","","End of session chime"]
        }
        else {
            cellContentArray = ["Warmup","","End of session chime"]
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupView()
        self.tableView.reloadData()
        
    }
    
    func setupView() {
        
        settingsButton.setTitleColor(ThemeSettings.sharedInstance.backButtonColor, for: .normal)
        settingsButton.setImage(ThemeSettings.sharedInstance.arrowImageLeft, for: .normal)
        settingsButton.tintColor = ThemeSettings.sharedInstance.backButtonColor
        settingsButton.imageView?.alpha = 0.5
        
        headingTitleLabel.textColor = ThemeSettings.sharedInstance.fontColor
        
        
        self.headerView.backgroundColor = ThemeSettings.sharedInstance.cellBackgroundColor
        
        headerSeprator.backgroundColor = ThemeSettings.sharedInstance.seperatorColor
        tableViewSeprator.backgroundColor = ThemeSettings.sharedInstance.seperatorColor
        self.view.backgroundColor = ThemeSettings.sharedInstance.weeklyCellBackColor
        
        tableView.backgroundView?.backgroundColor = ThemeSettings.sharedInstance.weeklyCellBackColor
        
//        header
        
        if UIScreen.main.bounds.width > 413 || (UIScreen.main.bounds.width == 375.0 && UIScreen.main.bounds.height == 812.0) {
            headerSepratorHeightConstraint.constant = 0.3
            tableViewSepratorHeightConstraint.constant = 0.3
        }
        else {
            headerSepratorHeightConstraint.constant = 0.5
            tableViewSepratorHeightConstraint.constant = 0.5
        }
        
        let footerView = UIView()
        footerView.backgroundColor = ThemeSettings.sharedInstance.weeklyCellBackColor
        footerView.tintColor = ThemeSettings.sharedInstance.weeklyCellBackColor
        tableView.separatorColor = ThemeSettings.sharedInstance.seperatorColor
        tableView.tableFooterView = footerView
        
        tableView.backgroundColor = ThemeSettings.sharedInstance.weeklyCellBackColor
        tableView.backgroundView?.backgroundColor = ThemeSettings.sharedInstance.weeklyCellBackColor
        
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: false, completion: nil)
    }
    

}

extension TimerControlViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellContentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoubleTextTableViewCell") as! DoubleTextTableViewCell
        
        cell.switchOn = addRows
        cell.switchOff = deleteRows
        
        cell.selectionStyle = .none
        cell.hideSwitch = false
        
        if cellContentArray.count < 4 {

            switch indexPath.row {
             case 0:
                    cell.topTitleLabel.text = "Warmup"
                    cell.switchView.setOn(false, animated: false)
                    cell.bottomLabel.text = "Time before your actual session starts"
                    cell.selectionStyle = .none
                    cell.fullSeprator = false
                    cell.initialDataSetUp()
                    cell.sepratorView.alpha = 0
                    cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                return cell
                
             case 1:
                let tempCell = tableView.dequeueReusableCell(withIdentifier: "SettingsLabledCell") as! SettingsLabledCell
                tempCell.initialData()
         
                tempCell.selectionStyle = .none
                tempCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                tempCell.selectionStyle = .none
                return tempCell
                
            case 2:
                cell.topTitleLabel.text = "End of session chime"
                cell.bottomLabel.text = "Select your desired chime"
                cell.rightLabel.text = AppStateStore.shared.selectedSound.rawValue
                cell.hideSwitch = true
                cell.initialDataSetUp()
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                return cell
             default:
                    cell.topTitleLabel.text = "Warmup"
                    cell.bottomLabel.text = "Time before your actual session starts"
                    cell.selectionStyle = .none
                   }
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            return cell
        }
        
        
        switch indexPath.row {
        case 0:
            cell.topTitleLabel.text = "Warmup"
            cell.bottomLabel.text = "Time before your actual session starts"
            cell.switchView.setOn(true, animated: false)
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case 1:
            
            let cellTemp = tableView.dequeueReusableCell(withIdentifier: "doubleLabelTableViewCell") as! doubleLabelTableViewCell
            cellTemp.setupData()
            cellTemp.leftLabel.text = "Time"
            cellTemp.rightLabel.text = "\(AppStateStore.shared.warmupTimerIntervel) secs"
            cellTemp.selectionStyle = .none
            cellTemp.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            return cellTemp
            
        case 2:
            let cellTemp = tableView.dequeueReusableCell(withIdentifier: "doubleLabelTableViewCell") as! doubleLabelTableViewCell
            
            cellTemp.setupData()
            cellTemp.leftLabel.text = "Chime"
            cellTemp.rightLabel.text = AppStateStore.shared.selectedWarmupSound.rawValue
            cellTemp.selectionStyle = .none
//            cellTemp.sepr.alpha = 0
            cellTemp.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            return cellTemp
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsLabledCell") as! SettingsLabledCell
                   cell.initialData()
            
                   cell.selectionStyle = .none
                   cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                cell.selectionStyle = .none
                   return cell
        case 4:
            cell.topTitleLabel.text = "End of session chime"
            cell.bottomLabel.text = "Select your desired chime"
            cell.rightLabel.text = AppStateStore.shared.selectedSound.rawValue
            cell.hideSwitch = true
            cell.initialDataSetUp()
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            cell.selectionStyle = .none
            
            return cell
        default:
            cell.topTitleLabel.text = "Warmup"
            cell.bottomLabel.text = "Time before your actual session starts"
            cell.selectionStyle = .none
        }
        
        cell.initialDataSetUp()
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if AppStateStore.shared.isWarmupTimerOn {
            
            switch indexPath.row {
            case 1:
                let VC = IntervelViewController.instance()
                VC.reloadSettingsHandler = { [weak self] in
                    self?.setupView()
                    self?.tableView.reloadData()
                }
                let modalViewController = VC
                modalViewController.modalPresentationStyle = .overCurrentContext

                self.present(modalViewController, animated: true, completion: nil)
                CFRunLoopWakeUp(CFRunLoopGetCurrent())
            case 2:
                let VC = SoundSelectorViewController.instance()
                VC.isWarmup = true
                VC.reloadSettingsHandler = { [weak self] in
                    self?.setupView()
                    self?.tableView.reloadData()
                }
                let modalViewController = VC
                modalViewController.modalPresentationStyle = .overCurrentContext
                self.present(modalViewController, animated: false, completion: nil)
                CFRunLoopWakeUp(CFRunLoopGetCurrent())
            case 4:
                let VC = SoundSelectorViewController.instance()
                VC.isWarmup = false
                VC.reloadSettingsHandler = { [weak self] in
                    self?.setupView()
                    self?.tableView.reloadData()
                }
                let modalViewController = VC
                modalViewController.modalPresentationStyle = .overCurrentContext
                self.present(modalViewController, animated: false, completion: nil)
                CFRunLoopWakeUp(CFRunLoopGetCurrent())
            default:
                print("index to default")
            }
            return
        }
        
        if indexPath.row == 2 {
            let VC = SoundSelectorViewController.instance()
            VC.reloadSettingsHandler = { [weak self] in
                self?.setupView()
                self?.tableView.reloadData()
            }
            VC.isWarmup = true
            let modalViewController = VC
            modalViewController.modalPresentationStyle = .overCurrentContext
            self.present(modalViewController, animated: false, completion: nil)
            CFRunLoopWakeUp(CFRunLoopGetCurrent()) 
        }
    }
    
    
}
