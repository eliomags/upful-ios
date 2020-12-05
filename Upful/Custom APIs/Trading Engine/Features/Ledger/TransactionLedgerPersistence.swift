//
//  LedgerPersistence.swift
//  Upful
//
//  Created by Yanik Simpson on 3/15/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation
import CoreData

final class TransactionLedgerPersistence {
    
    // MARK: - Dependencies
    
    let context: NSManagedObjectContext
    
    // MARK: - Initializer
    
    init(context: NSManagedObjectContext = TransactionContainerManager.shared.managedObjectContext) {
        self.context = context
    }
    
    // MARK: - Methods
        
    func save(_ transaction: Transaction, completion: @escaping ((Error?) -> Void)) {
        context.perform {
            let savingTransaction = PersistedTransaction(context: self.context)
            savingTransaction.id = transaction.id
            savingTransaction.type = transaction.type
            savingTransaction.ticker = transaction.ticker
            savingTransaction.tradePrice = transaction.tradePrice
            savingTransaction.numberOfShares = transaction.numberOfShares
            savingTransaction.transactionDate = transaction.transactionDate
            savingTransaction.lastAppliedStockSplit = transaction.lastAppliedStockSplit
            
            self.context.saveOrRollBackIfNeeded(completion: completion)
        }
    }
    
    func delete(_ transaction: Transaction, completion: @escaping ((Error?) -> Void)) {
        context.perform {
            let fetchRequest = PersistedTransaction.createFetchRequest()
            let persistedTransactions = (try? self.context.fetch(fetchRequest)) ?? []
            for persistedTransaction in persistedTransactions {
                self.context.delete(persistedTransaction)
            }
            self.context.saveOrRollBackIfNeeded(completion: completion)
        }
    }
}
