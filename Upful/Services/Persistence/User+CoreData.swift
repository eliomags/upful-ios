//
//  User+CoreDataClass.swift
//  
//
//  Created by Yanik Simpson on 6/12/20.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
    
    @NSManaged public var firstTransactionDate: Date?
    @NSManaged public var id: String?
    
}

extension User {
    
    var weeksSinceFirstTrade: Double? {
        guard let firstTransactionDate = firstTransactionDate
            else {
                return nil
        }
        
        let range = Calendar.current.dateComponents([.weekOfYear, .day, .hour, .minute],
                                                    from: firstTransactionDate,
                                                    to: Date())
        let weekDiff = Double(range.weekOfYear ?? 0)
        let dayDiff = Double((range.day ?? 0)) / 5
        let hourDiff = Double((range.hour ?? 0)) / (5 * 24)
        let minDiff = Double((range.minute ?? 0)) / (5 * 24 * 60)
        let totalTimeDifference: Double = weekDiff + dayDiff + hourDiff + minDiff
        return totalTimeDifference
    }
}
