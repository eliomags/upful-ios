//
//  HoldingMapper.swift
//  Upful
//
//  Created by Yanik Simpson on 3/22/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

struct HoldingMapper {
    private var transactions: [Transaction]
    
    init(transactions: [Transaction]) {
        self.transactions = transactions
    }
    
    // MARK: - Methods
    
    func map() -> [Holding] {
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
    
    private func allTransactionsSatisfying(_ transaction: Transaction, from transactions: inout [Transaction]) -> [Transaction] {
        return transactions.filter({ $0.ticker == transaction.ticker })
    }
    
    private func removeAllTransactionsSatisfying(_ transaction: Transaction, from transactions: inout [Transaction]) {
        transactions.removeAll(where: { $0.ticker == transaction.ticker})
    }
}
