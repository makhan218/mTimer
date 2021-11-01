//
//  ViewController.swift
//  MCounter
//
//  Created by Muhammad Ahmad on 22/03/2019.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import UserNotifications
import MediaPlayer
import Mute
import Bugsnag
import SwiftDate

class ViewController: UIViewController {
    
    @IBOutlet weak var topViewBlur: UIView!
    @IBOutlet weak var centerDot: UIView!
    @IBOutlet weak var counterCollectionView: UICollectionView!
    @IBOutlet weak var centerDotVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var textFont: UILabel!
    @IBOutlet weak var bottomBackground: UIView!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var secondsCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var forSettingButton: UIButton!

    @IBOutlet weak var settingsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var historyHeightConstraint: NSLayoutConstraint!
    //    @IBOutlet weak var centerSeprator: UIView!
    
    var player: AVAudioPlayer?
    var arrIndex:[IndexPath] = []
    var timeIntervel = 60 // intervel in seconds
    var gradientLayer: CAGradientLayer! // layer for blurr effect at the end
//    var isDarkTheme = false
    var timer:Timer? // timer for blinker
    var moveTimer: Timer? // timer for the movement of collectionview
    var warmupTimer:Timer? // timer for the warmup dot
    
    var timerRunning = false // Check for the timer if its running or not
    var fadingDuration = 1.0// blinker fading duration
    var InvisibleCells = 11 // cells above the zeero cell so it's just above the center
    var timerDuration = 0 // duration in minutes for timer
    var oldTimerDuration = 0
    let maxNumber = 90 // max time duration
    var cellHeight:CGFloat = 0.0
    var topCellContentOffsets = -39
    
    var sessionEnded = false
    var secondsCounter = 0
    let notificationIdentifyer = "Meditaion-End-Notification"
    let warmupNotification = "Warmup-End-Notification"
    var xPhonesDotCorrection = 0
    var timeAppInBachground: Date?
    var backFromTheDead = false
    var dontShowSecoundsLabel = false
    
    var alreadySaved = false
    let historyDataModel = HistoryDataModel()
    var totalMeditaionDuration = 0
    var meditationDateStart:Date = Date()
    var stayingInApp = false
    var playingSound = false
    var warmupSeccondsRemaning:Int = 0
    var firstCellViewCheck:Int = 0
    var needTscroll:Bool = false
    var menuExpanded = false

    private let itemsPerRow: CGFloat = 1
    private let sectionInsets = UIEdgeInsets(top: 0.0,
                                             left: 0.0,
                                             bottom: 0.0,
                                             right: 0.0)
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        if UIScreen.main.bounds.height < 750 {
            topCellContentOffsets = -10
        }
    
        if UIScreen.main.bounds.height > 811 {
            InvisibleCells += 1
        }
        animatedlyChangeTimer(number: 0)
        topViewBlur.isUserInteractionEnabled = false
        counterCollectionView.register(UINib.init(nibName: "CollectionViewCounterCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCounterCell")
        // tap selector keeping the code
//        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
//        tap.numberOfTapsRequired = 2
//        self.counterCollectionView.addGestureRecognizer(tap)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(showNumber))
        singleTap.numberOfTapsRequired = 1
        self.counterCollectionView.addGestureRecognizer(singleTap)
        checkUserSelectedMode()
//        AppStateStore.shared.selectedMode = .alwaysWhite
//        ThemeSettings.sharedInstance.setLightTheme()
    }
    
    func checkUserSelectedMode() {
        
        if AppStateStore.shared.selectedMode == .alwaysDark {
//            self.isDarkTheme = true
            ThemeSettings.sharedInstance.setDarkTheme()
        }
        else if AppStateStore.shared.selectedMode == .alwaysWhite {
//            self.isDarkTheme = false
            ThemeSettings.sharedInstance.setLightTheme()
        }
        else if AppStateStore.shared.selectedMode == .phoneUse {
            if #available(iOS 13.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    // User Interface is Dark
//                    self.isDarkTheme = true
                    ThemeSettings.sharedInstance.setDarkTheme()
                } else {
//                    self.isDarkTheme = false
                    ThemeSettings.sharedInstance.setLightTheme()
                    print("Light shines")
                }
            } else {
                // Fallback on earlier versions
            }
        }
        counterCollectionView.reloadData()
        setupAppearence()
    }
    
    func doughnet() {
        
        // to draw the warmup timer circle
        let CircleLayer   = CAShapeLayer()
        
        let center = CGPoint (x: self.centerDot.frame.size.width / 2, y: centerDot.frame.size.height / 2)
        let circleRadius = centerDot.frame.size.width / 2
        let circlePath = UIBezierPath(arcCenter: center, radius: circleRadius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi * 4), clockwise: true)
        CircleLayer.path = circlePath.cgPath
        CircleLayer.strokeColor = ThemeSettings.sharedInstance.mainDot.cgColor
        CircleLayer.fillColor = UIColor.clear.cgColor
        CircleLayer.lineWidth = 6
        CircleLayer.strokeStart = 0
        CircleLayer.strokeEnd  = 1
        centerDot.layer.addSublayer(CircleLayer)
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // internet connectivity chech
        if Reachability.isConnectedToNetwork(){
            SyncTOCloud.shared.checkAndDownloadFromCloud()
            SyncTOCloud.shared.uploadData()
            print("Internet Connection Available!")
        }else{
            print("Internet Connection not Available!")
        }
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stayingInApp = false // for not stoping the app timer or to schedule notification while the user is in other screens
        setupAutoDayNight()
        
        // removing all the notifications scheduled when app is oppned
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        if AppStateStore.shared.resetTimer {
            notificationsessionEnd()
        }
        else {
            resettingViewAfterBackground()
        }
        
        // coming back from withing the app and reserring the scroller to appropiate position
        if timerRunning, !backFromTheDead {
            var correction = 0
            correction = warmupSeccondsRemaning > 0 ?  -1 :  0
            dropCollectionView(correction: correction)
        }
        
        // setiing up appearence
        setupAppearence()
        if !AppStateStore.shared.autoDayNightOn {
//            isDarkTheme = true
            doubleTapped()
        }
        checkUserSelectedMode()
        updateStreak()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
       // stopping the scroller on the place when going back to set the
        self.counterCollectionView.setContentOffset(counterCollectionView.contentOffset, animated: false)
        
        // Stopping notification schedule if the user is just going in settings
        guard !stayingInApp else {
            return
        }
        
        // Seconds correction if the warmup timer is running and the app is backgrounded
        if warmupSeccondsRemaning > 0 {
            secondsCounter = 0
        }
        
        // Hiding the center dot while going in the background
        self.centerDot.alpha = 0
        
        // to not schedule notifications if the timer is stopped (To catter to the background ringing issue)
        if (timerDuration > 0 || secondsCounter > 0), timerRunning {
            
            self.backFromTheDead = true
            firstCellViewCheck = 3
            // storing logs if aren't already saved
            if !alreadySaved {
                // this can cause a problem if the session is complex i.e the user has changed the timer after during the session, and after changing the user backgrounds the app and the timer finishes in the background. To solve this, calculate the time passed from the session started and add the remaining time left in the session and then store them
                historyDataModel.storeMeditation(minutesMaditated: totalMeditaionDuration, date: meditationDateStart)
                alreadySaved = true
            }
            
            // storing the time when app was backgrounded
            self.timeAppInBachground = Date()
            
            //subtructing 1 from the minues because the secounds left in that minute will be added in the schedule time
            
            var time = timerDuration - 1
            if warmupSeccondsRemaning > 1 {
                time = time + 1
            }

            if time < 0 {
                time = 0
            }
            let duration = (time * 60) + abs(60 - self.secondsCounter)
            print("secounds \(secondsCounter)")
            print("notification \(duration)")
            // function to schedule notification
            self.scheduleNotifiation(number: duration)
            
            // warmup notification
            if warmupSeccondsRemaning > 1 {
                self.scheduleNotifiationForWarmup(number: warmupSeccondsRemaning)
            }
            
            // stopping the timer
            timerRunning = false
            invalidateTimer()
            needTscroll = true
        }
        
    }
    @IBAction func historyButtonAction(_ sender: Any) {
        
       
        
        stayingInApp = true
        let viewController = DailyLogsViewController.instance()
        viewController.reloadTimerHandler = { [weak self] in
            self?.setupAppearence()
            self?.counterCollectionView.reloadData()
        }
        let nav = UINavigationController(rootViewController: viewController)
        nav.isNavigationBarHidden = true
        self.present(nav, animated: true, completion: nil)
        
    }
    @IBAction func showSettingsButtonAction(_ sender: Any) {
        stayingInApp = true
        let settingsVC = SettingsViewController.instance()
        settingsVC.reloadTimerHandler = { [weak self] in
            self?.setupAppearence()
            self?.counterCollectionView.reloadData()
        }
        let nav = UINavigationController(rootViewController: settingsVC)
        nav.isNavigationBarHidden = true
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func settingsButtonAction(_ sender: Any) {

        if menuExpanded {
            menuExpanded = false
            self.historyHeightConstraint.constant = 0
            self.settingsHeightConstraint.constant = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                self.settingsButton.transform = CGAffineTransform(rotationAngle: 0)
                self.forSettingButton.alpha = 0
                self.historyButton.alpha = 0
            }) { (flag) in
                self.forSettingButton.alpha = 0
                self.historyButton.alpha = 0
            }
            
        }
        else {
            menuExpanded = true
            self.forSettingButton.alpha = 1
            self.historyButton.alpha = 1
            self.historyHeightConstraint.constant = 58
            self.settingsHeightConstraint.constant = 116
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                let angle = CGFloat(0.999 * Double.pi)
                  
                self.settingsButton.transform = CGAffineTransform(rotationAngle: angle)
            }) { (flag) in
                self.forSettingButton.alpha = 1
                self.historyButton.alpha = 1
            }
            
        }
        
        
        // presinting settings
        
    }
    
}

//MARK:- DayNight functions and label functions
extension ViewController {
    
    func setupAutoDayNight() {
        Mute.shared.checkInterval = 2.0
        Mute.shared.alwaysNotify = true
        Mute.shared.notify = { m in
            if m == true {
                
            }
        }
            
    }
    
    func setAutoTheme() {
        if checkifDay() {
//            isDarkTheme = true
            doubleTapped()
        }
        else if checkifNight() {
//            isDarkTheme = false
            doubleTapped()
        }
    }
    
    func checkifDay() -> Bool {
        if let location = LocationServices.sharedInstance.location {
            let solar = Solar(coordinate: location)
            if solar?.isDaytime ?? false, LocationServices.sharedInstance.locationAllowed {
                return true
            }
        }
        return false
    }
    
    func checkifNight() -> Bool {
        if let location = LocationServices.sharedInstance.location {
            let solar = Solar(coordinate: location)
            if solar?.isNighttime ?? false, LocationServices.sharedInstance.locationAllowed {
                return true
            }
        }
        return false
    }
    
    @objc func showNumber() {
        
        // to reset the screen on user tap after the timer has ended
        if sessionEnded  {
            resetScreen()
        }
        
        // show number and hide it after 3 sec
        UIView.animate(withDuration: 2) {
            self.labelNumber.alpha = 1
        }
        fadeNumber()
    }
    
    func showNumberForEndSession() {
        UIView.animate(withDuration: 2) {
            self.labelNumber.alpha = 1
        }
    }
    
    func fadeNumber() {
        UIView.animate(withDuration: 2) {
            self.labelNumber.alpha = 0
        }
    }
    
    func showTextLabel() {
        UIView.animate(withDuration: 1) {
            self.textFont.alpha = 1
        }
    }
    
    func hideTextLabel() {
        if timerDuration > 0 {
            UIView.animate(withDuration: 0.1) {
                self.textFont.alpha = 0
            }
        }
    }
    
    @objc func doubleTapped() {
        // to change between darn and night mode
        if ThemeSettings.sharedInstance.darkTheme {
            ThemeSettings.sharedInstance.setLightTheme()
//            isDarkTheme = false
        }
        else {
            ThemeSettings.sharedInstance.setDarkTheme()
            
//            isDarkTheme = true
        }
        counterCollectionView.reloadData()
        setupAppearence()
        
    }
    
    func updateStreak() {
        // streak if the streak is missed 
        if !(Calendar.current.isDate(AppStateStore.shared.streakLastDate ?? Date(), inSameDayAs:Date()) || Calendar.current.isDateInYesterday(AppStateStore.shared.streakLastDate ?? Date())) {
            AppStateStore.shared.streakLastDate = nil
            AppStateStore.shared.streakDays = 0
        }
        
    }
    
    func setupAppearence() {
        
//        centerSeprator.backgroundColor = ThemeSettings.sharedInstance.centerSeprator
        labelNumber.font = ThemeSettings.sharedInstance.font30
        addGradientMask()
        
        // corrections for bigger phones
        if UIScreen.main.bounds.height > 811 {
            xPhonesDotCorrection = 1
        }
        else {
            xPhonesDotCorrection = 0
        }
    
        textFont.textColor = ThemeSettings.sharedInstance.mainDot
        self.labelNumber.alpha = 0
        labelNumber.textColor = ThemeSettings.sharedInstance.mainText
        
        self.counterCollectionView.showsVerticalScrollIndicator = false
        self.centerDot.layer.cornerRadius = self.centerDot.frame.width / 2
        self.centerDot.layer.masksToBounds = true
        if ThemeSettings.sharedInstance.darkTheme {
            gradientLayer.colors = [ThemeSettings.sharedInstance.mainBottom.withAlphaComponent(0).cgColor, ThemeSettings.sharedInstance.mainBottom.withAlphaComponent(1).cgColor]
          //            settingsButton.setImage(ThemeSettings.sharedInstance.settingsButton, for: .normal)
        }
        else {
            gradientLayer.colors = [ThemeSettings.sharedInstance.mainBottom.withAlphaComponent(0).cgColor, ThemeSettings.sharedInstance.mainBottom.withAlphaComponent(1).cgColor]//            UIColor(red: 118/255, green: 118/255, blue: 128/255, alpha: 0.1).cgColor
//            settingsButton.setImage(ThemeSettings.sharedInstance.settingsButton, for: .normal)
        }
//        settingsButton.setBackgroundImage(ThemeSettings.sharedInstance.settingsButton, for: .normal)
        self.labelNumber.textColor = ThemeSettings.sharedInstance.mainText
        self.bottomBackground.backgroundColor = ThemeSettings.sharedInstance.mainBottom
//        bottomBackgroungColor
        self.view.backgroundColor = ThemeSettings.sharedInstance.mainTop
        self.counterCollectionView.backgroundColor = UIColor.clear
        self.topViewBlur.backgroundColor = ThemeSettings.sharedInstance.mainBottom
//        bottomBackgroungColor
        self.topViewBlur.alpha = 0
        if warmupSeccondsRemaning < 1 {
            self.centerDot.backgroundColor = ThemeSettings.sharedInstance.mainDot
//            fontColor
        }
        
        if timerRunning {
            self.topViewBlur.alpha = 1
            if self.timerDuration > 0 {
                self.topViewBlur.alpha = 1
            }
            else {
                self.centerDot.alpha = 0
            }
            
        }
        else {
            if !backFromTheDead {
                self.centerDot.alpha = 0
            }
            else if self.timerDuration > 0 {
                self.topViewBlur.alpha = 1
            }
            if sessionEnded {
                self.topViewBlur.alpha = 0
                textFont.text = "swipe up to start"
            }
            
        }
        
//        settingsButton.setBackgroundImage(ThemeSettings.sharedInstance.settingsButton, for: .normal)
        
        historyButton.tintColor = ThemeSettings.sharedInstance.backButtonColor
        forSettingButton.tintColor = ThemeSettings.sharedInstance.backButtonColor
        settingsButton.tintColor = ThemeSettings.sharedInstance.backButtonColor
        
        if !menuExpanded {
            self.forSettingButton.alpha = 0
            self.historyButton.alpha = 0
        }
        else {
            self.forSettingButton.alpha = 1
            self.historyButton.alpha = 1
        }
        
        let angle = CGFloat(-2 * Double.pi)
          
        settingsButton.transform = CGAffineTransform(rotationAngle: angle)
        
        view.bringSubviewToFront(settingsButton)
        
        
    }
    
    private func addGradientMask() {
         if gradientLayer == nil {
            gradientLayer = CAGradientLayer()
            let frame = CGRect(x: self.view.bounds.origin.x, y: self.view.bounds.origin.y + (self.view.bounds.height / 2), width: self.view.bounds.width, height: self.view.bounds.height / 2)
            gradientLayer.frame = frame
            
//            if ThemeSettings.sharedInstance.darkTheme {
//                gradientLayer.colors = [UIColor.init(white: 1, alpha: 0).cgColor, UIColor.init(white: 0, alpha: 1)]
//            }
//            else {
//                gradientLayer.colors = [UIColor.init(white: 1, alpha: 0).cgColor, UIColor.init(white: 1, alpha: 1)]
//            }
            
            self.view.layer.insertSublayer(gradientLayer, at: 3)
                
        }
         else {
            if ThemeSettings.sharedInstance.darkTheme {
//                .cgColor init(white: 0, alpha: 0).cgColor
                gradientLayer.colors = [ThemeSettings.sharedInstance.mainBottom.withAlphaComponent(0).cgColor, ThemeSettings.sharedInstance.mainBottom.withAlphaComponent(1).cgColor]
//                [ThemeSettings.sharedInstance.mainBottom.withAlphaComponent(0).cgColor, ThemeSettings.sharedInstance.mainBottom.withAlphaComponent(1).cgColor]
            }
            else {
                gradientLayer.colors = [ThemeSettings.sharedInstance.mainBottom.withAlphaComponent(0).cgColor, ThemeSettings.sharedInstance.mainBottom.withAlphaComponent(1).cgColor]
//                [UIColor.init(white: 1, alpha: 0).cgColor, UIColor.init(white: 1, alpha: 1)]
            }
        }
    }
    
    func centerDotHide() {
        // detect center cell and set the circle to clear
        
        let center = self.view.convert(self.counterCollectionView.center, to: self.counterCollectionView)
        let oldIndex = counterCollectionView.indexPathForItem(at: center)
        let index = IndexPath(row: ((oldIndex?.row ?? 0) ) , section: oldIndex?.section ?? 0)
        let cell = counterCollectionView.cellForItem(at: index ) as? CollectionViewCounterCell
        if cell?.centerCircle.timerFillColor != UIColor.clear {
            arrIndex.append(index )
            cell?.centerCircle.timerFillColor = UIColor.clear
        }
    }
    
    func hideSettingButton() {
        UIView.animate(withDuration: 0.3) {
            self.settingsButton.alpha = 0
        }
        if menuExpanded {
            menuExpanded = false
            self.historyHeightConstraint.constant = 0
            self.settingsHeightConstraint.constant = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                self.settingsButton.transform = CGAffineTransform(rotationAngle: 0)
                self.forSettingButton.alpha = 0
                self.historyButton.alpha = 0
            }) { (flag) in
                self.forSettingButton.alpha = 0
                self.historyButton.alpha = 0
            }
            
        }
    }
    
    func showSettingButton() {
        UIView.animate(withDuration: 0.3) {
            self.settingsButton.alpha = 1
        }
        
    }
    
    func dotHide() {
        
        let center = self.view.convert(self.counterCollectionView.center, to: self.counterCollectionView)
        let index = counterCollectionView.indexPathForItem(at: center)
        let cell = counterCollectionView.cellForItem(at: IndexPath(row: (index?.row ?? 0) + 1 + xPhonesDotCorrection, section: index?.section ?? 0)) as? CollectionViewCounterCell
        if cell?.centerCircle.timerFillColor != UIColor.clear {
            arrIndex.append(index ?? IndexPath())
            cell?.centerCircle.timerFillColor = UIColor.clear
        }
    }
    
    func hideCellAtIndex(indexPath:IndexPath) {
        print (indexPath.row)
        let cell = counterCollectionView.cellForItem(at: indexPath ) as? CollectionViewCounterCell
        if cell?.centerCircle.timerFillColor != UIColor.clear {
            arrIndex.append(indexPath)
            cell?.centerCircle.timerFillColor = UIColor.clear
        }
        
    }
    
    func dropCollectionView(correction: Int = 0) {
        // check timer and scroll to the position the timer should be
        if timerDuration >= 0 {
            
            self.dontShowSecoundsLabel = true
            if UIScreen.main.bounds.height > 811, timerDuration == -2 {
                let itemNumber = (timerDuration - 3 - correction)
                let topIndex = IndexPath(item: itemNumber, section: 0)
                UIView.animate(withDuration: 0.3) {
                    self.counterCollectionView.scrollToItem(at: topIndex, at: UICollectionView.ScrollPosition.top, animated: false)
                }
            }
            else {
                let itemNumber = (timerDuration - 1 - correction)
                let topIndex = IndexPath(item: itemNumber < 0 ? 0 : itemNumber, section: 0)

                UIView.animate(withDuration: 0.3) {
                    self.counterCollectionView.scrollToItem(at: topIndex, at: UICollectionView.ScrollPosition.top, animated: false)
                }
            }
            
            
        }
    }
    
   
    
    func resetScreen() {
        setFirstDotColor()
        resetAllCellCircles()
        textFont.text = "swipe up to start"

        stopAnimation()
        timerRunning = false
        invalidateTimer()
        showTextLabel()
    }
    
}

// MARK:- Collectionview Data Source
extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 90 are the visibles cells, invisible cells ar ethe cells on the top of the 00 and 2 added are the cells as 90 should be on the place of 00
        if UIScreen.main.bounds.height > 811 {
            return 90 + (InvisibleCells * 2) + 2
        }
        return 90 + (InvisibleCells * 2) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCounterCell", for: indexPath) as! CollectionViewCounterCell
       
        cell.contentView.backgroundColor = UIColor.clear
        
        // color cell backgroung teting code
//        if indexPath.row % 2 == 0 {
//                   cell.contentView.backgroundColor = UIColor.blue
//               }
//               else {
//                   cell.contentView.backgroundColor = UIColor.systemPink
//               }

        
        if indexPath.row <= InvisibleCells {
            cell.centerCircle.timerFillColor = UIColor.clear
            cell.tag = -1 //specifically gave them a -1 tag because they were recycling and picking other cells tag
            return cell
        }
        cell.tag = indexPath.row - InvisibleCells - 1
        if indexPath.row - InvisibleCells > 90 {
            cell.centerCircle.timerFillColor = UIColor.clear
            cell.tag = 90
            return cell
        }
        cell.centerCircle.timerFillColor = ThemeSettings.sharedInstance.mainDot
        cell.centerCircle.drawFilled()
        cell.setupCell()
        if self.arrIndex.contains(indexPath) {
            cell.centerCircle.timerFillColor = UIColor.clear
        }
       
        return cell
    }
    
}

// MARK:- Flow Layout
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenRect = UIScreen.main.bounds
        let screenwidth = screenRect.size.width
        // to set the number of cells in a row
        let cellWidth = (screenwidth - (16*itemsPerRow)) / itemsPerRow

        if UIScreen.main.bounds.height == 736 {
            // for iphone 7 plus 8 plus
            cellHeight = (screenRect.size.height) / 23
            return CGSize(width: cellWidth, height: (screenRect.size.height) / 23)
        }
        else if UIScreen.main.bounds.height == 667 {
            // for iphone 6, 6s, 7, 6 Plus, 6s Plus, 8
            cellHeight = (screenRect.size.height) / 23
             return CGSize(width: cellWidth, height: (screenRect.size.height) / 23)
            
        }
        else if UIScreen.main.bounds.height == 812 {
            // for iPhone X
            cellHeight = (screenRect.size.height + 10) / 28
            return CGSize(width: cellWidth, height: (screenRect.size.height + 10) / 28)
        }
        else if UIScreen.main.bounds.height == 568  {
            // Iphone SE

            InvisibleCells = 10
            cellHeight = (screenRect.size.height) / 21
            return CGSize(width: cellWidth, height: (screenRect.size.height) / 21)

        }
        else if UIScreen.main.bounds.height == 896 {
        // XS Max
            cellHeight = (screenRect.size.height + 20) / 28
            return CGSize(width: cellWidth, height: (screenRect.size.height + 20) / 28)
        }
        
        
        if indexPath.row == 1, UIScreen.main.bounds.height < 812 {
            return CGSize(width: cellWidth, height: 60)
        }
        cellHeight = (screenRect.size.height - 1) / 28
        return CGSize(width: cellWidth, height: (screenRect.size.height - 1) / 28)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        topViewBlur.alpha = 0
        dontShowSecoundsLabel = false
        setFirstDotColor()
        resetAllCellCircles()
      self.textFont.alpha = 0
//        self.labelNumber.alpha = 1
        centerDot.alpha = 0
        firstCellViewCheck = 0
        setFirstDotColor()
        resetAllCellCircles()
        
    }
    
}

// MARK:- Collection view delegate
extension ViewController: UICollectionViewDelegate {
    
    // turns off the timer if the scrolled to the top
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let center = self.view.convert(self.counterCollectionView.center, to: self.counterCollectionView)
    
        let cellAboveTheCenter = CGPoint(x: center.x, y: center.y + 20)
        let aboveIndex = counterCollectionView.indexPathForItem(at: cellAboveTheCenter)
        continuseScrollCenterCellLabelChange(indexPath: aboveIndex ?? IndexPath())
        hideTextLabel()
        if !timerRunning,firstCellViewCheck < 1 {
            setFirstDotColor()
            resetAllCellCircles()
        }
        
        // removing the end of session label when dots go above the line 
        if scrollView.contentOffset.y > 1 {
            textFont.alpha = 0
        }
        else if !timerRunning, Int(scrollView.contentOffset.y) < topCellContentOffsets {
            showTextLabel()
        }


        if Int(scrollView.contentOffset.y) < topCellContentOffsets  {
            
            print(scrollView.contentOffset.y)
            stopAnimation()
            timerRunning = false
            storeDateBySubtructingTime()
            textFont.text = "end of session"
            self.labelNumber.alpha = 1
            animatedlyChangeTimer(number: 0)
            self.showSettingButton()
            dontShowSecoundsLabel = false
            continuseScrollCenterCellLabelChange(indexPath: aboveIndex ?? IndexPath())
            showTextLabel()
            if timerDuration > 0 {
                playSound()
            }
            
            self.warmupSeccondsRemaning = 0
            self.fadeNumber()
            invalidateTimer()
            resetAllCellCircles()
            self.timerDuration = 0
            oldTimerDuration = 0
            self.secondsCounter = 0
        }
    }
    
    func storeDateBySubtructingTime() {
        let secondsPassed = Date().timeIntervalSince(meditationDateStart)
        let minutesPassed = Int(secondsPassed / 60)
        if minutesPassed == totalMeditaionDuration || totalMeditaionDuration == 0 {
            
        }
        else if minutesPassed == 0{
            if alreadySaved, totalMeditaionDuration != 0 {
                historyDataModel.deleteLastSaved()
            }
            totalMeditaionDuration = 0
            return
        }
        else if !alreadySaved {
//            if minutesPassed > totalMeditaionDuration {
//                minutesPassed = totalMeditaionDuration
//            }
            historyDataModel.storeMeditation(minutesMaditated: minutesPassed, date: meditationDateStart)
            self.alreadySaved = true
            totalMeditaionDuration = 0
            streak()
        }
        else {
            streak()
            // Saving log scinario code
//            if minutesPassed > totalMeditaionDuration {
//                minutesPassed = totalMeditaionDuration
//            }
//            historyDataModel.updateLastLog(minute: minutesPassed)
//            self.alreadySaved = true
//            totalMeditaionDuration = 0
        }
        
    }
    
    func setFirstDotColor() {
        
        let cell = counterCollectionView.cellForItem(at: IndexPath(row: InvisibleCells + 1, section: 0)) as? CollectionViewCounterCell
        if cell?.tag ?? 0 > -1{
            cell?.centerCircle.timerFillColor = ThemeSettings.sharedInstance.mainDot
        }
    }
    
    func resetAllCellCircles() {
        
        for item in arrIndex {
            let cell = counterCollectionView.cellForItem(at: item) as? CollectionViewCounterCell
            if cell?.tag ?? 0 > -1, item.row > InvisibleCells + 1 {
                cell?.centerCircle.timerFillColor = ThemeSettings.sharedInstance.mainDot
            }
            else {
                cell?.centerCircle.timerFillColor = ThemeSettings.sharedInstance.mainDot

            }
        }
        self.counterCollectionView.reloadData()
        arrIndex.removeAll()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        firstCellViewCheck = 0
        print("scroll scrollViewDidEndDecelerating")
        let center = self.view.convert(self.counterCollectionView.center, to: self.counterCollectionView)
        let trueCenter = CGPoint(x: center.x, y: center.y + 15)
        let index = counterCollectionView.indexPathForItem(at: trueCenter)
        dontShowSecoundsLabel = false
        continuseScrollCenterCellLabelChange(indexPath: index ?? IndexPath())
        if let index = index {
            setupWarmupTimer(index: index)

        }
    }
        
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView.isDecelerating {
            return
        }
        firstCellViewCheck = 0
            let center = self.view.convert(self.counterCollectionView.center, to: self.counterCollectionView)
        let trueCenter = CGPoint(x: center.x, y: center.y + 15)
            let index = counterCollectionView.indexPathForItem(at: trueCenter)
        dontShowSecoundsLabel = false
        if let index = index {
            setupWarmupTimer(index: index)

        }
        else {
            
            let cellAboveTheCenter = CGPoint(x: center.x, y: center.y - 0)
            let aboveIndex = counterCollectionView.indexPathForItem(at: cellAboveTheCenter)
            setupWarmupTimer(index: aboveIndex ?? IndexPath())
        }
        
    }
    
    func checkAndHideBackgroundCircle() {
        let falseCenter = self.view.convert(self.counterCollectionView.center, to: self.counterCollectionView)
        let center = CGPoint(x: falseCenter.x, y: falseCenter.y + 15)
        let index = counterCollectionView.indexPathForItem(at: center)
        let cell = counterCollectionView.cellForItem(at: index ?? IndexPath()) as? CollectionViewCounterCell
        if cell?.centerCircle.timerFillColor != UIColor.clear {
            arrIndex.append(index ?? IndexPath())
            cell?.centerCircle.timerFillColor = UIColor.clear
            self.counterCollectionView.reloadItems(at: [index ?? IndexPath()])
        
        }
    }
    
    func stopAnimation() {

        invalidateTimer()
        topViewBlur.alpha = 0
        setFirstDotColor()
        resetAllCellCircles()
         centerDot.alpha = 0
        self.timerRunning = false
        centerDotVerticalConstraint.constant = 0
        
    }
    
    func continuseScrollCenterCellLabelChange(indexPath:IndexPath) {
        
        let cell = counterCollectionView.cellForItem(at: indexPath) as? CollectionViewCounterCell
        let number = cell?.tag ?? 0
        if number > 0, !dontShowSecoundsLabel {
            self.labelNumber.alpha = 1
            animatedlyChangeTimer(number: number)
        }
        
    }
    
    
    
    func animatedlyChangeTimer(number:Int) {
        
        let newNumber:Int = number < 0 ?  0 :  number
        labelNumber.textColor = ThemeSettings.sharedInstance.mainText
        UIView.animate(withDuration: 0.3) {
//            let mutableString = NSMutableAttributedString(string: String(newNumber) + "m  ")
//            let size = mutableString.length - 3
//            
//            mutableString.setAttributes([NSAttributedString.Key.font: UIFont(name: "apercu-mono-light", size: 40) ?? UIFont.systemFont(ofSize: 40)], range: NSMakeRange(size, 3))
//            self.labelNumber.attributedText = mutableString
            self.labelNumber.text = String(newNumber) + "m"
        }
    }
    
    // moves the collectionview in points given as offset
    func moveToFrame(contentOffset : CGFloat) {

        self.counterCollectionView.setContentOffset(CGPoint(x: self.counterCollectionView.contentOffset.x, y: self.counterCollectionView.contentOffset.y + contentOffset), animated: true)

    }
    
    func playWarmupSound() {
        
        if AppStateStore.shared.resetTimer {
            return
        }
        
        if AppStateStore.shared.vibrationOn {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
        if !AppStateStore.shared.soundOn {
            return
        }
        
        guard let url = Bundle.main.url(forResource: AppStateStore.shared.warmupSoundName(), withExtension: "mp3") else { return }
        
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
            self.playingSound = true
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    func playSound() {
//        resetAllCellCircles()
        if AppStateStore.shared.resetTimer {
            return
        }
        
        if AppStateStore.shared.vibrationOn {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
        if !AppStateStore.shared.soundOn {
            return 
        }
        
        guard let url = Bundle.main.url(forResource: AppStateStore.shared.soundName(), withExtension: "mp3") else { return }
        
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
            self.playingSound = true
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    func resettingViewAfterBackground() {
        let warmupSecoundRemaningWhenLeft = warmupSeccondsRemaning
        dontShowSecoundsLabel = true
        
        if self.timeAppInBachground == nil {
            print("time app in background is nill")
            //check if in some bezar way the time wasn't saved
        }
    
        
        let timeAppInBachground = self.timeAppInBachground ?? Date()
        
        do {
            var secondsPassed = Date().timeIntervalSince(timeAppInBachground)
        
            if warmupSeccondsRemaning < 1 {
                warmupSeccondsRemaning = 0
            }
            if Int(secondsPassed) < (AppStateStore.shared.warmupTimerIntervel + 1) ,self.warmupSeccondsRemaning > 1 {
                let row = (self.timerDuration + InvisibleCells + 1)
                self.centerDot.alpha = 0
                let number = ((AppStateStore.shared.warmupTimerIntervel + 1) - warmupSeccondsRemaning) + Int(secondsPassed)
                secondsCounter = (60 - (AppStateStore.shared.warmupTimerIntervel + 1)) + number
                    
                warmUpDotSet()
                if alreadySaved {
                    historyDataModel.deleteLastSaved()
                    alreadySaved = false
                }
                setupWarmupTimer(index: IndexPath(row: row, section: 0), number: number)
                return
            }
            else {
                secondsPassed = (secondsPassed - Double(warmupSeccondsRemaning) > 0) ? secondsPassed - Double(warmupSeccondsRemaning) : 0
                warmupSeccondsRemaning = 0
            }
            self.timeAppInBachground = nil
            let minutesPassed = Int(secondsPassed / 60)
            let secoundsPassedAfterMinutes = Int(secondsPassed) - (60 * minutesPassed)
            print(minutesPassed)
            if timerDuration - minutesPassed <= 0 {
                dotHide()
                notificationsessionEnd()
            }
            else {
                self.timerDuration = timerDuration - minutesPassed > -1 ? (timerDuration - minutesPassed) : 0

                if minutesPassed > 0 || warmupSecoundRemaningWhenLeft > 0 {
                    dotHide()
                }
                if secondsCounter + secoundsPassedAfterMinutes > 59 {
                    timerDuration -= 1
                    self.secondsCounter = secondsCounter + (secoundsPassedAfterMinutes - 59)
                    if timerDuration == 0 {
                        notificationsessionEnd()
                        return
                    }
                }
                else {
                    self.secondsCounter = secondsCounter + secoundsPassedAfterMinutes
                }
                
                let itemNumber = (timerDuration)
                let topIndex = IndexPath(item: (itemNumber - 1) < 0 ? 0 : (itemNumber - 1), section: 0)
                self.counterCollectionView.scrollToItem(at: topIndex, at: UICollectionView.ScrollPosition.top, animated: true)

                invalidateTimer()
                timerRunning = true
                if alreadySaved {
                    historyDataModel.deleteLastSaved()
                    alreadySaved = false
                }
                self.centerDot.alpha = 1

                dropper()
                timer = Timer.scheduledTimer(timeInterval: fadingDuration, target: self, selector: #selector(dropper), userInfo: nil, repeats: true)
            }
        }
    }
}



// MARK:- Timer Functions
extension ViewController {
    
    func invalidateTimer() {

        if let timer = moveTimer {
            timer.invalidate()
            moveTimer = nil
        }
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
        if let timer = warmupTimer {
            timer.invalidate()
            self.timer = nil
        }
        
    }
    
    func finishEveryting() {
    
        firstCellViewCheck = 0
        invalidateTimer()
        centerDot.alpha = 0
        textFont.text = "end of session"

        self.showSettingButton()
        showTextLabel()
        fadeNumber()

        if !alreadySaved {
            historyDataModel.storeMeditation(minutesMaditated: totalMeditaionDuration, date: meditationDateStart)

            alreadySaved = true
        }
//        if !sessionEnded {
//            playSound()
//        }
        self.sessionEnded = true
        invalidateTimer()
    }
    
    func dropCenterDotWithCollectionView() {
//        centerDot.alpha = 1
        self.centerDotVerticalConstraint.constant = 0
        self.view.layoutIfNeeded()
        centerDotHide()
        self.centerDotVerticalConstraint.constant = self.cellHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }

    }
    
    // check and save streak
    func streak() {
        if let lastdate = AppStateStore.shared.streakLastDate {
            if lastdate.compare(.isYesterday) {
                AppStateStore.shared.streakLastDate = Date()
                AppStateStore.shared.streakDays += 1
            }
            else {
                if !(AppStateStore.shared.streakLastDate?.compare(.isToday) ?? true) {
                    AppStateStore.shared.streakLastDate = Date()
                    AppStateStore.shared.streakDays = 1
                }
            }
        }
        else {
            AppStateStore.shared.streakLastDate = Date()
            AppStateStore.shared.streakDays = 1
        }
    }
    
    // function moving the scroller (called after every minute)
    @objc func fire()
    {
        self.secondsCounter = 1

        firstDotInitialPlacement()
        timerDuration = timerDuration - 1
        animatedlyChangeTimer(number: self.timerDuration)
        centerDotHide()
        dropCenterDotWithCollectionView()
        dropCollectionView()

        if timerDuration < 1 {
            self.oldTimerDuration = 0
            streak()
            
            resetAllCellCircles()
            self.secondsCounter = 0

            firstCellViewCheck = 0
            invalidateTimer()
            centerDot.alpha = 0
            textFont.text = "end of session"
            self.showSettingButton()
            showTextLabel()
            fadeNumber()
            
            if !alreadySaved {
                historyDataModel.storeMeditation(minutesMaditated: totalMeditaionDuration, date: meditationDateStart)

                alreadySaved = true
            }
            if !sessionEnded {
                playSound()
            }
            self.sessionEnded = true
            invalidateTimer()
            totalMeditaionDuration = 0
        }
        else {
            self.centerDot.alpha = 1
        }
        
    }
    
    // blinker function
    @objc func dropper() {
  
        fadeNumber()
        self.centerDot.backgroundColor = ThemeSettings.sharedInstance.mainDot
        animatedlyChangeTimer(number: self.timerDuration)
        self.secondsCounter += 1
        if backFromTheDead, firstCellViewCheck > 0 {
            firstCellViewCheck = firstCellViewCheck - 1
        }
        else {
            firstCellViewCheck = 0
        }
        if secondsCounter < 50 {
            self.centerDot.alpha = 1
        }
        

        
        if secondsCounter > 59, moveTimer == nil {
            firstCellViewCheck = 0
            backFromTheDead = false
            fire()
            if let timer = moveTimer {
                timer.invalidate()
                moveTimer = nil
            }

            moveTimer = Timer.scheduledTimer(timeInterval: TimeInterval(timeIntervel), target: self, selector: #selector(fire), userInfo: nil, repeats: true)
            
        }
        
        topViewBlur.alpha = 1

        if let timer = timer, timerDuration < 0 {
            timer.invalidate()
        }
        centerDot.alpha = CGFloat(Double(100 - (Double(secondsCounter) * 1.5)) * 0.01)
        print(secondsCounter)
        if secondsCounter == 1, timerDuration < totalMeditaionDuration  {
            self.centerDot.alpha = 1
            firstDotInitialPlacement()
            return
        }
        
        if secondsCounter == 0, timerDuration < 1 {
            self.centerDot.alpha = 0
        }
        
        UIView.animate(withDuration: 0.6) {
            if self.secondsCounter == 0 {

            }
            else if self.xPhonesDotCorrection != 1 {
                self.centerDotVerticalConstraint.constant = (CGFloat(self.secondsCounter) * ((UIScreen.main.bounds.height / 2 ) / 64) ) + self.cellHeight
            }
            else {

                self.centerDotVerticalConstraint.constant = (CGFloat(self.secondsCounter) * ((UIScreen.main.bounds.height / 2 ) / 66) ) + self.cellHeight

            }
        }
    }
    
    func firstDotInitialPlacement() {
        self.centerDotVerticalConstraint.constant = self.cellHeight

    }
    
    // setts up the fade and the timer
    func settingUpTimer(index:IndexPath) {
        centerDotHide()
        centerDot.backgroundColor = ThemeSettings.sharedInstance.mainDot
        warmupSeccondsRemaning = 0

        //centerdot first placement
        firstDotInitialPlacement()

        print("setting up timer called")
        
        if index.row >= InvisibleCells {
            var topIndex = IndexPath(item: index.row - InvisibleCells - 1 + xPhonesDotCorrection , section: 0)
            
            if index.row == 13 , UIScreen.main.bounds.height > 811 {
                topIndex = IndexPath(item: index.row - InvisibleCells - 1  , section: 0)
            }
       
            self.counterCollectionView.scrollToItem(at: topIndex, at: UICollectionView.ScrollPosition.top, animated: true)
        }
        
        let cell = counterCollectionView.cellForItem(at: index) as? CollectionViewCounterCell
        self.timerDuration = cell?.tag ?? 0
        if timerDuration < 1 {
            return
        }
        if timerDuration > 0 {
            if index.row > InvisibleCells {
                animatedlyChangeTimer(number: self.timerDuration)
            }
        }
        alreadySaved = false
        invalidateTimer()
        timerRunning = true
        
        // to not update the date when the complex session starts
        if oldTimerDuration < 1 {
            meditationDateStart = Date()
        }
        self.sessionEnded = false
        startTimer()
    }
    
    func startTimer() {
        //setting up scheduled timer
        centerDotHide()
        self.topViewBlur.alpha = 1
        moveTimer = Timer.scheduledTimer(timeInterval: TimeInterval(timeIntervel), target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        self.secondsCounter = 0
        //sometimes it also shows timer number when i go below 0
        timer = Timer.scheduledTimer(timeInterval: fadingDuration, target: self, selector: #selector(dropper), userInfo: nil, repeats: true)
        if timerDuration == 0 {
            timerRunning = false
            invalidateTimer()
            stopAnimation()
        }
    }
    
    // warmuptimer Dot Setting
    func warmUpDotSet() {
        
        warmupSeccondsRemaning = 60 - secondsCounter
        timerForWarmup(number: 60 - secondsCounter)
        topViewBlur.alpha = 1

        if let timer = timer, timerDuration < 0 {
            timer.invalidate()
        }
        
        UIView.animate(withDuration: 0.6) {
            
            if self.xPhonesDotCorrection != 1 {
                self.centerDotVerticalConstraint.constant = CGFloat(self.secondsCounter) * ((UIScreen.main.bounds.height / 2 ) / 62)
            }
            else {
                self.centerDotVerticalConstraint.constant = CGFloat(self.secondsCounter) * ((UIScreen.main.bounds.height / 2 ) / 60) - 8
            }
        }
    }
    
    // warmup functions
    
    @objc func warmupTimerRunning(sender: Timer) {
        let userInfo = sender.userInfo as! [String: Any]
        let index = userInfo["index"] as! IndexPath
        dontShowSecoundsLabel = false
        centerDot.backgroundColor = UIColor.clear
        doughnet()
      
        self.secondsCounter += 1
        self.centerDot.alpha = 1
        
        warmUpDotSet()
        fadeNumber()
        if secondsCounter >= 60 {
            invalidateTimer()
            settingUpTimer(index: index)
            self.dropCenterDotWithCollectionView()
            dropCollectionView()
            if AppStateStore.shared.isProUser, oldTimerDuration < 1, AppStateStore.shared.warmupTimerIntervel > 0, AppStateStore.shared.isWarmupTimerOn {
                playWarmupSound()
//                playSound()
            }
        }
    }
    
    func timerForWarmup(number:Int) {
        labelNumber.textColor = ThemeSettings.sharedInstance.mainText
        let newNumber:Int = number < 0 ?  0 :  number
        
        UIView.animate(withDuration: 0.3) {
            let mutableString = NSMutableAttributedString(string: String(newNumber) + "sec")
            let size = mutableString.length - 3
            mutableString.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)], range: NSMakeRange(size, 3))
            self.labelNumber.attributedText = mutableString
            //            self.labelNumber.text = String(newNumber) + "min"
        }
    }
    
    func setupWarmupTimer(index:IndexPath, number:Int = 0) {
        
        let cell = counterCollectionView.cellForItem(at: index) as? CollectionViewCounterCell
        if warmupSeccondsRemaning < 1 {
            oldTimerDuration = self.timerDuration
        }
        
        
        // when timer is finished and this is called for the top invisible cells
        if timerDuration > 0 , warmupSeccondsRemaning < 1{
            self.timerDuration = cell?.tag ?? 0
            if timerDuration < 1 {
                finishEveryting()
                dropCollectionView(correction: 0)
                return
            }
            secondsCounter = 60
        }
        else {
            // pro user check to see if we want to start warmup timer or not
            if AppStateStore.shared.isProUser, AppStateStore.shared.isWarmupTimerOn {
                secondsCounter = (60 - (AppStateStore.shared.warmupTimerIntervel + 1) + number)
            }
            else {
                // warmuptimer set to zero
                secondsCounter = 60 + number
            }
            
            if timerDuration < 1 {
                meditationDateStart = Date().addingTimeInterval(TimeInterval(-1 * (AppStateStore.shared.warmupTimerIntervel + 1)))
            }
        }
        
        self.timerDuration = cell?.tag ?? 0
        // fix for the end abrupt scroll because the index is nil
        if index.row > 102 {
            self.timerDuration = 90
        }
        timerDuration = index.row - InvisibleCells - 1 //Calculating minues from index
        
        if index.row - InvisibleCells > 90 {
            self.timerDuration = 90
        }
        print(self.timerDuration)
        
        if timerDuration < 1 {
            finishEveryting()
            dropCollectionView(correction: 0)
            return
        }
        hideSettingButton()
        centerDot.backgroundColor = ThemeSettings.sharedInstance.warmupColor
        self.sessionEnded = false
        self.alreadySaved = false
        if index.row >= InvisibleCells {
            var topIndex = IndexPath(item: index.row - InvisibleCells - 1  , section: 0)
            if index.row == 13 , UIScreen.main.bounds.height > 811 {
                topIndex = IndexPath(item: index.row - InvisibleCells - 1  , section: 0)
            }
        
            self.counterCollectionView.scrollToItem(at: topIndex, at: UICollectionView.ScrollPosition.top, animated: true)
        }
        
        let cellTest = counterCollectionView.cellForItem(at: index) as? CollectionViewCounterCell

        self.timerDuration = cellTest?.tag ?? 0
        
        // check so the time doesn't change after coming from background
        if number < 1 &&  !timerRunning{
            meditationDateStart = Date().addingTimeInterval(TimeInterval(-1 * (AppStateStore.shared.warmupTimerIntervel + 1)))
        }
        
        totalMeditaionDuration = timerDuration
        if timerDuration > 0 {
            if index.row > InvisibleCells {
                if alreadySaved {
                    storeDateBySubtructingTime()
                    totalMeditaionDuration = timerDuration
                }
                else {
                    let secondsPassed = Date().timeIntervalSince(meditationDateStart)
                    let minutesPassed = Int(secondsPassed / 60)
                    totalMeditaionDuration = minutesPassed + timerDuration
                }
                
            }
            if AppStateStore.shared.isProUser {
                showNumberForEndSession()
            }
            
        }
        alreadySaved = false
        invalidateTimer()
        
        timerRunning = true
        warmupSeccondsRemaning = 60 - secondsCounter
        warmupTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(warmupTimerRunning(sender:)), userInfo: ["index": index], repeats: true)
        
    }
    
}

// MARK:- Notification Functions
extension ViewController {
    
    func scheduleNotifiationForWarmup(number:Int) {
    //        guard number > 0 else {
    //            return
    //        }
            var updatedNumber = number
            
            if number < 0 {
                var time = timerDuration - 1
                if time < 0 {
                    time = 0
                }
                updatedNumber = (time * 60) + abs(60 - secondsCounter)
                print("secounds \(secondsCounter)")
                print("notification \(updatedNumber)")
                print("updating time  for notification: \(updatedNumber)")
            }

            
            let content = UNMutableNotificationContent()
            content.title = ""
            //        "Your meditation period has ended"
            if AppStateStore.shared.soundOn {
                let soundName = AppStateStore.shared.warmupSoundName() + ".mp3"
                
                content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: soundName))
            }
            else {
                let soundName = "silence.mp3"
                
                content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: soundName))
            }
            content.badge = 1
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(updatedNumber), repeats: false)
            let request = UNNotificationRequest(identifier: warmupNotification, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (Error) in
                
            }
            
        }
    
    func scheduleNotifiation(number:Int) {
//        guard number > 0 else {
//            return
//        }
        var updatedNumber = number
        
        if number < 0 {
            var time = timerDuration - 1
            if time < 0 {
                time = 0
            }
            updatedNumber = (time * 60) + abs(60 - secondsCounter)
            print("secounds \(secondsCounter)")
            print("notification \(updatedNumber)")
            print("updating time  for notification: \(updatedNumber)")
        }

        
        let content = UNMutableNotificationContent()
        content.title = ""
        //        "Your meditation period has ended"
        if AppStateStore.shared.soundOn {
            let soundName = AppStateStore.shared.soundName() + ".mp3"
            
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: soundName))
        }
        else {
            let soundName = "silence.mp3"
            
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: soundName))
        }
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(updatedNumber), repeats: false)
        let request = UNNotificationRequest(identifier: notificationIdentifyer, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (Error) in
            
        }
        
    }
    
    func notificationsessionEnd() {
        self.secondsCounter = 0
        self.timerDuration = 0
        oldTimerDuration = 0
        let itemNumber = (timerDuration - 1)
        let topIndex = IndexPath(item: itemNumber < 0 ? 0 : itemNumber, section: 0)
        
        self.counterCollectionView.scrollToItem(at: topIndex, at: UICollectionView.ScrollPosition.top, animated: true)

        animatedlyChangeTimer(number: 0)
        invalidateTimer()
        timerRunning = false
        centerDot.alpha = 0
        textFont.text = "end of session"
        self.showSettingButton()
        self.textFont.alpha = 1
//        showTextLabel()
        fadeNumber()
        self.labelNumber.alpha = 0
        setFirstDotColor()
        resetAllCellCircles()
        self.sessionEnded = true
        AppStateStore.shared.resetTimer = false
    }

}

// MARK:- Helper Functions
extension ViewController {
    
}

