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

    // MARK: - Total Share Count
    
    func test_getTotalShareCount() {
        sut = makeSUTWithTwoBuys()
        
        XCTAssertEqual(sut.totalShareCount, 2)
    }
    
    func test_totalShareCount_withBuysAndASell() {
        sut = makeSUTWithTwoBuysAndSell()
        
        XCTAssertEqual(sut.totalShareCount, 1)
    }
    
    // MARK: - Average Price
    
    func test_calculateAveragePrice_withTwoBuys() {
        sut = makeSUTWithTwoBuys()
        
        XCTAssertEqual(sut.averagePrice, 1.5)
    }
    
    func test_calculateAveragePrice_withTwoBuysAndASell() {
        sut = makeSUTWithTwoBuysAndSell()
        
        XCTAssertEqual(sut.averagePrice, 1.5)
    }
    
    // MARK: - Price Movement
    
    func test_totalPriceMovementDollar() {
        sut = makeSUTWithTwoBuys()
        
        XCTAssertEqual(sut.totalPriceMovementDollar, 7)
    }
    
    func test_totalPriceMovement_withBuyUpdate() {
        sut = makeSUTWithTwoBuysAndUpdatedBuy()
        
        XCTAssertEqual(sut.totalPriceMovementDollar, 7)
    }
    
    func test_totalPriceMovement_withTwoBuysAndASell() {
        sut = makeSUTWithTwoBuysAndSell()
        
        XCTAssertEqual(sut.totalPriceMovementDollar, 3.5)
    }
    
    func test_totalPriceMovementPercent() {
        sut = makeSUTWithTwoBuys()
        
        XCTAssertEqual(sut.totalPriceMovementPercent, "466.67%")
    }
    
    // MARK: - Fileprivate Helper Methods
    
    fileprivate func makeSUTWithTwoBuysAndUpdatedBuy() -> Holding {
        let transactions = [
            TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 1, currentPrice: 2),
            TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 2, currentPrice: 2),
            TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 5, currentPrice: 5)
        ]
        for transaction in transactions {
            transaction.type = TransactionType.buy.rawValue
        }
        var holding = Holding(ticker: "FB", transactions: transactions)
        holding.currentPrice = 5
        
        return holding
    }
    
    fileprivate func makeSUTWithTwoBuys() -> Holding {
        let transactions = [
            TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 1, currentPrice: 2),
            TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 2, currentPrice: 2),
        ]
        for transaction in transactions {
            transaction.type = TransactionType.buy.rawValue
        }
        var holding = Holding(ticker: "FB", transactions: transactions)
        holding.currentPrice = 5
        
        return holding
    }
    
    fileprivate func makeSUTWithTwoBuysAndSell() -> Holding {
        var transactions = [
            TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 1, currentPrice: 2),
            TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 2, currentPrice: 2),
        ]
        for transaction in transactions {
            transaction.type = TransactionType.buy.rawValue
        }
        let transaction3 = TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 5, currentPrice: 5)
        transaction3.type = TransactionType.sell.rawValue
        transactions.append(transaction3)
        
        var holding = Holding(ticker: "FB", transactions: transactions)
        holding.currentPrice = 5
        
        return holding
    }
}
