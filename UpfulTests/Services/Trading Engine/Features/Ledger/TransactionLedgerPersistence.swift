//
//  TransactionLedgerPersistence.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 3/15/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class TransactionLedgerPersistenceTests: CoreDataUseCase {

    var ledgerPersistence: TransactionLedgerPersistence!
    var ledgerLoader: LocalTransactionLedgerLoader!
    
    override  func setUp() {
        super.setUp()
        makeSUT()
    }
    
    override func tearDown() {
        ledgerPersistence = nil
        ledgerLoader = nil
        super.tearDown()
    }
    
    func testSaveAndFetchAllTransactions() {
        let transaction1 = TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 1)
        let transaction2 = TransactionAdapter(ticker: "AAPL", shares: 1, tradePrice: 1)
        let loadExpectation = expectation(description: #function)
        
        ledgerPersistence.save(transaction1, completion: nil)
        ledgerPersistence.save(transaction2, completion: nil)
        
        ledgerLoader.load { (result) in
            switch result {
            case .success(let savedTransactions):
                XCTAssertEqual(savedTransactions.map { $0.ticker }.sorted(), ["AAPL", "FB"])
            case .failure(let err):
                assertionFailure("Failed loading saved transactions\(#line), \(err.localizedDescription)")
            }
            loadExpectation.fulfill()
        }
        
        wait(for: [loadExpectation], timeout: 1)
    }
    
    func testLoadPrevious() {
        let transaction1 = TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 1)
        let transaction2 = TransactionAdapter(ticker: "AAPL", shares: 1, tradePrice: 1)

        let loadExpectation = expectation(description: #function)
        
        ledgerPersistence.save(transaction1, completion: { [unowned self] in
            self.ledgerPersistence.save(transaction2, completion: { [unowned self] in
                self.ledgerLoader.load() { (result) in
                    switch result {
                    case .success(_):
                        break
//                        XCTAssertEqual(savedTransaction!.ticker , "AAPL")
//                        XCTAssertEqual(savedTransaction?.tradePrice, 1)
                    case .failure(let err):
                        assertionFailure("Failed loading saved transaction\(#line), \(err.localizedDescription)")
                    }
                    loadExpectation.fulfill()
                }
            })
        })
        
        wait(for: [loadExpectation], timeout: 1)
    }
    
    // MARK: - Fileprivate Methods
    
    fileprivate func makeSUT() {
        ledgerPersistence = TransactionLedgerPersistence(context: transactionViewContext)
        ledgerLoader = LocalTransactionLedgerLoader(context: transactionViewContext)
        
        addTeardownBlock {
            self.transactionViewContext.reset()
        }
    }
}
