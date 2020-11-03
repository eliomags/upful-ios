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
    }
    
    var selectedIndex = 0
    
    func getAllSelections() -> [String] {
        return Selection.allCases.map{ $0.rawValue}
    }
}
