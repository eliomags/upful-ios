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
            container: mockContainerManager
        )
        sut.syncProfile = nil
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
        let transaction = TransactionAdapter(ticker: "FB", shares: 10, tradePrice: 100)
        let loadExpectation = expectation(description: #function)
        
        sut.buy(transaction: transaction, completion: { _ in
            XCTAssertEqual(self.sut.balanceManager.totalEquityBalance, 25_000)
            XCTAssertEqual(self.sut.balanceManager.currentCashBalance, 24_000)
            XCTAssertEqual(transaction.type, "buy")
            loadExpectation.fulfill()
        })
        
        wait(for: [loadExpectation], timeout: 5)
    }
    
    // MARK: - Buy and Sell
    
    func test_buy_sell_transactionLoadersResults() {
         makeBuyAndSell(completion: nil)
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
                loadExpectation.fulfill()
            }
        })
        
        wait(for: [loadExpectation], timeout: 5)
    }
    
    func test_buy_sell_withBuyWithLoggerTransaction() {
        let loadExpectation = expectation(description: #function)

        makeBuyAndSell(completion: { [unowned self] in
            self.sut.loadLoggedTransactions { (result) in
                switch result {
                case .success(let storedTransactions):
                    XCTAssertEqual(storedTransactions.map { TransactionType(rawValue: $0.type!) }, [TransactionType.sell, .buy])
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
        let purchase = TransactionAdapter(ticker: "FB", shares: 10, tradePrice: 200)
        
        sut.validatePurchaseAttempt(purchase) { (isValid) in
            XCTAssertTrue(isValid)
        }
    }
    
    func test_validatePurchaseAttempt_withInvalidPurchase() {
        let purchase = TransactionAdapter(ticker: "FB", shares: 1000, tradePrice: 200)
        
        sut.validatePurchaseAttempt(purchase) { (isValid) in
            XCTAssertFalse(isValid)
        }
    }
    
    // MARK: - Fileprivate Helper Methods
    
    fileprivate func makeBuyAndSell(completion: (() -> Void)?) {
        let loadExpectation = expectation(description: #function)
        
        // given a buy then a sell transaction
        let buyTransaction = TransactionAdapter(ticker: "FB", shares: 10, tradePrice: 100)
        let sellTransaction = TransactionAdapter(ticker: "FB", shares: 10, tradePrice: 200)

        sut.buy(transaction: buyTransaction, completion: { _ in
            XCTAssertEqual(self.sut.balanceManager.totalEquityBalance, 25_000)
            XCTAssertEqual(self.sut.balanceManager.currentCashBalance, 24_000)

            self.sut.sell(transaction: sellTransaction, completion: {
                XCTAssertEqual(TransactionType(rawValue: sellTransaction.type!) , TransactionType.sell)
                XCTAssertEqual(self.sut.balanceManager.currentCashBalance, 26_000)
                            
                completion?()
                loadExpectation.fulfill()
            })
        })

        wait(for: [loadExpectation], timeout: 5)
    }
    
    fileprivate func makeSale(completion: (() -> Void)?) {
        let sellTransaction = TransactionAdapter(ticker: "FB", shares: 10, tradePrice: 200)

        sut.sell(transaction: sellTransaction, completion: {
            XCTAssertEqual(TransactionType(rawValue: sellTransaction.type!) , TransactionType.sell)
            XCTAssertEqual(self.sut.balanceManager.totalEquityBalance, 26_000)
            XCTAssertEqual(self.sut.balanceManager.currentCashBalance, 26_000)
                        
            completion?()
        })
    }
}
