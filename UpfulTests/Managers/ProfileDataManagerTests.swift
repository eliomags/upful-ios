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
        let viewContext = MockTransactionContainerManager.shared.persistentContainer.viewContext
        sut = ProfileDataManager(
            ledgerLoader: localTransactionLoader,
            managedObjectContext: viewContext)
    }
    
    // MARK: Date Loading

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
        
        let dateString = "2020-04-05 23:30:52 +0000"
        let convertedDate = DateTransformer.convertStringToDate("2020-04-05 23:30:52 +0000")
                
        makeTransactions(firstTradeDateAsString: dateString) {
            
            self.sut.fetchFirstTransactionDate { result in
                switch result {
                case .success(let firstTransactionDate):
                    let isEqual = Calendar.current.isDate(
                        firstTransactionDate!,
                        equalTo: convertedDate,
                        toGranularity: .second
                    )
                    
                    XCTAssertTrue(isEqual)
                    expectations.fulfill()
                default:
                    assertionFailure("Should not throw error")
                }
            }
        }

        wait(for: [expectations], timeout: 1)
    }
    
    // MARK: Weeks From First Trade
    
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
        
        wait(for: [expectations], timeout: 1)
    }
    
    // MARK: User Creation
    
    func testUserCreation() {
        let expectations = expectation(description: #function)
        let date = Date()
        
        sut.createUser(firstTransactionDate: date) { user in
            XCTAssertNotNil(user)
            XCTAssertNotNil(user.id)
            XCTAssertEqual(user.firstTransactionDate, date)
            
            expectations.fulfill()
        }
        clearUser()
        
        wait(for: [expectations], timeout: 1)
    }
    
    func testUpdateUserFirstTradeDate() {
        let expectations = expectation(description: #function)
        
        let dateString = "2020-06-13 01:25:56 +0000"
        let convertedDate = DateTransformer.convertStringToDate("2020-06-13 01:25:56 +0000")
        
        makeTransactions(firstTradeDateAsString: dateString) {
            
            self.sut.createUser { _ in
                
                self.sut.updateUser { user in
                    let isEqual = Calendar.current.isDate(
                        user.firstTransactionDate!,
                        equalTo: convertedDate,
                        toGranularity: .second
                    )
                    
                    XCTAssertTrue(isEqual)
                    expectations.fulfill()
                }
            }
        }
        clearUser()
        
        wait(for: [expectations], timeout: 1)
    }
}

extension ProfileDataManagerTests {
    
    fileprivate func makeTransactions(firstTradeDateAsString: String, completion: @escaping (() -> Void)) {
        ledgerManager.save(TransactionAdapter(ticker: "AAPL", shares: 1, tradePrice: 100, transactionDate: firstTradeDateAsString), completion: { [unowned self] in
            
            self.ledgerManager.save(TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 100), completion: { [unowned self] in
                
                self.ledgerManager.save(TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 120), completion: { [unowned self] in
                    
                    self.ledgerManager.save(TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 150), completion: completion)
                })
            })
        })
        
        addTeardownBlock {
            let fetchRequest = PersistedTransaction.fetchRequest()
            let transactions = try! MockTransactionContainerManager.shared.persistentContainer.viewContext.fetch(fetchRequest)
            
            for transaction in transactions {
                guard let transaction = transaction as? NSManagedObject else { continue }
                MockTransactionContainerManager.shared.persistentContainer.viewContext.delete(transaction)
            }
        }
    }
    
    fileprivate func clearUser() {
        let viewContext = MockTransactionContainerManager.shared.persistentContainer.viewContext
        
        addTeardownBlock {
            let fetchRequest = User.createFetchRequest()
            let users = try! viewContext.fetch(fetchRequest)
            
            guard let user = users.first else { return }
            
            viewContext.performAndWait {
                viewContext.delete(user)
            }
        }
    }
}

