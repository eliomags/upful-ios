//
//  LedgerPersistence.swift
//  Upful
//
//  Created by Yanik Simpson on 3/15/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

final class TransactionLedgerPersistence {
    
    // MARK: - Dependencies
    
    private let container: CoreDataModelContainerManager
    
    // MARK: - Initializer
    
    init(container: CoreDataModelContainerManager = TransactionContainerManager.shared) {
        self.container = container
    }
    
    // MARK: - Methods
    
    func save(_ transaction: Transaction, completion: (() -> Void)?) {
        let savingTransaction = PersistedTransaction(context: container.persistentContainer.viewContext)
        savingTransaction.tradePrice = transaction.tradePrice
        savingTransaction.ticker = transaction.ticker
        savingTransaction.numberOfShares = transaction.numberOfShares
        savingTransaction.transactionDate = transaction.transactionDate
        savingTransaction.type = transaction.type
        
        container.saveContext(completion: completion)
    }
    
    func delete(_ transaction: Transaction, completion: (() -> Void)?) {
        let fetchRequest = PersistedTransaction.createFetchRequest()
        let context = container.persistentContainer.viewContext
        
        let persistedTransactions = (try? context.fetch(fetchRequest)) ?? []
        for persistedTransaction in persistedTransactions {
            context.delete(persistedTransaction)
        }
        container.saveContext(completion: completion)
    }
}
