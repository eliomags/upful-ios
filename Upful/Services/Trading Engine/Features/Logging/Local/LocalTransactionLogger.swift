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
    
    init(container: CoreDataModelContainerManager = TransactionLoggerContextManager.shared) {
        self.container = container
    }
}

extension LocalTransactionLogger: TransactionLogger {
    func log(_ transaction: TransactionDataType, of type: TransactionType, completion: (() -> Void)?) {
        let savingTransaction = PersistedTransaction(context: container.persistentContainer.viewContext)
        savingTransaction.averagePrice = transaction.averagePrice
        savingTransaction.currentPrice = transaction.currentPrice
        savingTransaction.ticker = transaction.ticker
        savingTransaction.numberOfShares = transaction.numberOfShares
        
        savingTransaction.transactionDate = transaction.transactionDate
        savingTransaction.type = transaction.type
//        savingTransaction.transactionDate = Date().asString
//        savingTransaction.type = type.rawValue
        
        container.saveContext(completion: completion)
    }
}
