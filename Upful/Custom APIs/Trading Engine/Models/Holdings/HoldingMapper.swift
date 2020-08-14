//
//  HoldingMapper.swift
//  Upful
//
//  Created by Yanik Simpson on 3/22/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

class HoldingMapper {
    
    private let quoteLoader = StockPriceLoader()
    private let holdingsLoadGroup = DispatchGroup()
    
    var completionHandler: (([Holding]) -> Void)?
    
    // MARK: - Methods
    
    func createHoldings(from transactions: [Transaction]) {
        let activeHoldings = HoldingMapper.map(transactions).filter { $0.totalShareCount > 0 }
        
        activeHoldings.forEach({ loadQuotes(for: $0) })

        holdingsLoadGroup.notify(queue: .main) {
            self.completionHandler?(activeHoldings)
        }
    }
    
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
    
    fileprivate func loadQuotes(for holding: Holding) {
        holdingsLoadGroup.enter()
        quoteLoader.load(for: holding.ticker) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let quote):
                holding.currentPrice = quote.latestPrice

            case .failure(_):
                print("Error Loading quotes for:", holding.ticker)
            }

            self.holdingsLoadGroup.leave()
        }
    }
    
    // MARK: - Helper Methods
    
    private static func allTransactionsSatisfying(_ transaction: Transaction, from transactions: inout [Transaction]) -> [Transaction] {
        return transactions.filter({ $0.ticker == transaction.ticker })
    }
    
    private static func removeAllTransactionsSatisfying(_ transaction: Transaction, from transactions: inout [Transaction]) {
        transactions.removeAll(where: { $0.ticker == transaction.ticker})
    }
}
