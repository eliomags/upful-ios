//
//  Holding.swift
//  Upful
//
//  Created by Yanik Simpson on 3/22/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

struct Holding {
    
    // MARK: - Dependencies
    
    let ticker: String
    private(set) var transactions: [Transaction]
    
    private var buys: [Transaction] {
        return transactions.filter { $0.type == TransactionType.buy.rawValue }
    }
    
    // MARK: - Properties
    
    var totalShareCount: Int {
        return buys.reduce(0) { (res, transaction) -> Int in
            return res + Int(transaction.numberOfShares)
        }
    }
    var averagePrice: Double {
        let totalShares = totalShareCount
        
        return buys.reduce(0) { (res, transaction) -> Double in
            let weight = Double(transaction.numberOfShares) / Double(totalShares)
            return res + (transaction.tradePrice * weight)
        }
    }
    
    // MARK: - Properties

    init(ticker: String, transactions: [Transaction]) {
        self.ticker = ticker
        self.transactions = transactions
    }
}
