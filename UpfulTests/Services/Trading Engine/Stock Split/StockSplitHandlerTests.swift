//
//  StockSplitHandlerTests.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 8/10/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class StockSplitHandlerTests: XCTestCase {

    var sut: StockSplitHandler!
    
    // MARK: - Initializer Test
    
    func test_init_withEmptyTransactions() {
        sut = StockSplitHandler(
            ticker: "AAPL",
            transactions: [TransactionAdapter(ticker: "FB")]
        )
        
        XCTAssertEqual(sut.ticker, "AAPL")
        XCTAssertTrue(sut.transactions.isEmpty)
    }
    
    func test_init_withResultTransactions() {
        sut = StockSplitHandler(
            ticker: "AAPL",
            transactions: [TransactionAdapter(ticker: "AAPL")]
        )
        
        XCTAssertEqual(sut.ticker, "AAPL")
        XCTAssertFalse(sut.transactions.isEmpty)
    }
    
    // MARK: - Check Needs Apply With Nil Last Applied Stock Split Use Case
    
    func test_checkIfTransactionsNeedsApply_nil_withTransactionDateBeforeEX() {
        let exDate = Date.buildDate(day: 10, month: 8, year: 2020)
        let transactionDate = Date.buildDate(day: 9, month: 8, year: 2020)
        
        let transaction = TransactionAdapter(ticker: "AAPL", transactionDate: "\(transactionDate)")
        sut = StockSplitHandler(ticker: "AAPL", transactions: [transaction])
        
        let needsApply = sut.checkIfTransactionsNeedsApply(exDate: exDate)
        
        XCTAssertTrue(needsApply)
    }
    
    func test_checkIfTransactionsNeedsApply_nil_withTransactionDateAfterEX() {
        let exDate = Date.buildDate(day: 8, month: 8, year: 2020)
        let transactionDate = Date.buildDate(day: 9, month: 8, year: 2020)
        
        let transaction = TransactionAdapter(ticker: "AAPL", transactionDate: "\(transactionDate)")
        sut = StockSplitHandler(ticker: "AAPL", transactions: [transaction])

        let needsApply = sut.checkIfTransactionsNeedsApply(exDate: exDate)
        
        XCTAssertFalse(needsApply)
    }
    
    // MARK: - Check Needs Apply With Valid Last Applied Stock Split Use Case
    
    func test_checkIfTransactionsNeedsApply_valid_withEXonLastAppliedDate() {
        let exDate = Date.buildDate(day: 8, month: 8, year: 2020)
        let transactionDate = Date.buildDate(day: 6, month: 8, year: 2020)
        let lastAppliedSplitDate = Date.buildDate(day: 8, month: 8, year: 2020)

        let transaction = TransactionAdapter(ticker: "AAPL", transactionDate: "\(transactionDate)")
        transaction.lastAppliedStockSplit = lastAppliedSplitDate
        sut = StockSplitHandler(ticker: "AAPL", transactions: [transaction])
        
        let needsApply = sut.checkIfTransactionsNeedsApply(exDate: exDate)
        
        XCTAssertFalse(needsApply)
    }
    
    func test_checkIfTransactionsNeedsApply_valid_withEXAfterLastApplied() {
        let exDate = Date.buildDate(day: 8, month: 8, year: 2020)
        let transactionDate = Date.buildDate(day: 6, month: 8, year: 2020)
        let lastAppliedSplitDate = Date.buildDate(day: 7, month: 8, year: 2020)
        
        let transaction = TransactionAdapter(ticker: "AAPL", transactionDate: "\(transactionDate)")
        transaction.lastAppliedStockSplit = lastAppliedSplitDate
        sut = StockSplitHandler(ticker: "AAPL", transactions: [transaction])
        
        let needsApply = sut.checkIfTransactionsNeedsApply(exDate: exDate)
        
        XCTAssertTrue(needsApply)
    }
    
    // MARK: - Get Latest Split Use Case
    
    func test_getLatestSplit_withEmptyResults() {
        let exp = expectation(description: #function)
        let transactionDate = Date.buildDate(day: 6, month: 8, year: 2020)
        let transaction = TransactionAdapter(ticker: "AAPL", transactionDate: "\(transactionDate)")
        sut = StockSplitHandler(ticker: "AAPL", transactions: [transaction])
        sut.fetchSplit = Self.emptyStockSplit
        
        sut.getLatestSplit { latestSplit in
            XCTAssertNil(latestSplit)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.5)
    }
    
    func test_getLatestSplit_withValidResults() {
        let exp = expectation(description: #function)
        let transactionDate = Date.buildDate(day: 6, month: 8, year: 2020)
        let transaction = TransactionAdapter(ticker: "AAPL", transactionDate: "\(transactionDate)")
        sut = StockSplitHandler(ticker: "AAPL", transactions: [transaction])
        sut.fetchSplit = Self.validStockSplit
        
        sut.getLatestSplit { latestSplit in
            let expectedDate = Date.buildDate(day: 1, month: 8, year: 2020)
            let isSameDayAsLatest = expectedDate
                .timeIntervalSince(latestSplit!.exDateAsDate) == 0
            XCTAssertTrue(isSameDayAsLatest)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.5)
    }
    
    // MARK: - Apply Stock Split Use Case
    
    func test_applyStockSplit_stocKSplit() {
        let stockSplit = StockSplit(toFactor: 7, fromFactor: 1, exDate: "2020-08-01")

        let transactionDate = Date.buildDate(day: 6, month: 8, year: 2020)
        let expectedLastAppliedDate = Date.buildDate(day: 1, month: 8, year: 2020)
        let transaction = TransactionAdapter(ticker: "AAPL", shares: 7, tradePrice: 7, transactionDate: "\(transactionDate)")
        
        sut = StockSplitHandler(ticker: "AAPL", transactions: [transaction])
        sut.apply(stockSplit)
        
        XCTAssertEqual(transaction.tradePrice, 1)
        XCTAssertEqual(transaction.numberOfShares, 49)
        XCTAssertTrue(transaction.lastAppliedStockSplit?
            .timeIntervalSince(expectedLastAppliedDate) == 0)
    }
    
    func test_applyStockSplit_reverseSplit() {
        let stockSplit = StockSplit(toFactor: 1, fromFactor: 10, exDate: "2020-08-01")

        let transactionDate = Date.buildDate(day: 6, month: 8, year: 2020)
        let expectedLastAppliedDate = Date.buildDate(day: 1, month: 8, year: 2020)
        let transaction = TransactionAdapter(ticker: "AAPL", shares: 10, tradePrice: 100, transactionDate: "\(transactionDate)")
        
        sut = StockSplitHandler(ticker: "AAPL", transactions: [transaction])
        sut.apply(stockSplit)
        
        XCTAssertEqual(transaction.tradePrice, 1000)
        XCTAssertEqual(transaction.numberOfShares, 1)
        XCTAssertTrue(transaction.lastAppliedStockSplit?
            .timeIntervalSince(expectedLastAppliedDate) == 0)
    }

    // MARK: - Helper
    
    fileprivate static func emptyStockSplit(ticker: String, completion:  @escaping (Result<[StockSplit], Error>) -> Void) {
        completion(.success([]))
    }
    
    fileprivate static func validStockSplit(ticker: String, completion:  @escaping (Result<[StockSplit], Error>) -> Void) {
        let split = StockSplit(toFactor: 7, fromFactor: 1, exDate: "2020-08-01")
        completion(.success([split]))
    }
    
    fileprivate static func multipleValidStockSplit(ticker: String, completion: @escaping (Result<[StockSplit], Error>) -> Void) {
        let splitOne = StockSplit(toFactor: 7, fromFactor: 1, exDate: "2020-02-01")
        let splitTwo = StockSplit(toFactor: 7, fromFactor: 1, exDate: "2020-02-01")
        let splitThree = StockSplit(toFactor: 7, fromFactor: 1, exDate: "2020-08-01")
        completion(.success([splitOne, splitTwo, splitThree]))
    }
}
