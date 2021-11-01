//
//  HistoryDataModel.swift
//  MCounter
//
//  Created by apple on 5/3/19.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import Foundation
import CoreData
import SwiftDate

struct WeeklyLogsData {
    var startDate:Date?
    var endDate:Date?
    var totalSum:Int = 0
    var singleWeekLogs:[Logs] = []
    var title = ""
    
    init() {
    }
}

class HistoryDataModel {
    
    var weeklyLogsArr:[WeeklyLogsData] = []
    var datesOfPeace:[Date] = []
    
    func storeMeditation(minutesMaditated:Int, date: Date) {
//        let calendar = Calendar.current
//        let newDate = calendar.date(byAdding: .minute, value: (minutesMaditated * -1), to: date)
        if minutesMaditated < 1 || !AppStateStore.shared.isProUser {
            return 
        }
        let log = Logs(context: PrestianceStorage.context)
        log.minutes = Int32(minutesMaditated)
        log.date = (date) as NSDate
        gettingWeekleyData()
        PrestianceStorage.saveContext()
    }
    
    func deleteLastSaved () {
        if !AppStateStore.shared.isProUser {
            return
        }
        
        let fetchRequest:NSFetchRequest<Logs> = Logs.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 1
        var totalResult:[Logs] = []
        do {
            totalResult =   try PrestianceStorage.context.fetch(fetchRequest)
        } catch {
            
        }
        
        if totalResult.count < 1 {
            return
        }
        let topLog = totalResult.first as! NSManagedObject
        PrestianceStorage.context.delete(topLog)
        PrestianceStorage.saveContext()
    }
    
    func updateLastLog(minute:Int) {
        if !AppStateStore.shared.isProUser {
            return
        }
        
        let fetchRequest:NSFetchRequest<Logs> = Logs.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 1
        
        var totalResult:[Logs] = []
        do {
            totalResult =   try PrestianceStorage.context.fetch(fetchRequest)
        } catch {
            
        }
        
        if totalResult.count < 1 {
            return
        }
        let topLog = totalResult.first as! NSManagedObject
        topLog.setValue(minute, forKey: "minutes")
        
        PrestianceStorage.saveContext()
    }
    
    func returnEmptyWeek(startDate:Date) ->  WeeklyLogsData {
        var week = WeeklyLogsData()
        week.totalSum = 0
        week.startDate = startDate
        week.endDate = startDate.addDaysToDate(number: 7)
        week.singleWeekLogs = []
        return week
    }
    
    func gettingDailyData(startDate: Date) -> [(String,String, LogCellStyle)] {
        
        
        var stringArray:[(String,String, LogCellStyle)] = [] // result string
        let dayStart = startDate.setTime(hour: 00, min: 00, sec: 01, date: startDate) ?? Date()
        let dayEnd   = startDate.setTime(hour: 23, min: 59, sec: 59, date: startDate) ?? Date()
        var dailyLogs:[DayLogs] = []
        var dailySum = 0
        var dayLogs:[Logs] = []
        
        let thisWeek = weeklyLogsArr.filter {
            if $0.endDate ?? Date() > dayStart && $0.startDate ?? Date() < dayEnd {
                return true
            }
            else {
                return false
            }
            
        }
        
        if thisWeek.count > 0 {
            
            dayLogs = thisWeek.first?.singleWeekLogs.filter({
            if ($0.date ?? NSDate()) as Date > dayStart, (($0.date ?? NSDate()) as Date) < dayEnd {
                dailySum = dailySum + Int($0.minutes)
                return true
            }
            else {
                return false
            }
        }) ?? []

            
        }
        else {
            
        }
        
        dailyLogs.append(DayLogs())
        
        dailyLogs[0].logs = dayLogs
        
        dailyLogs[dailyLogs.count - 1].dayName = shortDayFromNumber(number: startDate.dayNumberOfWeek() ?? 0) + ", " + String(justDate(date: startDate)) + " " + getMonthName(date: startDate )
        
        dailyLogs[dailyLogs.count - 1].date = minutesToHoursString(minutes: dailySum)
        
        
        for arr in dailyLogs {
                    if arr.type == .week {
                        stringArray.append((arr.dayName, arr.date, LogCellStyle.week))
                        continue
                    }
        

                    stringArray.append((arr.dayName, arr.date, LogCellStyle.headding))
                    
                    for log in arr.logs {

                        if log.minutes > 59 {
                            stringArray.append((getTimeString(date: log.date as Date? ?? Date()), minutesToHoursString(minutes: Int(log.minutes)),LogCellStyle.green))
                            continue
                        }
                        stringArray.append((getTimeString(date: log.date as Date? ?? Date()),  minutesToHoursString(minutes: Int(log.minutes)),LogCellStyle.log))
                    }
                    if arr.logs.count < 1 {
                        stringArray.append((" ", minutesToHoursString(minutes: 0),LogCellStyle.red))
                    }
                }
        
        
        return stringArray
    }
    
    func gettingMonthlyData(startDate: Date) -> [(String,String, LogCellStyle)] {
        
        var stringArray:[(String,String, LogCellStyle)] = []
        stringArray.removeAll()
        
        let endOfMonth = startDate.dateAtEndOf(.month)
        print(endOfMonth)
        self.gettingWeekleyData()
        var dailyLogs:[DayLogs] = []
        dailyLogs.removeAll()
        
        var weeksInThisMonth = weeklyLogsArr.filter {
            if $0.endDate ?? Date() > startDate && $0.startDate ?? Date() < endOfMonth {
                return true
            }
            else {
                return false
            }
            
        }
        
        if weeksInThisMonth.count > 0 {

            while ((weeksInThisMonth[0].startDate ?? Date()) > startDate) {
                weeksInThisMonth.insert(returnEmptyWeek(startDate: (weeksInThisMonth[0].startDate ?? Date()).addDaysToDate(number: -7)), at: 0)
            }

            while (weeksInThisMonth[weeksInThisMonth.count - 1].endDate ?? Date() ) < endOfMonth {
                weeksInThisMonth.append(returnEmptyWeek(startDate: (weeksInThisMonth[weeksInThisMonth.count - 1].endDate ?? Date() )))
            }

        }
        else {
            if startDate.weekday > 1 {
                let start = startDate.addDaysToDate(number: (startDate.weekday - 1) * -1)

                weeksInThisMonth.append(returnEmptyWeek(startDate: start))

                while (weeksInThisMonth[weeksInThisMonth.count - 1].endDate ?? Date() ) < endOfMonth {
                    weeksInThisMonth.append(returnEmptyWeek(startDate: (weeksInThisMonth[weeksInThisMonth.count - 1].endDate ?? Date() )))
                }
            }
            else {
                // write code for when in future the user looks at a month that starts on a sunday 
            }
        }
        
        weeksInThisMonth = weeksInThisMonth.sorted(by: { $0.startDate?.compare($1.startDate ?? Date()) == .orderedAscending })
        
        

        for week in weeksInThisMonth {
            
            var firstDate = (week.startDate)?.setTime(hour: 0, min: 0, sec: 0, date: (week.startDate ?? Date()))
            var dateEnd = (week.startDate)?.setTime(hour: 23, min: 59, sec: 59, date: (week.startDate ?? Date()))
        
            if firstDate ?? Date() > Date() {
                break
            }

            let weekStartDate = (shortDayFromNumber(number: week.startDate?.dayNumberOfWeek() ?? 0) + ", " + String(justDate(date: week.startDate ?? Date())) + " " + getMonthName(date: week.startDate ?? Date()))
            let weekEndDate = (shortDayFromNumber(number: week.endDate?.addDaysToDate(number: -1).dayNumberOfWeek() ?? 0) + ", " + String(justDate(date: week.endDate?.addDaysToDate(number: -1) ?? Date())) + " " + getMonthName(date: week.endDate?.addDaysToDate(number: -1) ?? Date()))
            
            let finalDate = weekStartDate +  " - "  + weekEndDate
            
            dailyLogs.append(DayLogs())
            dailyLogs[dailyLogs.count - 1].dayName = finalDate
            dailyLogs[dailyLogs.count - 1].date = minutesToHoursString(minutes: week.totalSum)
            dailyLogs[dailyLogs.count - 1].logs = []
            dailyLogs[dailyLogs.count - 1].type = .week
            
            for _ in 0...6 {
                if firstDate ?? Date() > Date() {
                    break
                }
                dailyLogs.append(DayLogs())
                
                var dailySum = 0
                
                dailyLogs[dailyLogs.count - 1].logs = week.singleWeekLogs.filter({
                    if (($0.date as Date?) ?? Date()) >= (firstDate ?? Date()) && (($0.date as Date?) ?? Date()) <= (dateEnd ?? Date()) {
                        dailySum = dailySum + Int($0.minutes)
                        return true
                    }
                    return false
                })
                
                dailyLogs[dailyLogs.count - 1].dayName = shortDayFromNumber(number: firstDate?.dayNumberOfWeek() ?? 0) + ", " + String(justDate(date: firstDate ?? Date())) + " " + getMonthName(date: firstDate ?? Date())
                
                dailyLogs[dailyLogs.count - 1].date = minutesToHoursString(minutes: dailySum)
                if firstDate?.dayNumberOfWeek() == 8 {
                    break
                }
                firstDate = self.addDaysToDate(date: firstDate ?? Date(), number: 1)
                dateEnd = self.addDaysToDate(date: dateEnd ?? Date(), number: 1)
//                if firstDate ?? Date() > Date() {
//                    break
//                }
            }
            
            stringArray.removeAll()
            
            
            for arr in dailyLogs {
                if arr.type == .week {
                    stringArray.append((arr.dayName, arr.date, LogCellStyle.week))
                    continue
                }
    

                stringArray.append((arr.dayName, arr.date, LogCellStyle.headding))
                
                for log in arr.logs {

                    if log.minutes > 59 {
                        stringArray.append((getTimeString(date: log.date as Date? ?? Date()), minutesToHoursString(minutes: Int(log.minutes)),LogCellStyle.green))
                        continue
                    }
                    stringArray.append((getTimeString(date: log.date as Date? ?? Date()),  minutesToHoursString(minutes: Int(log.minutes)),LogCellStyle.log))
                }
                if arr.logs.count < 1 {
                    stringArray.append((" ", minutesToHoursString(minutes: 0),LogCellStyle.red))
                }
            }
        }
        
        return stringArray
    }
    
    func minutesToHoursString(minutes:Int) -> String {
        
        let hours = Int(minutes / 60)
        let leftMinutes = minutes - (60 * hours)
        let result = (hours < 10 ?  "0" + String(hours) : String(hours)) + "h " + ((leftMinutes < 10 ?  "0" + String(leftMinutes) : String(leftMinutes)) + "m")
        return  result
    }
    
    func gettingWeekleyData() {
        
//        var firstLogDate:Date!
        var lastLogDate:Date!
        var weeklyLogs:[WeeklyLogsData] = []
        let request:NSFetchRequest<Logs> = Logs.fetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sort]
        
        var totalResult:[Logs] = []
        do {
          totalResult =   try PrestianceStorage.context.fetch(request)
        } catch {
            
        }
        
        if totalResult.count < 1 {
            return
        }
        
        let firstLogRecorded = totalResult.first
        let firstDate = firstLogRecorded?.date as Date?
        let onlydate = firstDate?.setTime(hour: 0, min: 0, sec: 0, date: firstDate ?? Date())?.startOfWeek
        
//        firstLogDate = onlydate
        
        var weekStartDate = onlydate
        
//        let lastLogRecorded = totalResult[totalResult.count - 1]
        let lastDate = Date()
//            lastLogRecorded.date as Date?
        let onlylastdate = lastDate.setTime(hour: 13, min: 59, sec: 0, date: lastDate)
        
        lastLogDate = onlylastdate?.endOfWeek
        
        let firstWeekDaysAddition = 7
//            abs((onlydate?.dayNumberOfWeek() ?? 0) - 8)
        let calendar = Calendar.current
        let dateFrom = calendar.startOfDay(for: onlydate ?? Date())
        var weekLastDate = calendar.date(byAdding: .day, value: firstWeekDaysAddition, to: dateFrom)
        
        while (true) {
            
            
            
            if (weekStartDate ?? Date() ) >= (lastLogDate ?? Date()) {
                break
            }
            
            let weeklyLog = totalResult.filter {
                if (($0.date as Date?) ?? Date()) >= (weekStartDate ?? Date()) && (($0.date as Date?) ?? Date()) <= (weekLastDate ?? Date()) {
                    return true
                }
                return false
            }
            
            weeklyLogs.append(WeeklyLogsData())
            for singleLog in weeklyLog {
                weeklyLogs[weeklyLogs.count - 1].totalSum += Int(singleLog.minutes)
                
                var dateToAdd = singleLog.date! as Date
                
                dateToAdd = dateToAdd.setTime(hour: 04, min: 20, sec: 00, date: dateToAdd) ?? Date()
                
                if !datesOfPeace.contains(dateToAdd) {
                    datesOfPeace.append(dateToAdd)
                }
                
            }
            weeklyLogs[weeklyLogs.count - 1].startDate = weekStartDate
            weeklyLogs[weeklyLogs.count - 1].endDate = weekLastDate
            weeklyLogs[weeklyLogs.count - 1].singleWeekLogs = weeklyLog
            weekStartDate = addDaysToDate(date: weekStartDate ?? Date(), number: 7)
            weekLastDate = addDaysToDate(date: weekLastDate ?? Date(), number: 7)
            
            
        }
        
        self.weeklyLogsArr = weeklyLogs
        
    }
    
    func addDaysToDate(date:Date, number:Int) -> Date {
        
        let calendar = Calendar.current
        let dateFrom = calendar.startOfDay(for: date )
        let modifyedDate = calendar.date(byAdding: .day, value: number, to: dateFrom)
        return modifyedDate ?? Date()
        
    }
    
}

extension Date {
    public func setTime(hour: Int, min: Int, sec: Int, timeZoneAbbrev: String = "UTC", date:Date) -> Date? {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: self)
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        components.timeZone = TimeZone(abbreviation: timeZoneAbbrev)
        components.hour = hour
        components.minute = min
        components.second = sec
        components.year = year
        components.month = month
        components.day = day
        
        return cal.date(from: components)
    }
    
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    func addDaysToDate( number:Int) -> Date {
        
        let calendar = Calendar.current
        let dateFrom = calendar.startOfDay(for: self )
        let modifyedDate = calendar.date(byAdding: .day, value: number, to: dateFrom)
        return modifyedDate ?? Date()
        
    }
    
}

extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 0, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
}

// MARK:- Helper Functions 
extension HistoryDataModel {
    
    func getDayFromNumber(number:Int) -> String {
        switch number {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return "Saturday"
        }
    }
    
    func shortDayFromNumber(number:Int) -> String {
        switch number {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            return "Sat"
        }
    }
    
    func getMonthName(date:Date) -> String {
           let now = date
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "LLL"
           let nameOfMonth = dateFormatter.string(from: now)
           return nameOfMonth
       }
    
    func getTimeString(date:Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: date)
        
    }
    
    func timeString(number:Int) -> String {
        if number >= 60 {
            let hours = Int(number / 60)
            let minutes = number - ( hours * 60 )
            
            return String(hours) + "h " + String(minutes) + "m"
            
        }
        
        return String(number) + "m"
    }
    
    func justDate(date:Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return components.day ?? 0
    }
    
}



