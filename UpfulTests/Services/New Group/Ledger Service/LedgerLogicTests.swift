//
//  LedgerLogicTests.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 3/15/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class LedgerLogicTests: XCTestCase {
    
    var sut: LedgerLogic!
    
    override func setUp() {
        sut = LedgerLogic()
    }
    
    // MARK: - Buying
    
    func testHandleBuy_withSimpleUpdate() {
        let storedTransaction = Transaction(ticker: "FB", shares: 1, averagePrice: 1, currentPrice: 1)
        
        let newTransaction = Transaction(ticker: "FB", shares: 1, averagePrice: 2, currentPrice: 2)
        sut.handleBuyWithUpdate(newTransaction, storedTransaction: storedTransaction)
        
        XCTAssertEqual(storedTransaction.numberOfShares, 2)
        XCTAssertEqual(storedTransaction.averagePrice, 1.5)
        XCTAssertEqual(storedTransaction.currentPrice, 2)
    }
    
    func testHandleBuy_withComplexUpdate() {
        let storedTransaction = Transaction(ticker: "FB", shares: 20, averagePrice: 20, currentPrice: 20)
        
        let newTransaction = Transaction(ticker: "FB", shares: 80, averagePrice: 120, currentPrice: 120)
        sut.handleBuyWithUpdate(newTransaction, storedTransaction: storedTransaction)
        
        XCTAssertEqual(storedTransaction.numberOfShares, 100)
        XCTAssertEqual(storedTransaction.averagePrice, 100)
        XCTAssertEqual(storedTransaction.currentPrice, 120)
    }

    // MARK: - Selling
    
    func testHandleSell_withMoreSharesThanHaveError() {
        let storedTransaction = Transaction(ticker: "FB", shares: 20, averagePrice: 20, currentPrice: 20)
        
        let newTransaction = Transaction(ticker: "FB", shares: 21, averagePrice: 120, currentPrice: 120)
        
        XCTAssertThrowsError(try sut.handleSell(newTransaction, storedTransaction: storedTransaction))
    }
    
    func testHandleSell_withSuccess() {
        let storedTransaction = Transaction(ticker: "FB", shares: 20, averagePrice: 20, currentPrice: 20)
        
        let newTransaction = Transaction(ticker: "FB", shares: 20, averagePrice: 120, currentPrice: 120)
        try! sut.handleSell(newTransaction, storedTransaction: storedTransaction)
        
        XCTAssertEqual(storedTransaction.numberOfShares, 0)
    }
    
    func testPriceUpdates() {
        let storedTransaction1 = Transaction(ticker: "FB", shares: 20, averagePrice: 20, currentPrice: 20)
        let storedTransaction2 = Transaction(ticker: "AAPL", shares: 20, averagePrice: 20, currentPrice: 20)
        
        let updatedTransaction1 = Transaction(ticker: "FB", shares: 20, averagePrice: 80, currentPrice: 80)
        let updatedTransaction2 = Transaction(ticker: "AAPL", shares: 20, averagePrice: 80, currentPrice: 80)
        sut.handlePriceUpdates(currentTransactions: [storedTransaction1, storedTransaction2],
                               updatedTransactions: [updatedTransaction1, updatedTransaction2])
        
        XCTAssertEqual(storedTransaction1.currentPrice, updatedTransaction1.currentPrice)
        XCTAssertEqual(storedTransaction2.currentPrice, updatedTransaction2.currentPrice)
    }
    
    func testGetTotalPriceChange() {
        let storedTransaction1 = Transaction(ticker: "FB", shares: 1, averagePrice: 1, currentPrice: 21)
        // 20
        let storedTransaction2 = Transaction(ticker: "AAPL", shares: 2, averagePrice: 20, currentPrice: 10)
        // -20
        
        let total = sut.getTotalPriceChange(from: [storedTransaction1, storedTransaction2])
        
        XCTAssertEqual(total, 0)
    }
}
