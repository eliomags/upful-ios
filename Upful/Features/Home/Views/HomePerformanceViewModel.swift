//
//  HomePerformanceViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 9/12/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

class HomePerformanceViewModel {
    enum Selection: String, CaseIterable {
        case week = "1W"
        case month = "1M"
        case threeMonths = "3M"
        case sixMonths = "6M"
        case ytd = "YTD"
        case year = "1Y"
        case all = "ALL"
        
        var days: Int {
            switch self {
            case .week:
                return 7
            case .month:
                return 30
            case .threeMonths:
                return 90
            case .sixMonths:
                return 180
            case .ytd:
                let now = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "DDD"
                let dayInYear = dateFormatter.string(from: now)
                return (Int(dayInYear) ?? 365) - 2
            case .year:
                return 365
            case .all:
                return Int.max
            }
        }
        
        var step: Int {
            switch self {
            case .week, .month:
                return 1
            case .threeMonths, .sixMonths:
                return 7
            case .ytd:
                return 14
            case .year:
                return 14
            case .all:
                return 14
            }
        }
    }
    
    // MARK: Properties
    
    var selectedIndex = 0 {
        didSet {
            fetchResultsForSelection()
        }
    }
    
    var getAllSelections: [String] {
        return Selection.allCases.map{ $0.rawValue}
    }
    
    var performanceValues: [DayPerformanceResponse] = [] {
        didSet {
            loadCompletionHandler?()
        }
    }
 
    // MARK: Handlers
    
    var loadCompletionHandler: (() -> Void)?
    
    
    /*
     [
         {
             "uuid":"x",
             "value_eod":123,
             "date":"12-31-1999",
             "holdings":[{"ticker":"x",
             "quantity":123,
             "eod_price":123}]
         },...
     ]
     */
    func fetchResultsForSelection() {
        let now = Date()
        let performances = (-400..<0).map({ val -> DayPerformanceResponse in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let date = now.addingTimeInterval(Double(val))
            let formattedDateString = dateFormatter.string(from: date)
            let randomValue = Double.random(in: (24000...25500))
            
            return DayPerformanceResponse(dateString: formattedDateString, value: randomValue)
        })
        
        let numberOfDaysNeeded = Selection.allCases[selectedIndex].days
        var lowerThreshold: Int = performances.count-1-numberOfDaysNeeded
        if lowerThreshold < 0 { lowerThreshold = 0 }
        
        performanceValues = stride(from: performances.count-1, through: 0, by: -7)
            .map({ (val) -> DayPerformanceResponse in
                return performances[val]
            })
//        performanceValues = Array(performances[lowerThreshold...(performances.count-1)])
        print(performanceValues.count)
    }
}

struct DayPerformanceResponse: Codable {
    let dateString: String
    let value: Double
}
