//
//  Date+Extensions.swift
//  Upful
//
//  Created by Yanik Simpson on 11/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

extension Date {
    static var yesterday: Date { return Date().dayBefore }

    func getPreviousDate(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -days, to: self)!
    }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var day: Int {
        return Calendar.current.component(.day,  from: self)
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var year: Int {
        return Calendar.current.component(.year,  from: self)
    }
    var minute: Int {
        return Calendar.current.component(.minute,  from: self)
    }
    
    static func buildDate(day: Int, month: Int, year: Int) -> Date {
        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year
        return Calendar.current.date(from: components)!
    }
}

extension Date {
    var isToday: Bool {
        let currentDate = Date()
        let day = currentDate.day
        let month = currentDate.month
        let year = currentDate.year
        
        return self.day == day && self.month == month && self.year == year        
    }
}

extension DateComponents {
    func toString() -> String {
        return "\(self.month!)/\(self.day!)/\(self.year!)"
    }
}

