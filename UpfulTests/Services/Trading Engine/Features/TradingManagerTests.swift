//
//  TradingManagerTests.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 3/17/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class TradingEngineTests: XCTestCase {

    var sut: TradingEngine!
    let mockContainerManager = MockTransactionContainerManager()
    
    // MARK: - Lifecycle
    override func setUp() {
        sut = TradingEngine(
            balanceDefaults: UserDefaults(suiteName: "TestSuite")!,
            loggerContainer: mockContainerManager,
            ledgerContainer: mockContainerManager
        )
    }
    
    override func tearDown() {
        UserDefaults().removePersistentDomain(forName: "TestSuite")
    }

    // MARK: - Initial Load
    
    func test_loadLoggedTransactions_emptyOnInit() {
        let loadExpectation = expectation(description: #function)
        
        sut.loadLoggedTransactions { (result) in
            switch result {
            case .success(let loggedTransactions):
                XCTAssertTrue(loggedTransactions.isEmpty)
                
            case .failure(let err):
                assertionFailure("Failed loading logged transactions at \(#line), \(#file) \(err.localizedDescription)")
            }
            loadExpectation.fulfill()
        }
        
        wait(for: [loadExpectation], timeout: 1)
    }
    
    func test_loadLedgerTransactions_emptyOnInit() {
        let loadExpectation = expectation(description: #function)
        
        sut.loadLedgerTransactions { (result) in
            switch result {
            case .success(let loggedTransactions):
                XCTAssertTrue(loggedTransactions.isEmpty)
                
            case .failure(let err):
                assertionFailure("Failed loading ledger transactions at \(#line), \(#file) \(err.localizedDescription)")
            }
            loadExpectation.fulfill()
        }
        
        wait(for: [loadExpectation], timeout: 1)
    }
    
    // MARK: - Buy
    
    func test_buy_withInitialBuy() {
        let transaction = Transaction(ticker: "FB", shares: 10, averagePrice: 100, currentPrice: 100)
        let loadExpectation = expectation(description: #function)
        
        sut.handleBuyCompletion = { (equity, cash) in
            XCTAssertEqual(equity, 25_000)
            XCTAssertEqual(cash, 24_000)
            
            loadExpectation.fulfill()
        }
        sut.buy(transaction: transaction)
        
        wait(for: [loadExpectation], timeout: 1)
    }
    
    func test_buy_withBuyWithLedgerAndLogTransactionLoad() {
        let loadExpectation = expectation(description: #function)
        let buyTransaction = Transaction(ticker: "FB", shares: 10, averagePrice: 100, currentPrice: 100)
        loadExpectation.expectedFulfillmentCount = 3
        
        sut.handleBuyCompletion = { (equity, cash) in
            XCTAssertEqual(equity, 25_000)
            XCTAssertEqual(cash, 24_000)
            
            loadExpectation.fulfill()
            
            self.sut.loadLedgerTransactions { (result) in
                switch result {
                case .success(let ledgerTransactions):
                    XCTAssertEqual(ledgerTransactions.map { $0.ticker }, ["FB"])
                case .failure(_):
                    break
                }
                loadExpectation.fulfill()
            }
            
            self.sut.loadLoggedTransactions { (result) in
                switch result {
                case .success(let loggedTransactions):
                    XCTAssertEqual(loggedTransactions.map { $0.ticker }, ["FB"])
                    XCTAssertEqual(loggedTransactions.map { $0.type! }, ["buy"])
                case .failure(_):
                    break
                }
                loadExpectation.fulfill()
            }
        }
        sut.buy(transaction: buyTransaction)
        
        wait(for: [loadExpectation], timeout: 1.5)
    }
    
    func test_buy_sell_transactionLoadersResults() {
        let loadExpectation = expectation(description: #function)
        loadExpectation.expectedFulfillmentCount = 2
        
        // given a buy then a sell transaction
        let buyTransaction = Transaction(ticker: "FB", shares: 10, averagePrice: 100, currentPrice: 100)
        let sellTransaction = Transaction(ticker: "FB", shares: 10, averagePrice: 200, currentPrice: 200)
        
        /*
         After the buy transaction, to simulate the price of the stock being updated,
        */
        sut.handleBuyCompletion = { (equity, cash) in
            XCTAssertEqual(equity, 25_000)
            XCTAssertEqual(cash, 24_000)
            
            loadExpectation.fulfill()
            
            self.sut.update(with: [sellTransaction], completion: {
                self.sut.sell(transaction: sellTransaction)
            })
        }
        sut.handleSellCompletion = { (equity, cash) in
            XCTAssertEqual(equity, 26_000)
            XCTAssertEqual(cash, 26_000)
            
            loadExpectation.fulfill()
        }
        sut.buy(transaction: buyTransaction)
        
        wait(for: [loadExpectation], timeout: 1.5)
    }
        
    // MARK: - Validation
    
    func test_validatePurchaseAttempt_withValidPurchase() {
        let purchase = Transaction(ticker: "FB", shares: 10, averagePrice: 200, currentPrice: 200)
        
        sut.validatePurchaseAttempt(purchase) { (isValid) in
            XCTAssertTrue(isValid)
        }
    }
    
    func test_validatePurchaseAttempt_withInvalidPurchase() {
        let purchase = Transaction(ticker: "FB", shares: 1000, averagePrice: 200, currentPrice: 200)
        
        sut.validatePurchaseAttempt(purchase) { (isValid) in
            XCTAssertFalse(isValid)
        }
    }
}
