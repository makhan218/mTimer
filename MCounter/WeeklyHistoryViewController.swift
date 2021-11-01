//
//  WeeklyHistoryViewController.swift
//  MCounter
//
//  Created by apple on 5/2/19.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import UIKit

class WeeklyHistoryViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var settiongsLabel: UIButton!
    @IBOutlet weak var historyLabel: UILabel!
    let dateModel = HistoryDataModel()
    var darkTheme = false
    var weeklyDataArr:[WeeklyLogsData] = []
    
    static func instance() -> WeeklyHistoryViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let historyViewController = storyboard.instantiateViewController(withIdentifier: "WeeklyHistoryViewController") as! WeeklyHistoryViewController
        return historyViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = UITableView.automaticDimension
        tableview.register(UINib(nibName: "WeeklyHistoryCell", bundle: nil), forCellReuseIdentifier: "WeeklyHistoryCell")
        dateModel.gettingWeekleyData()
        weeklyDataArr = dateModel.weeklyLogsArr
        weeklyDataArr.reverse()
        tableview.tableFooterView = UIView()
        darkTheme = ThemeSettings.sharedInstance.darkTheme
        historyLabel.textColor = ThemeSettings.sharedInstance.fontColor
        self.view.backgroundColor = ThemeSettings.sharedInstance.backgroundColor
        tableview.backgroundColor = ThemeSettings.sharedInstance.backgroundColor
        settiongsLabel.setTitleColor(ThemeSettings.sharedInstance.fontColor, for: .normal)
        tableview.separatorColor = ThemeSettings.sharedInstance.seperatorColor
        if ThemeSettings.sharedInstance.darkTheme {
            settiongsLabel.setImage(ThemeSettings.sharedInstance.arrowImageLeft, for: .normal)
        }
        else {
            settiongsLabel.setImage(ThemeSettings.sharedInstance.arrowImageLeft, for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WeeklyHistoryViewController: UITableViewDelegate {
    
}

extension WeeklyHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "WeeklyHistoryCell") as! WeeklyHistoryCell
        cell.darkTheme = self.darkTheme
        let startMonthName = getMonthName(date: weeklyDataArr[indexPath.row].startDate ?? Date())
        let endMonthName = getMonthName(date: weeklyDataArr[indexPath.row].endDate ?? Date())
        let stringLabel = startMonthName + " " + String(justDate(date: weeklyDataArr[indexPath.row].startDate ?? Date())) + "-" + endMonthName + " " + String(justDate(date: weeklyDataArr[indexPath.row].endDate ?? Date()))
        weeklyDataArr[indexPath.row].title = stringLabel
        let leftLabelString = stringLabel
        cell.leftLabel.text = leftLabelString
        if checkForThisWeek(date: weeklyDataArr[indexPath.row].startDate ?? Date()) {
            cell.leftLabel.text = "This Week"
        }
        else if checkForLastWeek(date: weeklyDataArr[indexPath.row].startDate ?? Date()) {
            cell.leftLabel.text = "Last Week"
        }
        
        cell.timeLabel.text = timeString(number: weeklyDataArr[indexPath.row].totalSum)
        cell.selectionStyle = .none
        cell.leftLabel.textColor = ThemeSettings.sharedInstance.fontColor
        cell.timeLabel.textColor = ThemeSettings.sharedInstance.fontColor
        cell.contentView.backgroundColor = ThemeSettings.sharedInstance.backgroundColor
       
        return cell
    }
    
    func timeString(number:Int) -> String {
        if number >= 60 {
            let hours = Int(number / 60)
            let minutes = number - ( hours * 60 )
            
            return String(hours) + "h " + String(minutes) + "min"

        }
        
        return String(number) + "min"
    }
    
    func getMonthName(date:Date) -> String {
        let now = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLL"
        let nameOfMonth = dateFormatter.string(from: now)
        return nameOfMonth
    }
    
    func justDate(date:Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return components.day ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = DailyLogsViewController.instance()
        viewController.loogsArr = weeklyDataArr[indexPath.row].singleWeekLogs
        viewController.topTitle = weeklyDataArr[indexPath.row].title
   
        if checkForLastWeek(date: (weeklyDataArr[indexPath.row].startDate ?? Date())) {
            
            viewController.topTitle = "Last Week"
            
        }else if checkForThisWeek(date: weeklyDataArr[indexPath.row].startDate ?? Date()) {
                viewController.topTitle = "This Week"
            }
            
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
    func checkForThisWeek(date:Date) -> Bool {
        let endDate = date.addDaysToDate(number: 8)
        if Date() >= date && Date() <= endDate {
            return true
        }
        return false
    }
    
    func checkForLastWeek(date:Date) -> Bool {
       
        let startOfLastWeek = Date().startOfWeek?.addDaysToDate(number: -7)
        let endDate = startOfLastWeek?.addDaysToDate(number: 6)
        if (startOfLastWeek ?? Date()) <= date && date <= (endDate ?? Date()) {
            return true
        }
        return false
    }
    
}
