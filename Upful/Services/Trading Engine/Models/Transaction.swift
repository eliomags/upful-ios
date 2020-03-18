//
//  Transaction.swift
//  Upful
//
//  Created by Yanik Simpson on 3/15/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

class Transaction {
    var ticker: String
    var numberOfShares: Int32
    var averagePrice: Double
    var currentPrice: Double
    var type: String?
    var transactionDate: String?

    var change: Double {
        return ((currentPrice / averagePrice) - 1) * 100
    }

    init(ticker: String, shares: Int32, averagePrice: Double, currentPrice: Double) {
        self.ticker = ticker
        self.numberOfShares = shares
        self.averagePrice = averagePrice
        self.currentPrice = currentPrice
    }
    
    init(transaction: TransactionDataType) {
        self.ticker = transaction.ticker
        self.numberOfShares = transaction.numberOfShares
        self.averagePrice = transaction.averagePrice
        self.currentPrice = transaction.currentPrice
        self.type = transaction.type
    }
    
    init(stock: Stock, numberOfShares: Int32) {
       self.ticker = stock.ticker
       self.numberOfShares = numberOfShares
       self.averagePrice = stock.stockQuote?.latestPrice ?? 0
       self.currentPrice = stock.stockQuote?.latestPrice ?? 0
   }
}

extension Transaction: TransactionDataType {}
