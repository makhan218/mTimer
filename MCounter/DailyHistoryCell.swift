//
//  DailyHistoryCell.swift
//  MCounter
//
//  Created by apple on 5/6/19.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import UIKit

class DailyHistoryCell: UITableViewCell ,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topRightLabel: UILabel!
    @IBOutlet weak var topLeftLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    var layoutSubviewsForParent:(()->Void)?
    var dataArr:[Logs] = []
    var subMenuTable:UITableView?
    
    
//    required init(coder aDecoder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
////        setUpTable()
//    }
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style , reuseIdentifier: reuseIdentifier)
//        setUpTable()
//    }
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        setUpTable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.contentView.backgroundColor = UIColor.purple
        // Initialization code
        topRightLabel.font = ThemeSettings.sharedInstance.font21
        topLeftLabel.font  = ThemeSettings.sharedInstance.font21
        setUpTable()
    }
    
    func setUpTable(){
    
        tableview.register(UINib(nibName: "logDataCell", bundle: nil), forCellReuseIdentifier: "logDataCell")
//        subMenuTable = UITableView(frame: CGRect.zero, style:UITableView.Style.plain)
        tableview?.delegate = self
        tableview?.dataSource = self
        tableview.separatorStyle = .none
//        self.addSubview(subMenuTable!)
    }
    
    override func layoutSubviews() {
        self.tableViewHeightConstraint.constant = self.tableview.contentSize.height
        super.layoutSubviews()
        if let layoutSubviewsForParent = layoutSubviewsForParent {
            layoutSubviewsForParent()
        }
//        subMenuTable?.frame = CGRect(x: 0.2, y: 0.3, width: self.bounds.size.width-5, height: self.bounds.size.height-5)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "logDataCell") as! logDataCell
        
        cell.leftLabel.text = getTimeString(date: dataArr[indexPath.row].date as Date? ?? Date())
        cell.rightLabel.text = String(dataArr[indexPath.row].minutes) + "min"
        layoutIfNeeded()
        self.layoutSubviews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.layoutSubviews()
        layoutIfNeeded()
    }
    
    func getTimeString(date:Date) -> String {
        
        var calendar = Calendar.current
        
        // *** Get components using current Local & Timezone ***
        print(calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date))
        
        // *** define calendar components to use as well Timezone to UTC ***
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        // *** Get All components from date ***
        let components = calendar.dateComponents([.hour, .year, .minute], from: date)
        print("All Components : \(components)")
        
        // *** Get Individual components from date ***
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
//        let seconds = calendar.component(.second, from: date)
        return "\(hour):\(minutes)"
    }
    
}
