//
//  HoldingTests.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 3/23/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class HoldingTests: XCTestCase {

    var sut: Holding!

    func test_getTotalShareCount() {
        sut = makeSUTWithTwoBuys()
        
        XCTAssertEqual(sut.totalShareCount, 2)
    }
    
    func test_calculateAveragePrice_withTwoBuys() {
        sut = makeSUTWithTwoBuys()
        
        XCTAssertEqual(sut.averagePrice, 1.5)
    }
    
    
    func test_calculateAveragePrice_withTwoBuysAndASell() {
        sut = makeSUTWithTwoBuysAndSell()
        
        XCTAssertEqual(sut.averagePrice, 1.5)
    }
    
    // MARK: - Fileprivate Helper Methods
    
    fileprivate func makeSUTWithTwoBuys() -> Holding {
        let transactions = [
            TransactionViewModel(ticker: "FB", shares: 1, tradePrice: 1, currentPrice: 2),
            TransactionViewModel(ticker: "FB", shares: 1, tradePrice: 2, currentPrice: 2),
        ]
        for transaction in transactions {
            transaction.type = TransactionType.buy.rawValue
        }

        return Holding(ticker: "FB", transactions: transactions)
    }
    
    fileprivate func makeSUTWithTwoBuysAndSell() -> Holding {
        var transactions = [
            TransactionViewModel(ticker: "FB", shares: 1, tradePrice: 1, currentPrice: 2),
            TransactionViewModel(ticker: "FB", shares: 1, tradePrice: 2, currentPrice: 2),
        ]
        for transaction in transactions {
            transaction.type = TransactionType.buy.rawValue
        }
        let transaction3 = TransactionViewModel(ticker: "FB", shares: 1, tradePrice: 3, currentPrice: 3)
        transaction3.type = TransactionType.sell.rawValue
        transactions.append(transaction3)

        return Holding(ticker: "FB", transactions: transactions)
    }
}
