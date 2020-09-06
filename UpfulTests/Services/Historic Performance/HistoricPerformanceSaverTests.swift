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
    // MARK: - Loaders
    
    var loadTransactions: [Transaction] = []
    var priceLoaderForTickerAndDate: QuoteLoader?
    var loadPrice = StockPriceLoader().loadEndOfDayPriceOnDate
    
    /// Holds transactions for given date for processing.
    struct TransactionBucket {
        let date: Date
        var transactions: [Transaction]
        var holdings: [Holding] = []
    }
    
    var overallPerformance: [DayPerformance] = []
    
    // MARK: - Create Day Performance
    
    func getPerformances() {
        // pre-work) Create date buckets
        let transactionBuckets = createTransactionBuckets()
        
        for bucket in transactionBuckets {
//            let previousDayPerformance = previouslySavedPerformance
            
            // 1,2) get previosu day's transactions, get transactions for current date
            let previousDayCashBalance = overallPerformance.last?.cashBalance ?? BalanceConstants.initialCash
            let todaysTransactions = bucket.transactions
            
            // 3,4) group sells and buys, 5) Update cash balance
            let todaysCashChange = calculateNetCashChangeInDay(in: todaysTransactions)
            let newCashBalance = previousDayCashBalance + todaysCashChange
            
            // 6) Map end of day holdings from transactions
            let todaysHoldings = bucket.holdings
            
            // 7) Get end of day values for holdings
            let df = DateFormatter()
            df.dateFormat = "yyyyMMdd"
            var holdingBalance: Double = 0
            
            todaysHoldings.forEach { holding in
                let semaphore = DispatchSemaphore(value: 1)
                semaphore.signal()
                // TODO: Put Semaphore on Background Thread to prevent blocking the main thread

                loadPrice(holding.ticker, df.string(from: bucket.date), { result in
                    if let endOfDayPrice = try? result.get() {
                        holdingBalance += endOfDayPrice * Double(holding.totalShareCount)
                    }
                    // TODO: Properly Handle Failure
                    semaphore.wait()
                })
            }
                        
            // 8) Total Equity = Cash Balance + Holdings End of Day Value
            let performance = MockDayPerformance(holdingBalance: holdingBalance, cashBalance: newCashBalance, date: bucket.date)
            
            // 9) Save equity Balance
            overallPerformance.append(performance)
        }
    }
    
    // MARK: - Create Transaction Buckets
    
    func calculateNetCashChangeInDay(in transactions: [Transaction]) -> Double {
        var total: Double = 0
        for transaction in transactions {
            if transaction.type == TransactionType.buy.rawValue {
                total -= transaction.tradePrice
            }
            if transaction.type == TransactionType.sell.rawValue {
                total += transaction.tradePrice
            }
        }
        return total
    }
    
    // MARK: - Create Transaction Buckets
    
    func createTransactionBuckets() -> [TransactionBucket] {
        let historicTransactions = loadTransactions
        var buckets = [TransactionBucket]()
        
        var curr = 0
        while curr < historicTransactions.count {
            let currentTransaction = historicTransactions[curr]
            let currentTransactionDate = DateTransformer.convertStringToDate(currentTransaction.transactionDate!)
            var currentBucket = TransactionBucket(date: currentTransactionDate, transactions: [currentTransaction])
            createTransactionBuckets(&curr, historicTransactions, &currentBucket, &buckets)
        }
        createBucketsForDaysInBetween(&buckets)
        
        return buckets
    }
    
    fileprivate func createBucketsForDaysInBetween(_ buckets: inout [TransactionBucket]) {
        guard !buckets.isEmpty else { return }
        var bucketCopy: [TransactionBucket] = [buckets.first!]
        
        for i in 1..<buckets.count {
            let currentDate = buckets[i].date
            let dateBeforeCurrentDate = currentDate.dayBefore
            
            while !Calendar.current.isDate(dateBeforeCurrentDate, inSameDayAs: bucketCopy.last!.date) {
                let nextDay = bucketCopy.last!.date.nextDay
                var appendingBucket = TransactionBucket(date: nextDay, transactions: [])
                
                let transactionsTillNow = bucketCopy.flatMap{ $0.transactions }
                let holdings = HoldingMapper.mapActiveHoldings(transactionsTillNow)
                appendingBucket.holdings = holdings
                
                bucketCopy.append(appendingBucket)
            }
            
            bucketCopy.append(buckets[i])
        }
        
        buckets = bucketCopy
    }
    
    fileprivate func createTransactionBuckets(_ curr: inout Int,
                                              _ historicTransactions: [Transaction],
                                              _ currentBucket: inout HistoricPerformanceSaver.TransactionBucket,
                                              _ buckets: inout [HistoricPerformanceSaver.TransactionBucket]) {
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
        
        // Get all transactions up to this date to create holdings
        let transactionsTillNow = Array(historicTransactions[0...curr])
        let holdings = HoldingMapper.mapActiveHoldings(transactionsTillNow)
        currentBucket.holdings = holdings
        
        buckets.append(currentBucket)
        curr += 1
    }
}

class HistoricPerformanceSaverTests: XCTestCase {
    
    var sut: HistoricPerformanceSaver!
    
    override func setUp() {
        sut = HistoricPerformanceSaver()
    }
    
    // MARK: - Create Overall Performance
    
    func test1DayPerformanceLoad() {
        sut.loadTransactions = mockTransactionLoader()
        sut.loadPrice = mockPriceLoader
        
        sut.getPerformances()
        
        assert(sut.overallPerformance.count == 2)
        // Check first day performance
        XCTAssertEqual(sut.overallPerformance[0].cashBalance, 24991)
        XCTAssertEqual(sut.overallPerformance[0].holdingBalance, 11)
        XCTAssertEqual(sut.overallPerformance[0].totalEquity, 25002)
        
        // Check last day perforormance
        XCTAssertEqual(sut.overallPerformance[1].cashBalance, 24996)
        XCTAssertEqual(sut.overallPerformance[1].holdingBalance, 12)
        XCTAssertEqual(sut.overallPerformance[1].totalEquity, 25008)
    }
    
    func test4DaysPerformanceLoad() {
        sut.loadTransactions = mockTransactionLoaderWith4DaysAnd6Transactions()
        sut.loadPrice = mockPriceLoader

        sut.getPerformances()
        
        assert(sut.overallPerformance.count == 4)
        // Day 1
        XCTAssertEqual(sut.overallPerformance[0].cashBalance, 24991)
        XCTAssertEqual(sut.overallPerformance[0].holdingBalance, 11)
        // Day 2
        XCTAssertEqual(sut.overallPerformance[1].cashBalance, 24991)
        XCTAssertEqual(sut.overallPerformance[1].holdingBalance, 12)
        // Day 3
        XCTAssertEqual(sut.overallPerformance[2].cashBalance, 24991)
        XCTAssertEqual(sut.overallPerformance[2].holdingBalance, 11)
        // Day 4
        XCTAssertEqual(sut.overallPerformance[3].cashBalance, 24981)
        XCTAssertEqual(sut.overallPerformance[3].holdingBalance, 30)
    }
    
    // MARK: - Create Transaction Buckets
    
    func testCreateEmptyTransactionBuckets() {
        let transactionBuckets = sut.createTransactionBuckets()
        
        XCTAssertTrue(transactionBuckets.isEmpty)
    }
    
    func testCreateTransactionBuckets() {
        sut.loadTransactions = mockTransactionLoader()
        
        let transactionBuckets = sut.createTransactionBuckets()
        let totalNumberOfTransactions = transactionBuckets.map{ $0.transactions.count }.reduce(0, +)

        XCTAssertEqual(transactionBuckets.count, 2)
        XCTAssertEqual(transactionBuckets.last!.holdings.last!.totalShareCount, 1)
        XCTAssertEqual(totalNumberOfTransactions, 5, "We know there are 5 total transactions since 5 were injected above.")
    }
    
    func testCreateTransactionBucketsWith2DaysInBetween() {
        sut.loadTransactions = mockTransactionLoaderWith4DaysAnd6Transactions()
        
        let transactionBuckets = sut.createTransactionBuckets()
        let totalNumberOfTransactions = transactionBuckets.map{ $0.transactions.count }.reduce(0, +)
        
        XCTAssertEqual(transactionBuckets.count, 4, "we should have buckets for 2, 3, 4, 5")
        XCTAssertEqual(transactionBuckets[1].holdings.count, 1, "We should have one net holding on the second day")
        XCTAssertEqual(transactionBuckets.last!.holdings.count, 2, "We should have holdiings for TEST and FB in the last bucket.")
        XCTAssertEqual(totalNumberOfTransactions, 6, "We know there are 6 total transactions since 6 were injected above.")
    }
    
    // MARK: - Helpers
    
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
