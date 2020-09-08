//
//  PerformanceManager.swift
//  Upful
//
//  Created by Yanik Simpson on 9/7/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

protocol PerformanceSaver: class {
    func save(holdingBalance: Double, cashBalance: Double, date: Date)
}

protocol PerformanceLoader: class {
    func load() -> DayPerformance?
}

class PerformanceManager: PerformanceSaver, PerformanceLoader {
    var overallPerformance: [DayPerformance] = []
    
    func load() -> DayPerformance? {
        return overallPerformance.last
    }
    
    func save(holdingBalance: Double, cashBalance: Double, date: Date) {
        let performance = DailyPerformance(holdingBalance: holdingBalance, cashBalance: cashBalance, date: date)
        overallPerformance.append(performance)
    }
}
