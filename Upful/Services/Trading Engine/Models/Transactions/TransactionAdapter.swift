//
//  Transaction.swift
//  Upful
//
//  Created by Yanik Simpson on 3/15/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

class TransactionAdapter {
    var ticker: String
    var numberOfShares: Int32
    var tradePrice: Double
    var type: String?
    var transactionDate: String?
    var id: String
    
    init(ticker: String, shares: Int32, tradePrice: Double, transactionDate: String = "\(Date())") {
        self.ticker = ticker
        self.numberOfShares = shares
        self.tradePrice = tradePrice
        self.id = UUID().uuidString
        self.transactionDate = "\(Date())"
        self.transactionDate = transactionDate
    }
    
    init(transaction: Transaction) {
        self.ticker = transaction.ticker
        self.numberOfShares = transaction.numberOfShares
        self.tradePrice = transaction.tradePrice
        self.type = transaction.type
        self.transactionDate = transaction.transactionDate
        self.id = transaction.id
    }
}

extension TransactionAdapter: Transaction {}
