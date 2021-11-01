//
//  SyncToCloud.swift
//  MCounter
//
//  Created by apple on 7/29/19.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

enum CloudTypes: String {
    case recordTypeLog = "Logs"
    case inputDate     = "date"
    case inputMinutes  = "minutes"
}

class SyncTOCloud {
    
    private(set) var accountStatus: CKAccountStatus = .couldNotDetermine
    private let container = CKContainer.default()
    
    static let shared = SyncTOCloud()
    let publicCloud   = CKContainer.default().publicCloudDatabase
    let sharedCloud   = CKContainer.default().sharedCloudDatabase
    var fetchedRecords:[CKRecord] = []
    var updatedRecords:[CKRecord] = []
    var alreadyUpdating:Bool = false
    var alreadyDownloading:Bool = false
    
    init(){
        requestAccountStatus()
    }
    
    private func requestAccountStatus() {
        // Request Account Status
        container.accountStatus { [unowned self] (accountStatus, error) in
            // Print Errors
            if let error = error { print(error) }
            
            // Update Account Status
            self.accountStatus = accountStatus
        }
    }
    
    func checkAndDownloadFromCloud() {
        
        let request:NSFetchRequest<Logs> = Logs.fetchRequest()
        var totalResult:[Logs] = []
        do {
            totalResult =   try PrestianceStorage.context.fetch(request)
        } catch {
            
        }
        if totalResult.count < 2 {
            self.downloadingData()
        }
        
    }
    
    func uploadData() {
        if alreadyUpdating {
            return
        }
        
        alreadyUpdating = true
        
        let request:NSFetchRequest<Logs> = Logs.fetchRequest()
        var totalResult:[Logs] = []
        do {
            totalResult =   try PrestianceStorage.context.fetch(request)
        } catch {
            
        }
        var recordsArray:[CKRecord] = []
        
        if totalResult.count > 0 {
            for log in totalResult {
                if log.uploaded == 0 {
                 let record = CKRecord(recordType: CloudTypes.recordTypeLog.rawValue)
                    record[CloudTypes.inputDate.rawValue] = log.date
                    record[CloudTypes.inputMinutes.rawValue] = log.minutes
                    
                    recordsArray.append(record)
                }
            }
            
            let saveOperation = CKModifyRecordsOperation(recordsToSave: recordsArray, recordIDsToDelete: nil)
            
            saveOperation.perRecordCompletionBlock = {
                record, error in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                }
            }
            
            saveOperation.perRecordCompletionBlock = {
                record, error in
                if error != nil {
                    print(error?.localizedDescription ?? "No error")
                }
                self.updatedRecords.append(record)
                
            }
            
            saveOperation.completionBlock = {
                self.dbUpdateOfUploadedRecords()
                print("Saved All")
            }
            
            CKContainer.default().privateCloudDatabase.add(saveOperation)
        }
        
    }
    
    func dbUpdateOfUploadedRecords() {
        if updatedRecords.count > 0 {
            var dateArray:[NSDate] = []
            for record in updatedRecords {
                dateArray.append(record[CloudTypes.inputDate.rawValue] ?? NSDate())
            }
            
            let request:NSFetchRequest<Logs> = Logs.fetchRequest()
            request.predicate = NSPredicate(format: " date IN %@ ", dateArray)
            var totalResult:[Logs] = []
            do {
                totalResult =   try PrestianceStorage.context.fetch(request)
            } catch {
                print(error.localizedDescription)
                
            }
            for record in updatedRecords {
                let index = totalResult.index(where:{$0.date == record[CloudTypes.inputDate.rawValue]})
                if let i = index {
                    totalResult[i].uniqueIdentifier = record.recordID.recordName
                    totalResult[i].uploaded = 1
                }
            }
            
            PrestianceStorage.saveContext()
            updatedRecords.removeAll()
            alreadyUpdating = false
        }
    }
    
    func downloadingData() {
        
        if alreadyDownloading {
            return
        }
        alreadyDownloading = true
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: CloudTypes.recordTypeLog.rawValue, predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        
        queryOperation.resultsLimit = 200
        queryOperation.recordFetchedBlock = {
            record in
            self.fetchedRecords.append(record)
        }
        
        queryOperation.queryCompletionBlock = {
            curser, error in
            if curser != nil {
                self.reDownload(curser: curser!)
                
            }
            else {
                self.alreadyDownloading = false
                self.dbUStoreFetchedRecord()
            }
        }
        
        
        CKContainer.default().privateCloudDatabase.add(queryOperation)
    }
    
    func reDownload(curser:CKQueryOperation.Cursor) {
        
        let queryOperation = CKQueryOperation(cursor: curser)
        
        queryOperation.resultsLimit = 200
        
        queryOperation.recordFetchedBlock = {
            record in
            self.fetchedRecords.append(record)
        }
        
        queryOperation.queryCompletionBlock = {
            curser, error in
            if curser != nil {
                self.reDownload(curser: curser!)
                
            }
            else {
                self.alreadyDownloading = false 
                self.dbUStoreFetchedRecord()
            }
        }
        
        
        CKContainer.default().privateCloudDatabase.add(queryOperation)
    }
    
    func dbUStoreFetchedRecord() {
        if fetchedRecords.count > 0 {
            
            let request:NSFetchRequest<Logs> = Logs.fetchRequest()
            var totalResult:[Logs] = []
            do {
                totalResult =   try PrestianceStorage.context.fetch(request)
            } catch {
                
            }
         
            for record in fetchedRecords {
                if !totalResult.contains(where: { $0.date == record[CloudTypes.inputDate.rawValue] as? NSDate }) {
                    let log = Logs(context: PrestianceStorage.context)
                    log.date = record[CloudTypes.inputDate.rawValue]
                    log.minutes = record[CloudTypes.inputMinutes.rawValue] ?? -1
                    log.uniqueIdentifier = record.recordID.recordName
                    totalResult.append(log)
                }
            }
            PrestianceStorage.saveContext()
            fetchedRecords.removeAll()
        }
    }
    
}
