//
//  PersistedPerformanceDataPoint+CoreDataClass.swift
//  Upful
//
//  Created by Yanik Simpson on 9/12/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//
//

import Foundation
import CoreData

@objc(PersistedPerformanceDataPoint)
public class PersistedPerformanceDataPoint: NSManagedObject {
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<PersistedPerformanceDataPoint> {
        return NSFetchRequest<PersistedPerformanceDataPoint>(entityName: "PersistedPerformanceDataPoint")
    }
    
    @NSManaged public var cashBalance: Double
    @NSManaged public var holdingBalance: Double
    @NSManaged public var date: Date
}


//extension PersistedPerformanceDataPoint: DayPerformance {}
