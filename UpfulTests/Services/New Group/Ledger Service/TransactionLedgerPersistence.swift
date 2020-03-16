//
//  TransactionLedgerPersistence.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 3/15/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation
import XCTest
@testable import Upful

class TransactionLedgerPersistenceTests: XCTestCase {

    var ledgerPersistence: TransactionLedgerPersistence!
    var ledgerLoader: LocalTransactionLedgerLoader!
    
    override  func setUp() {
        super.setUp()
        makeSUT()
    }
    
    func testSaveAndFetchAllTransactions() {
        let transaction1 = Transaction(ticker: "FB", shares: 1, averagePrice: 1, currentPrice: 1)
        let transaction2 = Transaction(ticker: "AAPL", shares: 1, averagePrice: 1, currentPrice: 1)
        let loadExpectation = expectation(description: #function)
        
        ledgerPersistence.save(transaction1)
        ledgerPersistence.save(transaction2)
        
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
    
    func testSaveAndDeleteWithFetch() {
        // Save
        let transaction1 = Transaction(ticker: "FB", shares: 1, averagePrice: 1, currentPrice: 1)
        let transaction2 = Transaction(ticker: "AAPL", shares: 1, averagePrice: 1, currentPrice: 1)
        let loadExpectation = expectation(description: #function)
        loadExpectation.expectedFulfillmentCount = 2
        
        ledgerPersistence.save(transaction1)
        ledgerPersistence.save(transaction2)
            
        ledgerLoader.load { (result) in
            switch result {
            case .success(let savedTransactions):
                XCTAssertEqual(savedTransactions.count, 2)
                XCTAssertEqual(savedTransactions.map { $0.ticker }.sorted(), ["AAPL", "FB"])
            case .failure(let err):
                assertionFailure("Failed loading saved transactions\(#line), \(err.localizedDescription)")
            }
            loadExpectation.fulfill()
        }
    
        // Delete
        let transaction3 = Transaction(ticker: "AAPL", shares: 1, averagePrice: 1, currentPrice: 1)

        ledgerPersistence.delete(transaction3)
        ledgerLoader.load { (result) in
            switch result {
            case .success(let savedTransactions):
                XCTAssertEqual(savedTransactions.count, 1)
                XCTAssertEqual(savedTransactions.map { $0.ticker }, ["FB"])
            case .failure(let err):
                assertionFailure("Failed loading saved transactions\(#line), \(err.localizedDescription)")
            }
            loadExpectation.fulfill()
        }

        wait(for: [loadExpectation], timeout: 1)
    }
    
    func testLoadPrevious() {
        let transaction1 = Transaction(ticker: "FB", shares: 1, averagePrice: 1, currentPrice: 1)
        let transaction2 = Transaction(ticker: "AAPL", shares: 1, averagePrice: 1, currentPrice: 1)

        let loadExpectation = expectation(description: #function)
        
        ledgerPersistence.save(transaction1)
        ledgerPersistence.save(transaction2)

        let transaction3 = Transaction(ticker: "AAPL", shares: 1, averagePrice: 1, currentPrice: 1)
        ledgerLoader.loadPrevious(transaction: transaction3) { (result) in
            switch result {
            case .success(let savedTransaction):
                XCTAssertEqual(savedTransaction!.ticker , "AAPL")
            case .failure(let err):
                assertionFailure("Failed loading saved transactions\(#line), \(err.localizedDescription)")
            }
            loadExpectation.fulfill()
        }
        
        wait(for: [loadExpectation], timeout: 1)
    }
    
    // MARK: - Fileprivate Methods
    
    fileprivate func makeSUT() {
        ledgerPersistence = TransactionLedgerPersistence(container: MockTransactionLedgerContextManager.shared)
        ledgerLoader = LocalTransactionLedgerLoader(container: MockTransactionLedgerContextManager.shared)
    }
}

import CoreData

class MockTransactionLedgerContextManager: CoreDataModelContainerManager {
    static let shared = MockTransactionLedgerContextManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TransactionLedgerDataModel")
        let description = NSPersistentStoreDescription()
        
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("Failed to load persistent store: \(error.localizedDescription)")
            }
        })
        return container
    }()
    
    private init() {}
}
