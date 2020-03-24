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
        let previousTransaction = TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 1, currentPrice: 1)
        
        let newTransaction = TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 2, currentPrice: 2)
        sut.handleBuyWithUpdate(newTransaction, storedTransaction: previousTransaction)
        
        XCTAssertEqual(previousTransaction.numberOfShares, 1)
        XCTAssertEqual(previousTransaction.tradePrice, 1)
        XCTAssertEqual(previousTransaction.currentPrice, 2)
    }
    
    func testHandleBuy_withComplexUpdate() {
        let previousTransaction = TransactionAdapter(ticker: "FB", shares: 20, tradePrice: 20, currentPrice: 20)
        
        let newTransaction = TransactionAdapter(ticker: "FB", shares: 80, tradePrice: 120, currentPrice: 120)
        sut.handleBuyWithUpdate(newTransaction, storedTransaction: previousTransaction)
        
        XCTAssertEqual(previousTransaction.numberOfShares, 20)
        XCTAssertEqual(previousTransaction.tradePrice, 20)
        XCTAssertEqual(previousTransaction.currentPrice, 120)
    }

    // MARK: - Selling
    
    func testHandleSell_withSuccess() {
        let previousTransaction = TransactionAdapter(ticker: "FB", shares: 20, tradePrice: 20, currentPrice: 20)
        
        let newTransaction = TransactionAdapter(ticker: "FB", shares: 20, tradePrice: 120, currentPrice: 120)
        sut.handleSell(newTransaction, storedTransaction: previousTransaction)
        
        
        XCTAssertEqual(previousTransaction.numberOfShares, 20)
        XCTAssertEqual(previousTransaction.tradePrice, 20)
        XCTAssertEqual(previousTransaction.currentPrice, 120)
    }
    
    func testPriceUpdates() {
        let storedTransaction1 = TransactionAdapter(ticker: "FB", shares: 20, tradePrice: 20, currentPrice: 20)
        let storedTransaction2 = TransactionAdapter(ticker: "AAPL", shares: 20, tradePrice: 20, currentPrice: 20)
        
        let updatedTransaction1 = TransactionAdapter(ticker: "FB", shares: 20, tradePrice: 80, currentPrice: 80)
        let updatedTransaction2 = TransactionAdapter(ticker: "AAPL", shares: 20, tradePrice: 80, currentPrice: 80)
        sut.handlePriceUpdates(currentTransactions: [storedTransaction1, storedTransaction2],
                               updatedTransactions: [updatedTransaction1, updatedTransaction2])
        
        XCTAssertEqual(storedTransaction1.currentPrice, updatedTransaction1.currentPrice)
        XCTAssertEqual(storedTransaction2.currentPrice, updatedTransaction2.currentPrice)
    }
    
    func testGetTotalPriceChange() {
        let storedTransaction1 = TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 1, currentPrice: 21)
        // 20
        let storedTransaction2 = TransactionAdapter(ticker: "AAPL", shares: 2, tradePrice: 20, currentPrice: 10)
        // -20
        
        let total = sut.getTotalPriceChange(from: [storedTransaction1, storedTransaction2])
        
        XCTAssertEqual(total, 0)
    }
}
