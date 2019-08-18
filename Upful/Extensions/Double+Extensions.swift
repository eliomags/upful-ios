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
        var startValue = abs(self)
        startValue *= 100
        numFormatter.allowsFloats = true
        numFormatter.maximumFractionDigits = 2
        
        return numFormatter.string(from: NSNumber (value: startValue))!
    }
    
    func twoDecimal() -> String {
        let numFormatter = NumberFormatter()
        let startValue = abs(self)
        numFormatter.allowsFloats = true
        numFormatter.maximumFractionDigits = 1
        
        return numFormatter.string(from: NSNumber(value: startValue))!
    }
}
