//
//  Transaction+CoreDataProperties.swift
//  
//
//  Created by Yanik Simpson on 3/15/20.
//
//

import Foundation
import CoreData

@objc(PersistedTransaction)
class PersistedTransaction: NSManagedObject {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<PersistedTransaction> {
        return NSFetchRequest<PersistedTransaction>(entityName: "PersistedTransaction")
    }

    @NSManaged public var ticker: String
    @NSManaged public var numberOfShares: Int32
    @NSManaged public var tradePrice: Double
    @NSManaged public var currentPrice: Double
    @NSManaged public var type: String?
    @NSManaged public var transactionDate: String?
    @NSManaged public var id: String
    @NSManaged public var lastAppliedStockSplit: Date?
}
extension PersistedTransaction: Transaction {}


@objc(LoggedTransaction)
class LoggedTransaction: NSManagedObject {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<LoggedTransaction> {
        return NSFetchRequest<LoggedTransaction>(entityName: "LoggedTransaction")
    }

    @NSManaged public var ticker: String
    @NSManaged public var numberOfShares: Int32
    @NSManaged public var tradePrice: Double
    @NSManaged public var currentPrice: Double
    @NSManaged public var type: String?
    @NSManaged public var transactionDate: String?
    @NSManaged public var id: String
    @NSManaged public var lastAppliedStockSplit: Date?

}
extension LoggedTransaction: Transaction {}
