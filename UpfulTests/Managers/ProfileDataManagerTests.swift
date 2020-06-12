//
//  ProfileDataManagerTests.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 6/11/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
import CoreData
@testable import Upful

class ProfileDataManagerTests: XCTestCase {
    
    var sut: ProfileDataManager!
    let ledgerManager = LedgerManager(container: MockTransactionContainerManager.shared)
    let localTransactionLoader = LocalTransactionLedgerLoader(container: MockTransactionContainerManager.shared)
    
    override func setUpWithError() throws {
        sut = ProfileDataManager(ledgerLoader: localTransactionLoader)
    }

    func testFirstDateLoadWithEmpty() {
        let expectations = expectation(description: #function)
        
        sut.fetchFirstTransactionDate { result in
            switch result {
            case .success(let date):
                XCTAssertNil(date)
                expectations.fulfill()
            default:
                assertionFailure("Should not throw error")
            }
        }

        wait(for: [expectations], timeout: 1)
    }
    
    func testFirstDateLoadWithDateResult() {
        let expectations = expectation(description: #function)
                
        makeTransactions(firstTradeDateAsString: "2020-04-05 23:30:52 +0000") {
            self.sut.fetchFirstTransactionDate { result in
                switch result {
                case .success(let date):
                    XCTAssertEqual("\(date!)", "2020-04-05 23:30:52 +0000")
                    expectations.fulfill()
                default:
                    assertionFailure("Should not throw error")
                }
            }
        }
        clearDatabase()
        wait(for: [expectations], timeout: 1)
    }
    
    
    func testWeeksFromFirstTradeDateWithEmptyResult() {
        let expectations = expectation(description: #function)
                
        self.sut.weeksFromFirstTradeDate { weeks in
            XCTAssertEqual(weeks, 0)
            expectations.fulfill()
        }

        wait(for: [expectations], timeout: 1)
    }
    
    func testWeeksFromFirstTradeDateWithResult() {
        let expectations = expectation(description: #function)
    
        let now = Date()
        let earliestTradeDate = now.addingTimeInterval(-92214)

        makeTransactions(firstTradeDateAsString: "\(earliestTradeDate)") {
            self.sut.weeksFromFirstTradeDate { weeks in
                XCTAssertEqual(weeks!, 0.21333333333333335)
                expectations.fulfill()
            }
        }
        clearDatabase()
        wait(for: [expectations], timeout: 1)
    }
}

extension ProfileDataManagerTests {
    
    fileprivate func makeTransactions(firstTradeDateAsString: String, completion: @escaping (() -> Swift.Void)) {
        ledgerManager.save(TransactionAdapter(ticker: "AAPL", shares: 1, tradePrice: 100, transactionDate: firstTradeDateAsString), completion: { [unowned self] in
            self.ledgerManager.save(TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 100), completion: { [unowned self] in
                self.ledgerManager.save(TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 120), completion: { [unowned self] in
                    self.ledgerManager.save(TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 150), completion: completion)
                })
            })
        })
    }
    
    fileprivate func clearDatabase() {
        let fetchRequest = PersistedTransaction.fetchRequest()
    
        addTeardownBlock {
            let transactions = try! MockTransactionContainerManager.shared.persistentContainer.viewContext.fetch(fetchRequest)
            
            for transaction in transactions {
                guard let transaction = transaction as? NSManagedObject else {continue}
                MockTransactionContainerManager.shared.persistentContainer.viewContext.delete(transaction)
            }
        }
    }
}

