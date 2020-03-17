//
//  LedgerService.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 3/16/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class LedgerServiceTests: XCTestCase {
    
    var sut: LedgerService!
    
    override func setUp() {
        let mockContainer = MockTransactionLedgerContextManager.shared
        sut = LedgerService(container: mockContainer)
    }

    // MARK: - Loading
    
    func testInitalLedgerLoad() {
        let initialLoadExpectation = expectation(description: #function)
        
        sut.loadSavedTransactions { (result) in
            switch result {
            case .success(let storedTransactions):
                XCTAssertTrue(storedTransactions.isEmpty)
            case .failure(let err):
                self.recordFailure(withDescription: "Failed loading saved transactions \(err.localizedDescription)", inFile: #file, atLine: #line, expected: true)
            }
            initialLoadExpectation.fulfill()
        }
        
        wait(for: [initialLoadExpectation], timeout: 1)
    }
    
    // MARK: - Buying
    
    func testHandleBuyWithNewTransaction() {
        let transaction = Transaction(ticker: "FB", shares: 1, averagePrice: 100, currentPrice: 100)
        let buyExpectation = expectation(description: #function)

        sut.handleBuy(transaction, completion: { [unowned self] in
            self.sut.loadSavedTransactions { (result) in
                switch result {
                case .success(let storedTransactions):
                    XCTAssertFalse(storedTransactions.isEmpty)
                    XCTAssertEqual(storedTransactions.map { $0.ticker }, ["FB"])
                    
                case .failure(let err):
                    self.recordFailure(withDescription: "Failed loading saved transactions \(err.localizedDescription)", inFile: #file, atLine: #line, expected: true)
                }
                buyExpectation.fulfill()
            }
        })
        
        wait(for: [buyExpectation], timeout: 1)
    }
    
    func testHandleBuyWithPreviousTransaction() {
        let buyExpectation = expectation(description: #function)
             
        makeManyBuys { [unowned self] in
            self.sut.loadSavedTransactions { (result) in
                switch result {
                case .success(let storedTransactions):
                    if let fb = storedTransactions.first(where: { $0.ticker == "FB"}) {
                        XCTAssertEqual(Int(fb.averagePrice), 123)
                        XCTAssertEqual(fb.currentPrice, 150)
                        XCTAssertEqual(fb.numberOfShares, 3)
                    } else {
                        self.recordFailure(withDescription: "No stored transaction found with ticker", inFile: #file, atLine: #line, expected: true)
                    }
                case .failure(let err):
                    self.recordFailure(withDescription: "Failed loading saved transactions \(err.localizedDescription)", inFile: #file, atLine: #line, expected: true)
                }
                buyExpectation.fulfill()
            }
        }
        
        wait(for: [buyExpectation], timeout: 1)
    }
    
    // MARK: - Selling
    
    func testHandleSellWhenNumberOfSharesEqualZero() {
        let sellExpectation = expectation(description: #function)
        let fbTransaction = Transaction(ticker: "FB", shares: 3, averagePrice: 200, currentPrice: 200)
        
        makeManyBuys(completion: { [unowned self] in
            try! self.sut.handleSell(fbTransaction, completion: { [unowned self] in
                self.sut.loadSavedTransactions { (result) in
                    switch result {
                    case .success(let storedTransactions):
                        XCTAssertEqual(storedTransactions.map { $0.ticker }, ["AAPL"])
                        XCTAssertEqual(storedTransactions.map { $0.averagePrice }, [100])
                        XCTAssertEqual(storedTransactions.map { $0.numberOfShares }, [1])
                    case .failure(let err):
                        self.recordFailure(withDescription: "Failed loading saved transactions \(err.localizedDescription)", inFile: #file, atLine: #line, expected: true)
                    }
                    sellExpectation.fulfill()
                }
            })
        })
        
        wait(for: [sellExpectation], timeout: 1)
    }
    
    func testHandleSellWhenNumberOfSharesNotZero() {
        let sellExpectation = expectation(description: #function)
        let fbTransaction = Transaction(ticker: "FB", shares: 2, averagePrice: 200, currentPrice: 200)
        
        makeManyBuys(completion: { [unowned self] in
            try! self.sut.handleSell(fbTransaction, completion: { [unowned self] in
                self.sut.loadSavedTransactions { (result) in
                    switch result {
                    case .success(let storedTransactions):
                        XCTAssertEqual(storedTransactions.map { $0.currentPrice }.sorted(), [100, 200])
                        XCTAssertEqual(storedTransactions.map { $0.numberOfShares }, [1,1])
                    case .failure(let err):
                        self.recordFailure(withDescription: "Failed loading saved transactions \(err.localizedDescription)", inFile: #file, atLine: #line, expected: true)
                    }
                    sellExpectation.fulfill()
                }
            })
        })
        
        wait(for: [sellExpectation], timeout: 1)
    }
    
    
    // MARK: - Fileprivate Methods
    
    fileprivate func makeManyBuys(completion: @escaping (() -> Void)) {
        sut.handleBuy(Transaction(ticker: "AAPL", shares: 1, averagePrice: 100, currentPrice: 100), completion: { [unowned self] in
        self.sut.handleBuy(Transaction(ticker: "FB", shares: 1, averagePrice: 100, currentPrice: 100), completion: { [unowned self] in
            self.sut.handleBuy(Transaction(ticker: "FB", shares: 1, averagePrice: 120, currentPrice: 120), completion: { [unowned self] in
                self.sut.handleBuy(Transaction(ticker: "FB", shares: 1, averagePrice: 150, currentPrice: 150), completion: completion)
                })
            })
        })
    }
}
