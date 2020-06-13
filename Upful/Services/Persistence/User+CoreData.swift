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
