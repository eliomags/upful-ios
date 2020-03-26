//
//  HoldingMapper.swift
//  Upful
//
//  Created by Yanik Simpson on 3/22/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

struct HoldingMapper {
    
    // MARK: - Methods
    
    static func map(_ transactions: [Transaction]) -> [Holding] {
        var holdings: [Holding] = []
        var copy = transactions
        
        while !copy.isEmpty {
            let first = copy.first!
            let holding = Holding(ticker: first.ticker,
                                  transactions: allTransactionsSatisfying(first, from: &copy))
            holdings.append(holding)
            
            removeAllTransactionsSatisfying(first, from: &copy)
        }
        
        return holdings
    }
    
    // MARK: - Helper Methods
    
    private static func allTransactionsSatisfying(_ transaction: Transaction, from transactions: inout [Transaction]) -> [Transaction] {
        return transactions.filter({ $0.ticker == transaction.ticker })
    }
    
    private static func removeAllTransactionsSatisfying(_ transaction: Transaction, from transactions: inout [Transaction]) {
        transactions.removeAll(where: { $0.ticker == transaction.ticker})
    }
}
