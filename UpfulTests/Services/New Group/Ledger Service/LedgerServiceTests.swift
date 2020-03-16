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
        
    }
}
