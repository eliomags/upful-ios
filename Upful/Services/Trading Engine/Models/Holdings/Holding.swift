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
    private var sells: [Transaction] {
        return transactions.filter { $0.type == TransactionType.sell.rawValue }
    }
    
    // MARK: - Properties
    
    var currentPrice: Double?
    var totalShareCount: Int {
        let buyCount = buys.reduce(0) { (res, transaction) -> Int in
            return res + Int(transaction.numberOfShares)
        }
        let sellCount = sells.reduce(0) { (res, transaction) -> Int in
            return res + Int(transaction.numberOfShares)
        }
        return buyCount - sellCount
    }
    var averagePrice: Double {
        let totalBuyShares = buys.reduce(0) { (res, transaction) -> Int in
            return res + Int(transaction.numberOfShares)
        }
        return buys.reduce(0) { (res, transaction) -> Double in
            let weight = Double(transaction.numberOfShares) / Double(totalBuyShares)
            return res + (transaction.tradePrice * weight)
        }
    }
    
    // MARK: - Properties

    init(ticker: String, transactions: [Transaction]) {
        self.ticker = ticker
        self.transactions = transactions
    }
}
