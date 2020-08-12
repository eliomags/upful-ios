//
//  StockSplitHandler.swift
//  Upful
//
//  Created by Yanik Simpson on 8/10/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

struct StockSplitInfo: Decodable {
    let ratio: Float
    let exDate: String
}

final class StockSplitHandler {
    
    let ticker: String
    private(set) var transactions: [Transaction]
    
    var fetchSplit: (((String), @escaping (Result<[StockSplitInfo], Error>) -> Void) -> Void)?
    
    // MARK: - Initializer
    
    init(ticker: String, transactions: [Transaction]) {
        self.ticker = ticker
        self.transactions = transactions.filter{ $0.ticker == ticker }
    }
    
    // MARK: - Methods
    
    func checkIfTransactionsNeedsApply(_ transaction: Transaction, exDate: Date) -> Bool {
        let transactionDate = DateTransformer.convertStringToDate(transaction.transactionDate!)
        
        let isEXDateAfterTransactionDate = exDate.timeIntervalSince(transactionDate) > 0
        let isEXDateAfterLastAppliedStockSplitDate =
            exDate.timeIntervalSince(transaction.lastAppliedStockSplit ?? Date.distantPast) > 0
        
        return isEXDateAfterTransactionDate && isEXDateAfterLastAppliedStockSplitDate
    }
    
    func getLatestSplit(_ completion: @escaping (StockSplitInfo?) -> Void) {
        fetchSplit?(ticker) { result in
            let splits = try? result.get()
            let latestStockSplit = splits?.getRecent()
            completion((latestStockSplit))
        }
    }
}

extension StockSplitInfo {
    var exDateAsDate: Date {
        return DateTransformer.convertStringToDate(exDate)
    }
}

extension Array where Element == StockSplitInfo {
    
    func getRecent() -> Element? {
        var latestSplit: StockSplitInfo?
        
        for split in self {
            let currDate = split.exDateAsDate
            if currDate.timeIntervalSince(latestSplit?.exDateAsDate ??
                    Date.distantPast) > 0 {
                latestSplit = split
            }
        }
        
        return latestSplit
    }
}
