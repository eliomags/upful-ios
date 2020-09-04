//
//  HistoricPerformanceSaverTests.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 9/3/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

    // MARK: - DayPerformance Protocol
protocol DayPerformance {
    var cashBalance: Double { get set }
    var holdingBalance: Double { get set }
    var date: Date { get set }
}
extension DayPerformance {
    var totalEquity: Double {
        return cashBalance + holdingBalance
    }
}

struct MockDayPerformance: DayPerformance {
    var holdingBalance: Double
    var cashBalance: Double
    var date: Date
}

// MARK: - System Under Test

final class HistoricPerformanceSaver {
    var previouslySavedPerformance: (() -> DayPerformance)?
        
    var loadTransactions: (() -> [Transaction])?
    var mapActiveHoldingsFromTransactions: (([Transaction]) -> [Holding])?
    
    /// Holds transactions for given date for processing.
    struct TransactionBucket {
        let date: Date
        var transactions: [Transaction]
    }
    
    func createTransactionBuckets() -> [TransactionBucket] {
        let historicTransactions = loadTransactions?() ?? []
        var buckets = [TransactionBucket]()
        
        var curr = 0
        while curr < historicTransactions.count {
            let currentTransaction = historicTransactions[curr]
            let currentTransactionDate = DateTransformer.convertStringToDate(currentTransaction.transactionDate!)
            var currentBucket = TransactionBucket(date: currentTransactionDate,
                                                  transactions: [currentTransaction])
            
            for y in curr+1..<historicTransactions.count {
                let nextTransaction = historicTransactions[y]
                let transactionDate = DateTransformer.convertStringToDate(nextTransaction.transactionDate!)
                
                if Calendar.current.isDate(transactionDate, inSameDayAs: currentBucket.date) {
                    currentBucket.transactions.append(nextTransaction)
                } else {
                    break
                }
                curr = y
            }
            buckets.append(currentBucket)
            curr += 1
        }
        
        return buckets
    }
    
    func calculate() {
        // pre-work) Create date buckets
        let transactionBuckets = createTransactionBuckets()
        
        for bucket in transactionBuckets {
            let previousDayPerformance = previouslySavedPerformance?()
            
            // 1,2) get previosu day's transactions, get transactions for current date
            let previousDayCashBalance = previousDayPerformance?.cashBalance ?? BalanceConstants.initialCash
            let todaysTransactions = bucket.transactions
            
            // 3,4) group sells and buys
            var todaysBuys: Double = 0
            var todaysSells: Double = 0
            for transaction in todaysTransactions {
                if transaction.type == TransactionType.buy.rawValue {
                    todaysBuys += transaction.tradePrice
                }
                if transaction.type == TransactionType.sell.rawValue {
                    todaysSells += transaction.tradePrice
                }
            }
            
            // 5) Update cash balance
            let todaysCashChange = todaysSells - todaysBuys
            
            // 6) Map end of day holdings from transactions
            let holdingsMapper = HoldingMapper()
            holdingsMapper.completionHandler = { holdings in
                
            }
            holdingsMapper.createHoldings(from: todaysTransactions)
        }

    }
}

class HistoricPerformanceSaverTests: XCTestCase {
    
    var sut: HistoricPerformanceSaver!
    
    override func setUp() {
        sut = HistoricPerformanceSaver()
    }
    
    // MARK: - Create Transaction Buckets
    
    func testCreateEmptyTransactionBuckets() {
        sut.loadTransactions = { return [] }
        
        let transactionBuckets = sut.createTransactionBuckets()
        
        XCTAssertTrue(transactionBuckets.isEmpty)
    }
    
    func testCreateTransactionBuckets() {
        sut.loadTransactions = {
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
        
        let transactionBuckets = sut.createTransactionBuckets()
        let totalNumberOfTransactions = transactionBuckets.map{ $0.transactions.count }.reduce(0, +)

        XCTAssertEqual(transactionBuckets.count, 2)
        XCTAssertEqual(totalNumberOfTransactions, 5, "We know there are 5 total transactions since 4 were injected above.")
    }
    
}
