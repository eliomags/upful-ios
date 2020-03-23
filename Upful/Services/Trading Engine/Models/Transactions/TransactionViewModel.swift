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
    var currentPrice: Double
    var type: String?
    var transactionDate: String?

    var valueChange: String {
        return "$" + ((currentPrice - tradePrice) * Double(numberOfShares)).roundToTwoDecimal()
    }
    var percentChange: String {
        return (((currentPrice / tradePrice) - 1) * 100).roundToTwoDecimal() + "%"
    }

    init(ticker: String, shares: Int32, tradePrice: Double, currentPrice: Double) {
        self.ticker = ticker
        self.numberOfShares = shares
        self.tradePrice = tradePrice
        self.currentPrice = currentPrice
    }
    
    init(transaction: Transaction) {
        self.ticker = transaction.ticker
        self.numberOfShares = transaction.numberOfShares
        self.tradePrice = transaction.tradePrice
        self.currentPrice = transaction.currentPrice
        self.type = transaction.type
    }
    
    init(stock: Stock, numberOfShares: Int32) {
       self.ticker = stock.ticker
       self.numberOfShares = numberOfShares
       self.tradePrice = stock.stockQuote?.latestPrice ?? 0
       self.currentPrice = stock.stockQuote?.latestPrice ?? 0
   }
}

extension TransactionViewModel: Transaction {}
