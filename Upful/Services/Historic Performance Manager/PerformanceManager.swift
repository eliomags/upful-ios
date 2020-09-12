//
//  PerformanceManager.swift
//  Upful
//
//  Created by Yanik Simpson on 9/7/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation
import CoreData

protocol PerformanceSaver {
    func save(holdingBalance: Double, cashBalance: Double, date: Date)
}

protocol PerformanceLoader {
    var overallPerformance: [DayPerformance] { get set }
    func load() -> DayPerformance?
}

class PerformanceManager: PerformanceSaver, PerformanceLoader {
    var overallPerformance: [DayPerformance] = []
    
    let managedObjectContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
    }
    
    func load() -> DayPerformance? {
        return overallPerformance.last
    }
    
    func save(holdingBalance: Double, cashBalance: Double, date: Date) {
        let performance = DailyPerformance(holdingBalance: holdingBalance, cashBalance: cashBalance, date: date)
        overallPerformance.append(performance)
    }
}
