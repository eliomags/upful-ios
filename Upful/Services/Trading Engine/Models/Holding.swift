//
//  Holding.swift
//  Upful
//
//  Created by Yanik Simpson on 3/22/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

struct Holding {
    private(set) var transactions: [Transaction]
    
    var ticker: [String] {
        let copy = transactions.map { $0.ticker }
        
        return copy
    }
    
    init(transactions: [Transaction]) {
        self.transactions = transactions
    }
}

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
            let holding = Holding(transactions: allTransactionsSatifying(first, from: &copy))
            holdings.append(holding)
            
            removeAllTransactionsSatisfying(first, from: &copy)
        }
        
        return holdings
    }
    
    // MARK: - Helper Methods
    
    private func allTransactionsSatifying(_ transaction: Transaction, from transactions: inout [Transaction]) -> [Transaction] {
        return transactions.filter({ $0.ticker == transaction.ticker })
    }
    
    private func removeAllTransactionsSatisfying(_ transaction: Transaction, from transactions: inout [Transaction]) {
        transactions.removeAll(where: { $0.ticker == transaction.ticker})
    }
}
