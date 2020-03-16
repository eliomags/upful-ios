//
//  LedgerPersistence.swift
//  Upful
//
//  Created by Yanik Simpson on 3/15/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

class TransactionLedgerPersistence {
    
    // MARK: - Dependencies
    
    private let container: CoreDataModelContainerManager
    
    // MARK: - Initializer
    
    init(container: CoreDataModelContainerManager = TransactionLedgerContextManager.shared) {
        self.container = container
    }
    
    // MARK: - Methods
    
    func save(_ transaction: TransactionDataType) {
        let savingTransaction = PersistedTransaction(context: container.persistentContainer.viewContext)
        savingTransaction.averagePrice = transaction.averagePrice
        savingTransaction.currentPrice = transaction.currentPrice
        savingTransaction.ticker = transaction.ticker
        savingTransaction.numberOfShares = transaction.numberOfShares
        savingTransaction.transactionDate = transaction.transactionDate
        container.saveContext()
    }
    
    func delete(_ transaction: TransactionDataType) {
        let fetchRequest = PersistedTransaction.createFetchRequest()
        let context = container.persistentContainer.viewContext
        
        fetchRequest.predicate = NSPredicate(format: "ticker = %@", transaction.ticker)
        let persistedTransactions = (try? context.fetch(fetchRequest)) ?? []
        for persistedTransaction in persistedTransactions {
            context.delete(persistedTransaction)
        }
        container.saveContext()
    }
}
