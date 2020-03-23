//
//  Transaction.swift
//  Upful
//
//  Created by Yanik Simpson on 3/15/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

class TransactionViewModel {
    var ticker: String
    var numberOfShares: Int32
    var tradePrice: Double
    var type: String?
    var transactionDate: String?
    var id: String
    
    init(ticker: String, shares: Int32, tradePrice: Double, currentPrice: Double) {
        self.ticker = ticker
        self.numberOfShares = shares
        self.tradePrice = tradePrice
        self.id = UUID().uuidString
    }
    
    init(transaction: Transaction) {
        self.ticker = transaction.ticker
        self.numberOfShares = transaction.numberOfShares
        self.tradePrice = transaction.tradePrice
        self.type = transaction.type
        self.transactionDate = transaction.transactionDate
        self.id = transaction.id
    }
    
    init(stock: Stock, numberOfShares: Int32) {
        self.ticker = stock.ticker
        self.numberOfShares = numberOfShares
        self.tradePrice = stock.stockQuote?.latestPrice ?? 0
        self.id = UUID().uuidString
   }
}

extension TransactionViewModel: Transaction {}
