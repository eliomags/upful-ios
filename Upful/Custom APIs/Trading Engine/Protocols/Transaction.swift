//
//  TransactionDataType.swift
//  Upful
//
//  Created by Yanik Simpson on 3/15/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

protocol Transaction: class {
    var ticker: String { get set }
    var numberOfShares: Int32 { get set }
    var tradePrice: Double { get set }
    var type: String { get set }
    var transactionDate: String { get set }
    var id: String { get set }
    var lastAppliedStockSplit: Date? { get set }
}

extension Transaction {
    
    /// The transformed transactionDate as 'Date'.
    var transactionDateAsDate: Date {
        let transformedDate = DateTransformer.convertStringToDate(transactionDate)
        return transformedDate
    }
}
