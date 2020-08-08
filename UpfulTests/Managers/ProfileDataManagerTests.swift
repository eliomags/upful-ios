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
    
    func test_generateProfileID_alwaysReturnsSameID() {
        let firstGeneratedID = sut.generateProfileID()
        let secondGeneratedID = sut.generateProfileID()
        
        XCTAssertEqual(firstGeneratedID, secondGeneratedID)
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
    
    func test_User_weeksFromFirstTransactionDate() {
        let expectations = expectation(description: #function)
        
        let weekAndAHalfInSeconds = 604800 * 1.5
        let firstTransactionDate = Date().addingTimeInterval(-weekAndAHalfInSeconds)
        
        sut.createUser(firstTransactionDate: firstTransactionDate) { user in
            XCTAssertEqual(user.weeksSinceFirstTrade, 1.7000000000000002)
            
            expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 1)
    }
    
    // MARK: - User
    
    // MARK: Read
    
    func testReadUserWithNoneSaved() {
        let currentUser = sut.readUser()
        
        XCTAssertNil(currentUser)
    }
    
    func testReadUserWithCurrentUserSaved() {
        let expectations = expectation(description: #function)

        sut.createUser { _ in
            let currentUser = self.sut.readUser()
            XCTAssertNotNil(currentUser?.id)
            XCTAssertNil(currentUser?.firstTransactionDate)
            
            expectations.fulfill()
        }
        clearUser()
        
        wait(for: [expectations], timeout: 1)
    }
    
    // MARK: Creation
    
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
    
    func testUserCreationMultipleCall() {
        let expectations = expectation(description: #function)
        expectations.expectedFulfillmentCount = 2
        let date = Date()
        
        sut.createUser(firstTransactionDate: date) { user in
            expectations.fulfill()

            self.sut.createUser { (user2) in
                XCTAssertEqual(user.id, user2.id)
                XCTAssertEqual(user.firstTransactionDate, user2.firstTransactionDate)
                
                expectations.fulfill()
            }
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
    
    // MARK: - Score Calculation
    
    func testUserScoreCalculationWithNewUser() {
        let expectations = expectation(description: #function)
        
        sut.calculateUserScore(percentPerformance: 25) { score in
            XCTAssertNil(score)
            expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 1)
    }

    func test_userScoreCalculation_with_noFirstTransaction() {
        let expectations = expectation(description: #function)
        
        sut.createUser { [weak self] _ in
            
            self?.sut.calculateUserScore(percentPerformance: 15) { score in
                XCTAssertNil(score)
                expectations.fulfill()
            }
        }
        clearUser()
        
        wait(for: [expectations], timeout: 2)
    }
    
    func test_userScoreCalculation_with_weeksSinceFirstTradeGreaterThanZero() {
        let expectations = expectation(description: #function)
        
        let oneWeekInSeconds: Double = 604800
        let date = Date().addingTimeInterval(-oneWeekInSeconds)
        let dateString = "\(date)"
        
        makeTransactions(firstTradeDateAsString: dateString) { [weak self] in
            self?.sut.calculateUserScore(percentPerformance: 15) { score in
                XCTAssertEqual(score, 3.2218487496163563)
                expectations.fulfill()
            }
        }
        clearUser()
        
        wait(for: [expectations], timeout: 1)
    }
    
    func test_userScoreCalculation_with_weeksSinceFirstNegativePerformance() {
        let expectations = expectation(description: #function)
        
        let oneWeekInSeconds: Double = 604800
        let date = Date().addingTimeInterval(-oneWeekInSeconds)
        let dateString = "\(date)"
        
        makeTransactions(firstTradeDateAsString: dateString) { [weak self] in
            self?.sut.calculateUserScore(percentPerformance: -15) { score in
                XCTAssertEqual(score, -3.2218487496163563)
                expectations.fulfill()
            }
        }
        clearUser()
        
        wait(for: [expectations], timeout: 1)
    }
    
    func test_userScoreCalculation_with_weeksSinceFirstZeroPercentPerformance() {
        let expectations = expectation(description: #function)
        
        let oneWeekInSeconds: Double = 604800
        let date = Date().addingTimeInterval(-oneWeekInSeconds)
        let dateString = "\(date)"
        
        makeTransactions(firstTradeDateAsString: dateString) { [weak self] in
            self?.sut.calculateUserScore(percentPerformance: 0) { score in
                XCTAssertEqual(score, -0.5)
                expectations.fulfill()
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

