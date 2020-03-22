//
//  LoggingManagerTests.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 3/17/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class LoggingManagerTests: XCTestCase {
        
    var sut: TransactionLoggingManager!
    let mockContainerManager = MockTransactionContainerManager()

    // MARK: - Lifecycle
    
    override func setUp() {
        sut = TransactionLoggingManager(container: mockContainerManager)
    }
    
    // MARK: - Methods
    
    func test_load_withCompletionCall() {
        let loadExpectation = expectation(description: #function)
        sut.load { (_) in
            loadExpectation.fulfill()
        }
        
        wait(for: [loadExpectation], timeout: 1)
    }
    
    func test_load_withEmptyResult() {
        let loadExpectation = expectation(description: #function)
        sut.load { (result) in
            switch result {
            case .success(let storedLogs):
                XCTAssertTrue(storedLogs.isEmpty)
                
            case .failure(_):
                break
            }
            loadExpectation.fulfill()
        }
        
        wait(for: [loadExpectation], timeout: 1)
    }
    
    func test_log_withBuyAndSell() {
        let loadExpectation = expectation(description: #function)
        loadExpectation.expectedFulfillmentCount = 2
        
        let fbBuy = TransactionViewModel(ticker: "FB", shares: 1, tradePrice: 100, currentPrice: 100)
        let fbSell = TransactionViewModel(ticker: "FB", shares: 1, tradePrice: 200, currentPrice: 200)
        
        // Initial buys
        sut.log(fbBuy, of: .buy) { [unowned self] in
            self.sut.log(fbSell, of: .sell) { [unowned self] in
                self.sut.load { (result) in
                    switch result {
                    case .success(let storedLogs):
                        XCTAssertEqual(storedLogs.map { $0.currentPrice}, [200, 100])
                        XCTAssertEqual(storedLogs.map { $0.type! }, ["sell", "buy"])
                    case .failure(_):
                        break
                    }
                    loadExpectation.fulfill()
                    
        // Check if order is correct after another buy
                    let anotherFBbuy = TransactionViewModel(ticker: "FB", shares: 1, tradePrice: 150, currentPrice: 150)
                    self.sut.log(anotherFBbuy, of: .buy) { [unowned self] in
                        self.sut.load { (result) in
                            switch result {
                            case .success(let storedLogs):
                                print(storedLogs.map { $0.transactionDate! })
                                XCTAssertEqual(storedLogs.map { $0.currentPrice}, [150, 200, 100])
                                XCTAssertEqual(storedLogs.map { $0.type! }, ["buy", "sell", "buy"])
                            case .failure(_):
                                break
                            }
                            loadExpectation.fulfill()
                        }
                    }
                }
            }
        }
        
        wait(for: [loadExpectation], timeout: 1.5)
    }
}
