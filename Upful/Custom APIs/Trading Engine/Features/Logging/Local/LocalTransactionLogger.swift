//
//  LocalTransactionLogger.swift
//  Upful
//
//  Created by Yanik Simpson on 3/17/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation
import CoreData

final class LocalTransactionLogger {
        
    // MARK: - Dependencies
    
    private let context: NSManagedObjectContext
    
    // MARK: - Initializer
    
    init(context: NSManagedObjectContext = TransactionContainerManager.shared.backgroundContext) {
        self.context = context
    }
}

extension LocalTransactionLogger: TransactionLogger {
    func log(_ transaction: Transaction, of type: TransactionType, completion: (() -> Void)?) {
        context.perform {
            let savingTransaction = LoggedTransaction(context: self.context)
            savingTransaction.ticker = transaction.ticker
            savingTransaction.tradePrice = transaction.tradePrice
            savingTransaction.numberOfShares = transaction.numberOfShares
            savingTransaction.transactionDate = transaction.transactionDate
            savingTransaction.type = transaction.type
            
            self.context.saveOrRollBackIfNeeded()
            completion?()
        }
    }
}
