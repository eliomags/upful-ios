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
        let transaction = TransactionAdapter(ticker: "FB", shares: 10, tradePrice: 100, currentPrice: 100)
        let loadExpectation = expectation(description: #function)
        
        sut.handleBuyCompletion = { (equity, cash) in
            XCTAssertEqual(equity, 25_000)
            XCTAssertEqual(cash, 24_000)
            XCTAssertEqual(transaction.type, "buy")
            loadExpectation.fulfill()
        }
        sut.buy(transaction: transaction)
        
        wait(for: [loadExpectation], timeout: 1)
    }
    
    // MARK: - Buy and Sell
    
    func test_buy_sell_transactionLoadersResults() {
         makeBuyAndSell(completion: nil)
    }
    
    func test_buy_sell_currentPriceOfFirstPurchaseUpdated() {
        let loadExpectation = expectation(description: #function)
        
        makeBuyAndSell(completion: { [unowned self] in
            self.sut.loadLedgerTransactions { (result) in
                switch result {
                case .success(let storedTransactions):
                    XCTAssertEqual(storedTransactions.map { $0.currentPrice }, [200, 200])
                    loadExpectation.fulfill()
                case .failure(let err):
                    assertionFailure("Failed to load with on \(#line), \(#file), \(err.localizedDescription)")
                }
            }
        })
        
        wait(for: [loadExpectation], timeout: 1)
    }
    
    func test_buy_sell_withBuyWithLedgerTransaction() {
        let loadExpectation = expectation(description: #function)

        makeBuyAndSell(completion: { [unowned self] in
            self.sut.loadLedgerTransactions { (result) in
                switch result {
                case .success(let storedTransactions):
                    XCTAssertEqual(storedTransactions.map { TransactionType(rawValue: $0.type!)!.rawValue }.sorted(), [TransactionType.buy.rawValue, "sell"])
                case .failure(let err):
                    assertionFailure("Failed to load with on \(#line), \(#file), \(err.localizedDescription)")
                }
            }
            loadExpectation.fulfill()
        })
        
        wait(for: [loadExpectation], timeout: 1)
    }
    
    func test_buy_sell_withBuyWithLoggerTransaction() {
        let loadExpectation = expectation(description: #function)

        makeBuyAndSell(completion: { [unowned self] in
            self.sut.loadLoggedTransactions { (result) in
                switch result {
                case .success(let storedTransactions):
                    XCTAssertEqual(storedTransactions.map { TransactionType(rawValue: $0.type!) }, [TransactionType.buy, .buy])
                    loadExpectation.fulfill()
                case .failure(let err):
                    assertionFailure("Failed to load with on \(#line), \(#file), \(err.localizedDescription)")
                }
            }
        })
        
        wait(for: [loadExpectation], timeout: 1)
    }
        
    // MARK: - Validation
    
    func test_validatePurchaseAttempt_withValidPurchase() {
        let purchase = TransactionAdapter(ticker: "FB", shares: 10, tradePrice: 200, currentPrice: 200)
        
        sut.validatePurchaseAttempt(purchase) { (isValid) in
            XCTAssertTrue(isValid)
        }
    }
    
    func test_validatePurchaseAttempt_withInvalidPurchase() {
        let purchase = TransactionAdapter(ticker: "FB", shares: 1000, tradePrice: 200, currentPrice: 200)
        
        sut.validatePurchaseAttempt(purchase) { (isValid) in
            XCTAssertFalse(isValid)
        }
    }
    
    // MARK: - Fileprivate Helper Methods
    
    fileprivate func makeBuyAndSell(completion: (() -> Void)?) {
        let loadExpectation = expectation(description: #function)
        loadExpectation.expectedFulfillmentCount = 2
        
        // given a buy then a sell transaction
        let buyTransaction = TransactionAdapter(ticker: "FB", shares: 10, tradePrice: 100, currentPrice: 100)
        let sellTransaction = TransactionAdapter(ticker: "FB", shares: 10, tradePrice: 200, currentPrice: 200)
        
        sut.handleBuyCompletion = { [unowned self] (equity, cash) in
            XCTAssertEqual(equity, 25_000)
            XCTAssertEqual(cash, 24_000)
            
            self.sut.update(with: [sellTransaction], completion: {
                self.sut.sell(transaction: sellTransaction)
            })
            
            loadExpectation.fulfill()
        }
        sut.handleSellCompletion = { (equity, cash) in
            XCTAssertEqual(TransactionType(rawValue: buyTransaction.type!) , TransactionType.buy)
            XCTAssertEqual(TransactionType(rawValue: sellTransaction.type!) , TransactionType.sell)
            
            XCTAssertEqual(equity, 26_000)
            XCTAssertEqual(cash, 26_000)
            
            loadExpectation.fulfill()
            
            completion?()
        }
        sut.buy(transaction: buyTransaction)
        
        wait(for: [loadExpectation], timeout: 1.5)
    }
}
