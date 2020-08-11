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
        
        let needsApply = sut.checkIfTransactionsNeedsApply(transaction, exDate: exDate)
        
        XCTAssertTrue(needsApply)
    }
    
    func test_checkIfTransactionsNeedsApply_nil_withTransactionDateAfterEX() {
        let exDate = Date.buildDate(day: 8, month: 8, year: 2020)
        let transactionDate = Date.buildDate(day: 9, month: 8, year: 2020)
        
        let transaction = TransactionAdapter(ticker: "AAPL", transactionDate: "\(transactionDate)")
        sut = StockSplitHandler(ticker: "AAPL", transactions: [transaction])

        let needsApply = sut.checkIfTransactionsNeedsApply(transaction, exDate: exDate)
        
        XCTAssertFalse(needsApply)
    }
    
    // MARK: - Check Needs Apply With Valid Last Applied Stock Split Use Case
    
    func test_checkIfTransactionsNeedsApply_valid_withTransactionDateAfterEX() {
        let exDate = Date.buildDate(day: 8, month: 8, year: 2020)
        let transactionDate = Date.buildDate(day: 6, month: 8, year: 2020)
        let lastAppliedSplitDate = Date.buildDate(day: 8, month: 8, year: 2020)

        let transaction = TransactionAdapter(ticker: "AAPL", transactionDate: "\(transactionDate)")
        transaction.lastAppliedStockSplit = lastAppliedSplitDate
        sut = StockSplitHandler(ticker: "AAPL", transactions: [transaction])
        
        let needsApply = sut.checkIfTransactionsNeedsApply(transaction, exDate: exDate)
        
        XCTAssertFalse(needsApply)
    }
    
    // TODO: - Confirm transaction date formats across multiple devices
    
    // MARK: - Helper
    
    fileprivate static func emptyStockSplit(ticker: String, completion:  @escaping (Result<[StockSplitInfo], Error>) -> Void) {
        completion(.success([]))
    }
}
