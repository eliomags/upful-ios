//
//  HistoricPerformanceSaverTests.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 9/3/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class HistoricPerformanceMapperTests: XCTestCase {
    
    var sut: HistoricPerformanceMapper!
    
    override func setUp() {
        sut = HistoricPerformanceMapper()
        sut.performanceManager = MockPerformanceManager()
        sut.loadPrice = mockPriceLoader
    }
    
    // MARK: - Create Overall Performance Data Points
    
    func test1DayPerformanceLoad() {
        sut.loadTransactions = mockTransactionLoader
        let exp = expectation(description: #function)

        sut.loadHandler.subscribe { _ in
            let overallPerformance = self.sut.performanceManager.overallPerformance
            assert(overallPerformance.count == 2)
            // Check first day performance
            XCTAssertEqual(overallPerformance[0].cashBalance, 24991)
            XCTAssertEqual(overallPerformance[0].holdingBalance, 11)
            XCTAssertEqual(overallPerformance[0].totalEquity, 25002)
            
            // Check last day perforormance
            XCTAssertEqual(overallPerformance[1].cashBalance, 24996)
            XCTAssertEqual(overallPerformance[1].holdingBalance, 12)
            XCTAssertEqual(overallPerformance[1].totalEquity, 25008)
            
            exp.fulfill()
        }
        sut.createDayPerformanceDataPoints()
        
        wait(for: [exp], timeout: 1)
    }
    
    func test4DaysPerformanceLoad() {
        sut.loadTransactions = mockTransactionLoaderWith4DaysAnd6Transactions
        let exp = expectation(description: #function)
        
        sut.loadHandler.subscribe { _ in
            let overallPerformance = self.sut.performanceManager.overallPerformance
            assert(overallPerformance.count == 4)
            // Day 1
            XCTAssertEqual(overallPerformance[0].cashBalance, 24991)
            XCTAssertEqual(overallPerformance[0].holdingBalance, 11)
            // Day 2
            XCTAssertEqual(overallPerformance[1].cashBalance, 24991)
            XCTAssertEqual(overallPerformance[1].holdingBalance, 12)
            // Day 3
            XCTAssertEqual(overallPerformance[2].cashBalance, 24991)
            XCTAssertEqual(overallPerformance[2].holdingBalance, 11)
            // Day 4
            XCTAssertEqual(overallPerformance[3].cashBalance, 24981)
            XCTAssertEqual(overallPerformance[3].holdingBalance, 30)
            
            exp.fulfill()
        }
        sut.createDayPerformanceDataPoints()
        
        wait(for: [exp], timeout: 1)
    }
    
    // MARK: - Create Transaction Buckets
    
    func testCreateEmptyTransactionBuckets() {
        sut.loadTransactions = {
            return []
        }
        let transactionBuckets = sut.createTransactionBuckets()
        
        XCTAssertTrue(transactionBuckets.isEmpty)
    }
    
    func testCreateTransactionBuckets() {
        sut.loadTransactions = mockTransactionLoader
        
        let transactionBuckets = sut.createTransactionBuckets()
        let totalNumberOfTransactions = transactionBuckets.map{ $0.transactions.count }.reduce(0, +)

        XCTAssertEqual(transactionBuckets.count, 2)
        XCTAssertEqual(transactionBuckets.last!.holdings.last!.totalShareCount, 1)
        XCTAssertEqual(totalNumberOfTransactions, 5, "We know there are 5 total transactions since 5 were injected above.")
    }
    
    func testGetDayPerformanceBasedFromLastDate() {
        sut.loadTransactions = mockTransactionLoader
        
        let date = Date.buildDate(day: 2, month: 1, year: 2020)

        sut.performanceManager.save(holdingBalance: 11, cashBalance: 24991, date: date)
        let transactionBuckets = sut.createTransactionBuckets()
        let totalNumberOfTransactions = transactionBuckets.map{ $0.transactions.count }.reduce(0, +)

        XCTAssertEqual(transactionBuckets.count, 1)
        XCTAssertEqual(totalNumberOfTransactions, 2, "Only the transactions from the last day should be present.")
    }
    
    func testCreateTransactionBucketsWith2DaysInBetween() {
        sut.loadTransactions = mockTransactionLoaderWith4DaysAnd6Transactions
        
        let transactionBuckets = sut.createTransactionBuckets()
        let totalNumberOfTransactions = transactionBuckets.map{ $0.transactions.count }.reduce(0, +)
        
        XCTAssertEqual(transactionBuckets.count, 4, "we should have buckets for 2, 3, 4, 5")
        XCTAssertEqual(transactionBuckets[1].holdings.count, 1, "We should have one net holding on the second day")
        XCTAssertEqual(transactionBuckets.last!.holdings.count, 2, "We should have holdiings for TEST and FB in the last bucket.")
        XCTAssertEqual(totalNumberOfTransactions, 6, "We know there are 6 total transactions since 6 were injected above.")
    }
    
    func testGet4DayPerformanceBasedFromLastDate() {
        sut.loadTransactions = mockTransactionLoader
        let date = Date.buildDate(day: 5, month: 1, year: 2020)
        
        sut.performanceManager.save(holdingBalance: 11, cashBalance: 24991, date: date)
        let transactionBuckets = sut.createTransactionBuckets()
        
        XCTAssertTrue(transactionBuckets.isEmpty)
    }
    
    // MARK: - Helpers
    
   private class MockPerformanceManager: PerformanceSaver, PerformanceLoader {
        var overallPerformance: [DayPerformance] = []
        
        func load() -> DayPerformance? {
            return overallPerformance.last
        }
        
        func save(holdingBalance: Double, cashBalance: Double, date: Date) {
            let performance = DailyPerformance(holdingBalance: holdingBalance, cashBalance: cashBalance, date: date)
            overallPerformance.append(performance)
        }
    }
    
    struct MockDayPerformance: DayPerformance {
        var holdingBalance: Double
        var cashBalance: Double
        var date: Date
    }
    
    fileprivate func mockTransactionLoader() -> [Transaction] {
        let transactionDayOne: [Transaction] = [
            TransactionAdapter(ticker: "TEST", shares: 1, tradePrice: 10, transactionDate: "2020-01-02", type: "buy"),
            TransactionAdapter(ticker: "TEST", shares: 1, tradePrice: 11, transactionDate: "2020-01-02", type: "sell"),
            TransactionAdapter(ticker: "TEST", shares: 1, tradePrice: 10, transactionDate: "2020-01-02", type: "buy")
        ]
        let transactionDayTwo: [Transaction] = [
            TransactionAdapter(ticker: "TEST", shares: 1, tradePrice: 10, transactionDate: "2020-01-03", type: "buy"),
            TransactionAdapter(ticker: "TEST", shares: 1, tradePrice: 15, transactionDate: "2020-01-03", type: "sell")
        ]
        return transactionDayOne + transactionDayTwo
    }
    
    fileprivate func mockTransactionLoaderWith4DaysAnd6Transactions() -> [Transaction] {
        let transactionDayOne: [Transaction] = [
            TransactionAdapter(ticker: "TEST", shares: 1, tradePrice: 10, transactionDate: "2020-01-02", type: "buy"),
            TransactionAdapter(ticker: "TEST", shares: 1, tradePrice: 11, transactionDate: "2020-01-02", type: "sell"),
            TransactionAdapter(ticker: "TEST", shares: 1, tradePrice: 10, transactionDate: "2020-01-02", type: "buy")
        ]
        let transactionDayTwo: [Transaction] = [
            TransactionAdapter(ticker: "TEST", shares: 1, tradePrice: 10, transactionDate: "2020-01-05", type: "buy"),
            TransactionAdapter(ticker: "TEST", shares: 1, tradePrice: 15, transactionDate: "2020-01-05", type: "sell"),
            TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 15, transactionDate: "2020-01-05", type: "buy")
        ]
        return transactionDayOne + transactionDayTwo
    }

    fileprivate func mockPriceLoader(ticker: String, date: String, completion: @escaping (Result<Double,NetworkError>) -> Void) {
        let results: [String: [String: Double]] = [
            "TEST": ["20200102": 11, "20200103": 12, "20200104": 11, "20200105": 10],
            "FB": ["20200102": 11, "20200103": 12, "20200104": 11, "20200105": 20]
        ]
        let selectedValue = results[ticker]![date]!
        completion(.success(selectedValue))
    }
}
