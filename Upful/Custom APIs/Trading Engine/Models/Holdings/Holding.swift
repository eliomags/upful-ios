//
//  Holding.swift
//  Upful
//
//  Created by Yanik Simpson on 3/22/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

protocol StockViewable {
    var ticker: String { get }
}

class Holding {
    
    // MARK: - Dependencies
    
    var ticker: String
    private(set) var transactions: [Transaction]
    
    // MARK: - Properties
    
    var currentPrice: Double?

    // MARK: - Intiializer

    init(ticker: String, transactions: [Transaction]) {
        self.ticker = ticker
        self.transactions = transactions
    }
}

extension Holding {
    private var buys: [Transaction] {
        return transactions.filter { $0.type == TransactionType.buy.rawValue }
    }
    
    private var sells: [Transaction] {
        return transactions.filter { $0.type == TransactionType.sell.rawValue }
    }
    
    var totalShareCount: Int {
        let buyCount = buys.reduce(0) { (res, transaction) -> Int in
            return res + Int(transaction.numberOfShares)
        }
        let sellCount = sells.reduce(0) { (res, transaction) -> Int in
            return res + Int(transaction.numberOfShares)
        }
        return buyCount - sellCount
    }
    
    var currentTotalValue: Double {
        return (currentPrice ?? 0) * Double(totalShareCount)
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
    
    var totalPriceMovementDollar: Double {
        let sellMovement = sells.reduce(0) { (res, transaction) -> Double in
            return ((currentPrice ?? transaction.tradePrice) - averagePrice) *
                Double(transaction.numberOfShares) + res
        }
        
        let buyMovement =  buys.reduce(0) { (res, transaction) -> Double in
            return ((currentPrice ?? transaction.tradePrice) - transaction.tradePrice) *
                Double(transaction.numberOfShares) + res
        }
        return buyMovement - sellMovement
    }
    
    var totalPriceMovementPercent: String {
        return (Double(((totalPriceMovementDollar / Double(totalShareCount)) / averagePrice)) * 100).roundToTwoDecimal() + "%"
    }
}

extension Holding: StockViewable {}

extension Holding: Comparable {
    static func < (lhs: Holding, rhs: Holding) -> Bool {
        return lhs.currentTotalValue < rhs.currentTotalValue
    }
    
    static func == (lhs: Holding, rhs: Holding) -> Bool {
        return lhs.currentTotalValue == rhs.currentTotalValue
    }
}
