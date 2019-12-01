//
//  Date+Extensions.swift
//  Upful
//
//  Created by Yanik Simpson on 11/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

extension Date {
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var day: Int {
        return Calendar.current.component(.day,  from: self)
    }
    var year: Int {
        return Calendar.current.component(.year,  from: self)
    }
    var minute: Int {
        return Calendar.current.component(.minute,  from: self)
    }
}

extension DateComponents {
    func toString() -> String {
        return "\(self.month!)/\(self.day!)/\(self.year!)"
    }
}

