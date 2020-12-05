//
//  StockSplit.swift
//  Upful
//
//  Created by Yanik Simpson on 8/15/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

struct StockSplit: Decodable {
    let toFactor: Int
    let fromFactor: Int
    let exDate: String
}

extension StockSplit {
    var exDateAsDate: Date {
        return DateTransformer.convertStringToDate(exDate)
    }
    
    var ratio: Float {
        return Float(toFactor)/Float(fromFactor)
    }
}
