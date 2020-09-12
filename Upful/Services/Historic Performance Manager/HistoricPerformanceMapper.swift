//
//  HistoricPerformanceManager.swift
//  Upful
//
//  Created by Yanik Simpson on 9/7/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

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

struct DailyPerformance: DayPerformance {
    var holdingBalance: Double
    var cashBalance: Double
    var date: Date
}

final class HistoricPerformanceMapper {
    typealias EndOfDayPriceLoader = (String, String, @escaping (Result<Double, NetworkError>) -> Void) -> ()
    typealias TransactionLoader = () -> [Transaction]
    
    // MARK: - Loaders
    
    var loadTransactions: TransactionLoader = LocalTransactionLedgerLoader().loadAllPersistedTransactions
    var loadPrice: EndOfDayPriceLoader = StockPriceLoader().loadEndOfDayPriceOnDate
    
    /// Holds transactions for given date for processing.
    struct TransactionBucket {
        let date: Date
        var transactions: [Transaction]
        var holdings: [Holding] = []
    }
        
    var performanceManager: PerformanceSaver & PerformanceLoader = PerformanceManager()
    
    // MARK: - Create Day Performance
    
    func createDayPerformanceDataPoints() {
        // pre-work) Create date buckets
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd"
        let transactionBuckets = createTransactionBuckets()
        
        for bucket in transactionBuckets {
            // 1) Contruct Cash Balance
            let lastPeformanceDataPoint = performanceManager.load()
            let previousDayCashBalance = lastPeformanceDataPoint?.cashBalance ?? BalanceConstants.initialCash
            let todaysTransactions = bucket.transactions
            let todaysCashChange = calculateNetCashChangeInDay(in: todaysTransactions)
            let newCashBalance = previousDayCashBalance + todaysCashChange
            
            // 2) Contruct holdings Balance
            let todaysHoldings = bucket.holdings
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
            performanceManager.save(holdingBalance: holdingBalance, cashBalance: newCashBalance, date: bucket.date)
        }
    }
    
    func createTransactionBuckets() -> [TransactionBucket] {
        let lastSavedPerformanceDataPoint = performanceManager.load()
        let historicTransactions = loadTransactions()
        var buckets = [TransactionBucket]()
        
        var curr = 0
        while curr < historicTransactions.count {
            let currentTransaction = historicTransactions[curr]
            let currentTransactionDate = DateTransformer.convertStringToDate(currentTransaction.transactionDate!)
            
            // Do not create bucket if date is on or before the last saved Data Point timestamp
            if let lastSavedPerformanceDataPoint = lastSavedPerformanceDataPoint {
                if currentTransactionDate <= lastSavedPerformanceDataPoint.date {
                    curr += 1
                    continue
                }
            }
            
            var currentBucket = TransactionBucket(date: currentTransactionDate, transactions: [currentTransaction])
            createTransactionBuckets(&curr, historicTransactions, &currentBucket, &buckets)
        }
        createBucketsForDaysInBetween(&buckets)
        
        return buckets
    }
    
    // MARK: - Helpers
    
    fileprivate func calculateNetCashChangeInDay(in transactions: [Transaction]) -> Double {
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
                                              _ currentBucket: inout HistoricPerformanceMapper.TransactionBucket,
                                              _ buckets: inout [HistoricPerformanceMapper.TransactionBucket]) {
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
