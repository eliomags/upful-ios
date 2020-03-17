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
    func handleBuyWithUpdate(_ newTransaction: TransactionDataType, storedTransaction: TransactionDataType) {
        updateAveragePrice(for: storedTransaction, from: newTransaction)
        storedTransaction.currentPrice = newTransaction.currentPrice
        storedTransaction.numberOfShares += newTransaction.numberOfShares
    }
    
    func handleSell(_ newTransaction: TransactionDataType, storedTransaction: TransactionDataType) throws {
        guard newTransaction.numberOfShares <= storedTransaction.numberOfShares else { throw LedgerError.badShareCount }
        storedTransaction.currentPrice = newTransaction.currentPrice
        storedTransaction.numberOfShares -= newTransaction.numberOfShares
    }
    
    func handlePriceUpdates(currentTransactions: [TransactionDataType], updatedTransactions: [TransactionDataType]) {
        updatedTransactions.forEach { (updatedTransaction) in
            if let curr = currentTransactions.first(where: { $0.ticker == updatedTransaction.ticker}) {
                curr.currentPrice = updatedTransaction.currentPrice
                updateAveragePrice(for: curr, from: updatedTransaction)
            } else {
                return
            }
        }
    }
    
    // based on new current price, calculate total price change from average price
    func getTotalPriceChange(from storedTransactions: [Transaction]) -> Double {
        let totalPriceChange = storedTransactions.reduce(0) { (result, currentTransaction) -> Double in
            return (currentTransaction.currentPrice - currentTransaction.averagePrice) *
                Double(currentTransaction.numberOfShares) + result
        }
        return totalPriceChange
    }
 
    private func updateAveragePrice(for storedTransaction: TransactionDataType,from newTransaction: TransactionDataType) {
        let total = Double(newTransaction.numberOfShares + storedTransaction.numberOfShares)
        let weightNew = Double(newTransaction.numberOfShares) / total
        let weightOld = Double(storedTransaction.numberOfShares) / total
        
        storedTransaction.averagePrice =
            (weightNew * newTransaction.averagePrice) +
            (weightOld * storedTransaction.averagePrice)
    }
}
