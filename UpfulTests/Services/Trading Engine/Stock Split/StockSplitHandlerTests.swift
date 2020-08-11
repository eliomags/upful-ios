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
    
    func test_Init_withEmptyTransactions() {
        sut = StockSplitHandler(
            ticker: "AAPL", transactions: [TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 1)])
        
        XCTAssertEqual(sut.ticker, "AAPL")
        XCTAssertTrue(sut.transactions.isEmpty)
    }
    
    func test_Init_withResultTransactions() {
        sut = StockSplitHandler(
            ticker: "AAPL", transactions: [TransactionAdapter(ticker: "AAPL", shares: 1, tradePrice: 1)])
        
        XCTAssertEqual(sut.ticker, "AAPL")
        XCTAssertFalse(sut.transactions.isEmpty)
    }
    
    // MARK: - Helper
    
    fileprivate static func emptyStockSplit(ticker: String, completion:  @escaping (Result<[StockSplitInfo], Error>) -> Void) {
        completion(.success([]))
    }
}
