//
//  Logs+CoreDataProperties.swift
//  MCounter
//
//  Created by apple on 5/3/19.
//  Copyright © 2019 WeOverOne. All rights reserved.
//
//

import Foundation
import CoreData


extension Logs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Logs> {
        return NSFetchRequest<Logs>(entityName: "Logs")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var minutes: Int32
    @NSManaged public var uploaded: Int32
    @NSManaged var uniqueIdentifier: String?
    @NSManaged var creationDate: NSDate?
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        if let uniqueIdentifier = uniqueIdentifier {
            
        }
        else {
            self.uniqueIdentifier = ProcessInfo.processInfo.globallyUniqueString
            self.creationDate = NSDate()
        }
    }

}
