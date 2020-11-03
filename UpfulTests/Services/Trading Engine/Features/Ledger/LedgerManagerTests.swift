//
//  LedgerService.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 3/16/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class LedgerManagerTests: CoreDataUseCase {
    
    var sut: LedgerManager!

    override func setUp() {
        sut = LedgerManager(context: transactionViewContext)
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
//        let transaction = TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 100)
//        let buyExpectation = expectation(description: #function)

//        sut.handleBuy(transaction, completion: { [unowned self] in
//            self.sut.loadSavedTransactions { (result) in
//                switch result {
//                case .success(let storedTransactions):
//                    XCTAssertFalse(storedTransactions.isEmpty)
//                    XCTAssertEqual(storedTransactions.map { $0.ticker }, ["FB"])
//                case .failure(let err):
//                    self.recordFailure(withDescription: "Failed loading saved transactions \(err.localizedDescription)", inFile: #file, atLine: #line, expected: true)
//                }
//                buyExpectation.fulfill()
//            }
//        })
//
//        wait(for: [buyExpectation], timeout: 1)
    }
    
//    func testHandleBuyWithPreviousTransaction() {
//        let buyExpectation = expectation(description: #function)
//
//        makeFourBuys { [unowned self] in
//            self.sut.loadSavedTransactions { (result) in
//                switch result {
//                case .success(let storedTransactions):
//                    XCTAssertEqual(storedTransactions.count, 4)
//                    storedTransactions.forEach { (storedTransaction) in
//                        if storedTransaction.ticker == "FB" {
//                            XCTAssertEqual(storedTransaction.currentPrice, 150)
//                        }
//                    }
//
//                case .failure(let err):
//                    self.recordFailure(withDescription: "Failed loading saved transactions \(err.localizedDescription)",
//                        inFile: #file, atLine: #line, expected: true)
//                }
//                buyExpectation.fulfill()
//            }
//        }
//
//        wait(for: [buyExpectation], timeout: 1)
//    }
//
//    // MARK: - Selling
//
//    func testHandleSellWhenNumberOfSharesEqualZero() {
//        let sellExpectation = expectation(description: #function)
//        let fbTransaction = TransactionViewModel(ticker: "FB", shares: 3, tradePrice: 200, currentPrice: 200)
//
//        makeFourBuys(completion: { [unowned self] in
//            try! self.sut.handleSell(fbTransaction, completion: { [unowned self] in
//                self.sut.loadSavedTransactions { (result) in
//                    switch result {
//                    case .success(let storedTransactions):
//                        XCTAssertEqual(storedTransactions.count, 5)
//
//                    case .failure(let err):
//                        self.recordFailure(withDescription: "Failed loading saved transactions \(err.localizedDescription)",
//                            inFile: #file, atLine: #line, expected: true)
//                    }
//                    sellExpectation.fulfill()
//                }
//            })
//        })
//
//        wait(for: [sellExpectation], timeout: 1)
//    }
    // MARK: - Price Updates
    
    
    
    // MARK: - Fileprivate Methods
    
    fileprivate func makeFourBuys(completion: @escaping (() -> Void)) {
        sut.save(TransactionAdapter(ticker: "AAPL", shares: 1, tradePrice: 100), completion: { [unowned self] in
            self.sut.save(TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 100), completion: { [unowned self] in
                self.sut.save(TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 120), completion: { [unowned self] in
                    self.sut.save(TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 150), completion: completion)
                })
            })
        })
    }
}

