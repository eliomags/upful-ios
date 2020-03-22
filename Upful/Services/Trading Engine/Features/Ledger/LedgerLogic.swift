//
//  LedgerLogic.swift
//  Upful
//
//  Created by Yanik Simpson on 3/15/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

public enum LedgerError: Error {
    case badShareCount
}

struct LedgerLogic {
    func handleBuyWithUpdate(_ newTransaction: Transaction, storedTransaction: Transaction) {
        updateAveragePrice(for: storedTransaction, from: newTransaction)
        storedTransaction.currentPrice = newTransaction.currentPrice
    }
    
    func handleSell(_ newTransaction: Transaction, storedTransaction: Transaction) throws {
        guard newTransaction.numberOfShares <= storedTransaction.numberOfShares else { throw LedgerError.badShareCount }
        storedTransaction.currentPrice = newTransaction.currentPrice
    }
    
    func handlePriceUpdates(currentTransactions: [Transaction], updatedTransactions: [Transaction]) {
        updatedTransactions.forEach { (updatedTransaction) in
            if let curr = currentTransactions.first(where: { $0.ticker == updatedTransaction.ticker}) {
                curr.currentPrice = updatedTransaction.currentPrice
            } else {
                return
            }
        }
    }
    
    // based on new current price, calculate total price change from average price
    func getTotalPriceChange(from storedTransactions: [Transaction]) -> Double {
        let totalPriceChange = storedTransactions.reduce(0) { (result, currentTransaction) -> Double in
            return (currentTransaction.currentPrice - currentTransaction.tradePrice) *
                Double(currentTransaction.numberOfShares) + result
        }
        return totalPriceChange
    }
 
    private func updateAveragePrice(for storedTransaction: Transaction,from newTransaction: Transaction) {
//        let total = Double(newTransaction.numberOfShares + storedTransaction.numberOfShares)
//        let weightNew = Double(newTransaction.numberOfShares) / total
//        let weightOld = Double(storedTransaction.numberOfShares) / total
        
//        storedTransaction.tradePrice =
//            (weightNew * newTransaction.tradePrice) +
//            (weightOld * storedTransaction.tradePrice)
    }
}
