//
//  Double+Extensions.swift
//  Upful
//
//  Created by Yanik Simpson on 8/12/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation


extension Double {
    func convertToPercent() -> String {
        let numFormatter = NumberFormatter()
        var startValue = self
        startValue *= 100
        numFormatter.allowsFloats = true
        numFormatter.maximumFractionDigits = 2
        
        return numFormatter.string(from: NSNumber (value: startValue))!
    }
    
    func twoDecimal() -> String {
        let numFormatter = NumberFormatter()
        let startValue = self
        numFormatter.allowsFloats = true
        numFormatter.maximumFractionDigits = 2
        
        return numFormatter.string(from: NSNumber(value: startValue))!
    }
}

extension Double {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
