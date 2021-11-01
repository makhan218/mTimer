//
//  DailyLogsViewController.swift
//  MCounter
//
//  Created by apple on 5/3/19.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import UIKit
import SwiftDate
import FSCalendar

struct DayLogs {
    var logs:[Logs] = []
    var dayName = ""
    var date = ""
    var type: historyCellType = .day
    init() {
    
    }
}

enum historyCellType:Int {
    case week = 0
    case heading = 1
    case day = 2
}

enum LogCellStyle:Int {
    case headding = 0
    case log = 1
    case red = 2
    case green = 3
    case lastCell = 4
    case week = 5
}

class DailyLogsViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var historyLabel: UIButton!
    @IBOutlet weak var headdingLabel: UILabel!
    @IBOutlet weak var forewardButton: UIButton!
    @IBOutlet weak var backWordButton: UIButton!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var historyLabelBackgroundView: UIView!
    @IBOutlet weak var topSeprator: UIView!
    @IBOutlet weak var bottomSeprator: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var calendarSeprator: UIView!
    @IBOutlet weak var tableviewHeader: UIView!
    @IBOutlet weak var calendarSepratorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topborderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomBorderHeightConstraint: NSLayoutConstraint!
    
    var reloadTimerHandler: (()-> Void)?
    
    fileprivate weak var calendar: FSCalendar!
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var loogsArr:[Logs] = []
    var dailyLogs:[DayLogs] = []
    let dataModel = HistoryDataModel()
    var stringArray:[(String,String, LogCellStyle)] = []
    var startDateOfMonth:Date = Date()
    var topTitle = ""
    var numberOfRows = 0
    
    var darkTheme = false
    
    static func instance() -> DailyLogsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let historyViewController = storyboard.instantiateViewController(withIdentifier: "DailyLogsViewController") as! DailyLogsViewController
        return historyViewController
    }
    
    func fullMonthName(date:Date) -> String {
        let now = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let nameOfMonth = dateFormatter.string(from: now)
        return nameOfMonth
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataModel.gettingWeekleyData()
        tableview.register(UINib(nibName: "logDataCell", bundle: nil), forCellReuseIdentifier: "logDataCell")
        
        tableview.register(UINib(nibName: "HeaderLogCell", bundle: nil), forCellReuseIdentifier: "HeaderLogCell")
        tableview.allowsSelection = false
        
        let tableFooterView = UIView()
        
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
        tableview.tableFooterView = tableFooterView
//        dataSetting()
        stringArray = dataModel.gettingDailyData(startDate: Date())
        dataModel.gettingWeekleyData()
        startDateOfMonth = Date().dateAtStartOf(.month)
        headdingLabel.textColor = ThemeSettings.sharedInstance.fontColor
        self.view.backgroundColor = ThemeSettings.sharedInstance.weeklyCellBackColor
        tableview.backgroundColor = ThemeSettings.sharedInstance.backgroundColor
//        tableview.separatorColor = ThemeSettings.sharedInstance.backgroundColor
//        historyLabel.setTitleColor(ThemeSettings.sharedInstance.fontColor, for: .normal)
//        historyLabel.setImage(ThemeSettings.sharedInstance.arrowImageLeft, for: .normal)
        cancelButton.setImage(ThemeSettings.sharedInstance.crossImage, for: .normal)
        cancelButton.isHidden = true
        cancelButton.isUserInteractionEnabled = false
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let handler = reloadTimerHandler {
            handler()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if UIScreen.main.bounds.width > 413 || (UIScreen.main.bounds.width == 375.0 && UIScreen.main.bounds.height == 812.0) {
            topborderHeightConstraint.constant = 0.3
            bottomBorderHeightConstraint.constant = 0.3
            calendarSepratorHeightConstraint.constant = 0.3
        }
        else {
            topborderHeightConstraint.constant = 0.5
            bottomBorderHeightConstraint.constant = 0.5
            calendarSepratorHeightConstraint.constant = 0.5
        }
        
//        tableview.separatorColor = ThemeSettings.sharedInstance.seperatorColor
        self.headdingLabel.text = fullMonthName(date: Date())
        calendarSeprator.backgroundColor = ThemeSettings.sharedInstance.seperatorColor
        tableview.backgroundColor = ThemeSettings.sharedInstance.weeklyCellBackColor
        tableview.backgroundView?.backgroundColor = ThemeSettings.sharedInstance.weeklyCellBackColor
        historyLabelBackgroundView.backgroundColor = ThemeSettings.sharedInstance.cellBackgroundColor
        if !ThemeSettings.sharedInstance.darkTheme {
            if #available(iOS 13.0, *) {
                // Always adopt a light interface style.
                overrideUserInterfaceStyle = .light
            }
        }
        backWordButton.setImage(ThemeSettings.sharedInstance.monthArrowLeft, for: .normal)
        forewardButton.setImage(ThemeSettings.sharedInstance.monthArrowRight, for: .normal)
        
        titleLabel.textColor = ThemeSettings.sharedInstance.fontColor
        tableview.separatorColor = .clear
        topSeprator.backgroundColor = ThemeSettings.sharedInstance.seperatorColor
        bottomSeprator.backgroundColor = ThemeSettings.sharedInstance.seperatorColor

        tableviewHeader.backgroundColor = ThemeSettings.sharedInstance.weeklyCellBackColor
        
        
        do {
            
            if (self.calendar != nil) {
                return
            }
            let calendar = FSCalendar()
            
            if UIScreen.main.bounds.width > 413 {
                calendar.frame = CGRect(x: 10, y: calendarView.frame.origin.y + 20, width: calendarView.frame.width + 20, height: calendarView.frame.height - 20)
            }
            else {
                calendar.frame = CGRect(x: 10, y: calendarView.frame.origin.y + 20, width: calendarView.frame.width - 20, height: calendarView.frame.height - 20)
            }
            calendarView.backgroundColor = ThemeSettings.sharedInstance.cellBackgroundColor

        //            calendar.appearance.borderRadius = 0
            calendar.today = nil
            calendar.appearance.eventDefaultColor = ThemeSettings.sharedInstance.fontColor
        
//                    calendar.allowsMultipleSelection = true
            calendar.calendarHeaderView.isHidden = true
            calendar.appearance.selectionColor = .gray
            calendar.appearance.weekdayTextColor = ThemeSettings.sharedInstance.fontColor
            calendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
            calendar.appearance.titleFont = ThemeSettings.sharedInstance.fontMono14
            calendar.appearance.eventSelectionColor = ThemeSettings.sharedInstance.fontColor
            calendar.appearance.eventOffset = CGPoint(x: 0, y: -2)
            calendar.placeholderType = .none
           
            
            calendar.headerHeight = 1
            calendar.scrollEnabled = false
            calendar.select(Date())
            calendar.dataSource = self
            calendar.delegate = self
                    view.addSubview(calendar)
                    self.calendar = calendar
            calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "DIYcell")
                    
            calendar.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose

                    
        //            let scopeGesture = UIPanGestureRecognizer(target: calendar, action: #selector(calendar.handleScopeGesture(_:)));
        //            calendar.addGestureRecognizer(scopeGesture)
                    
                }
        
        historyLabel.tintColor = ThemeSettings.sharedInstance.backButtonColor
        historyLabel.imageView?.alpha = 0.5
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calendar.layoutSubviews()
    }

    
    @IBAction func backwardAction(_ sender: Any) {
        let dateInPrevioustMonth = startDateOfMonth.addDaysToDate(number: -10)
        startDateOfMonth = dateInPrevioustMonth.dateAtStartOf(.month)
        stringArray.removeAll()
        self.calendar.setCurrentPage(startDateOfMonth, animated: true)
        stringArray = dataModel.gettingDailyData(startDate: startDateOfMonth)
        self.headdingLabel.text = fullMonthName(date: startDateOfMonth)
        self.tableview.reloadData()
        self.calendar.select(startDateOfMonth)
        
    }
    
    @IBAction func forewardAction(_ sender: Any) {
        
        let dateInNextMonth = startDateOfMonth.addDaysToDate(number: 40)
        if dateInNextMonth.dateAtStartOf(.month) > Date() {
            return
        }
        startDateOfMonth = dateInNextMonth.dateAtStartOf(.month)
        stringArray.removeAll()
        self.calendar.setCurrentPage(startDateOfMonth, animated: true)
        stringArray = dataModel.gettingDailyData(startDate: startDateOfMonth)
        self.headdingLabel.text = fullMonthName(date: startDateOfMonth)
        self.tableview.reloadData()
        
        if startDateOfMonth.isInside(date: Date(), granularity: .month) {
            self.calendar.select(Date())
        }
        else {
                self.calendar.select(startDateOfMonth)
        }
    
    }
    
    @IBAction func historyButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
    }
    
    
}


extension DailyLogsViewController: UITableViewDelegate {
    
}

extension DailyLogsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if stringArray.count > 0 && stringArray[0].1 == "00h 00m" {
            numberOfRows = 1
            return 1
        }
        else {
            numberOfRows = stringArray.count + 1
            return stringArray.count + 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "logDataCell") as! logDataCell
        
        if indexPath.row == 1 {
            let cell = tableview.dequeueReusableCell(withIdentifier: "HeaderLogCell") as! HeaderLogCell
            cell.setupView()
            
            return cell

        }
        var row = indexPath.row
        if row > 1 {
            row = row - 1
        }
//        cell.leftLabel.textColor = ThemeSettings.sharedInstance.fontColor
//        cell.rightLabel.textColor = ThemeSettings.sharedInstance.fontColor
        
        cell.leftLabel.text = stringArray[row].0
        cell.rightLabel.text = stringArray[row].1
        cell.cellStyle = stringArray[row].2
        
        
        if row + 2 < stringArray.count {
            if stringArray[row + 1].2 == .headding {
                cell.lastCell = true
            }
            else {
                cell.lastCell = false
            }
        }
        
        cell.setUpCell()
        if row < stringArray.count - 1 && stringArray[row + 1].2 == .headding {
            cell.lastCell = true
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
//            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
            cell.lastCell = false
            
        }
        if indexPath.row  == numberOfRows - 1 {
        cell.lastCell = true
        }
        cell.setUpCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    func timeString(number:Int) -> String {
        if number >= 60 {
            let hours = Int(number / 60)
            let minutes = number - ( hours * 60 )
            
            return String(hours) + "h " + String(minutes) + "min"
            
        }
        
        return String(number) + "min"
    }
    
}

extension DailyLogsViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    
    
    // MARK:- FSCalendarDataSource
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "DIYcell", for: date, at: position) as! DIYCalendarCell
        return cell
    }
    
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: (cell as! DIYCalendarCell), for: date, at: position)
    }
    
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        if self.gregorian.isDateInToday(date) {
//            return "今"
//        }
//        return nil
//    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let testdate = date.setTime(hour: 04, min: 20, sec: 00, date: date) ?? Date()
        var tomorrow = testdate.addDaysToDate(number: 1)
        tomorrow = tomorrow.setTime(hour: 04, min: 20, sec: 00, date: tomorrow) ?? Date()
        
        var yesturday = testdate.addDaysToDate(number: -1)
        yesturday = yesturday.setTime(hour: 04, min: 20, sec: 00, date: yesturday) ?? Date()
        
//        print("yesturday: \(yesturday)")
//        print("today:     \(testdate)")
//        print("tomorrow:  \(tomorrow)")
        
        
//        if dataModel.datesOfPeace.contains(testdate) && !(dataModel.datesOfPeace.contains(tomorrow) || dataModel.datesOfPeace.contains(yesturday)) {
//            print(dataModel.datesOfPeace.contains(testdate) && !(dataModel.datesOfPeace.contains(tomorrow) || dataModel.datesOfPeace.contains(yesturday)))
//            return 1
//        }
        
        
        return 0
    }
    
    
    // MARK:- FSCalendarDelegate
       
       func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
           self.calendar.frame.size.height = bounds.height

       }
       
       
       func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
           return monthPosition == .current
       }
       
       
       func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
           print("did deselect date \(self.formatter.string(from: date))")
           self.configureVisibleCells()
       }
       
       func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
//           if self.gregorian.isDateInToday(date) {
//               return [UIColor.orange]
//           }
           return [appearance.eventDefaultColor]
       }
    
    // MARK: - Private functions
           
           private func configureVisibleCells() {
               calendar.visibleCells().forEach { (cell) in
                   let date = calendar.date(for: cell)
                   let position = calendar.monthPosition(for: cell)
                   self.configure(cell: cell, for: date!, at: position)
               }
           }
           
           private func
        configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
               
               let diyCell = (cell as! DIYCalendarCell)
//            if let indicator = diyCell.eventIndicator {
//                indicator.removeFromSuperview()
//            }
//            diyCell.eventIndicator.isHidden = true
            
            
//            diyCell.undraw()
            let testdate = date.setTime(hour: 04, min: 20, sec: 00, date: date) ?? Date()
            var tomorrow = testdate.addDaysToDate(number: 1)
            tomorrow = tomorrow.setTime(hour: 04, min: 20, sec: 00, date: tomorrow) ?? Date()
            
            var yesturday = testdate.addDaysToDate(number: -1)
            yesturday = yesturday.setTime(hour: 04, min: 20, sec: 00, date: yesturday) ?? Date()
            
            if dataModel.datesOfPeace.contains(testdate) {
                diyCell.hasLine = true
            }
            else {
                diyCell.hasLine = false
            }
            
//            if dataModel.datesOfPeace.contains(testdate),(dataModel.datesOfPeace.contains(tomorrow) || dataModel.datesOfPeace.contains(yesturday) ) {
////                diyCell.drawLine()
//                diyCell.hasLine = true
//            }
//            else {
////                diyCell.undraw()
//                diyCell.hasLine = false
//            }
            
            
               // Custom today circle
    //           diyCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
               // Configure selection layer
            
            if Calendar.current.isDate(date, inSameDayAs:Date()){
                print("today date: \(date)")
                diyCell.circleImageView.isHidden = false 
            }
            else {
                diyCell.circleImageView.isHidden = true
            }
               if position == .current {
                   
                   var selectionType = SelectionType.none
                   
                   if calendar.selectedDates.contains(date) {
                       let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                       let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                       if calendar.selectedDates.contains(date) {
                           if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
                               selectionType = .middle
                           }
                           else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(date) {
                               selectionType = .rightBorder
                           }
                           else if calendar.selectedDates.contains(nextDate) {
                               selectionType = .leftBorder
                           }
                           else {
                               selectionType = .single
                           }
                       }
                   }
                   else {
                       selectionType = .none
                   }
                   if selectionType == .none {
                       diyCell.selectionLayer.isHidden = true
                       return
                   }
                   diyCell.selectionLayer.isHidden = false
                   diyCell.selectionType = selectionType
                   
               } else {
    //               diyCell.circleImageView.isHidden = true
                   diyCell.selectionLayer.isHidden = true
               }
           }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        if date.dateAtStartOf(.month) > Date() {
            return
        }
        startDateOfMonth = date.dateAtStartOf(.month)
        stringArray.removeAll()
        stringArray = dataModel.gettingDailyData(startDate: date)
        self.headdingLabel.text = fullMonthName(date: startDateOfMonth)
        self.configureVisibleCells()
        self.tableview.reloadData()
        
        
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        
        return ThemeSettings.sharedInstance.backgroundColor
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        if date > Date() {
            return .gray
        }
        
        return ThemeSettings.sharedInstance.fontColor
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        if date > Date() {
            return false
        }
        return monthPosition == .current
    }

    
}
