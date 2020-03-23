//
//  LocalTransactionLogger.swift
//  Upful
//
//  Created by Yanik Simpson on 3/17/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

final class LocalTransactionLogger {
        
    // MARK: - Dependencies
    
    private let container: CoreDataModelContainerManager
    
    // MARK: - Initializer
    
    init(container: CoreDataModelContainerManager = TransactionContainerManager.shared) {
        self.container = container
    }
}

extension LocalTransactionLogger: TransactionLogger {
    func log(_ transaction: Transaction, of type: TransactionType, completion: (() -> Void)?) {
        let savingTransaction = LoggedTransaction(context: container.persistentContainer.viewContext)
        savingTransaction.ticker = transaction.ticker
        savingTransaction.tradePrice = transaction.tradePrice
        savingTransaction.numberOfShares = transaction.numberOfShares
        savingTransaction.transactionDate = transaction.transactionDate
        savingTransaction.type = transaction.type
        
        container.saveContext(completion: completion)
    }
}
