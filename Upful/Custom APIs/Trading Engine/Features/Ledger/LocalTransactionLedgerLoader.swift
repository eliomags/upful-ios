//
//  LocalTransactionLedgerLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 3/15/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation
import CoreData

final class LocalTransactionLedgerLoader: TransactionLoader {
    
    // MARK: - Dependencies

    private let context: NSManagedObjectContext

    // MARK: - Initializer

    init(context: NSManagedObjectContext = TransactionContainerManager.shared.managedObjectContext) {
        self.context = context
    }
    
    // MARK: - Methods
    
    func loadFiltering(_ ticker: String) -> [Transaction] {
        let request = PersistedTransaction.createFetchRequest()
        request.predicate = NSPredicate(format: "ticker == %@", ticker)
        let persistedTransactions = try! self.context.fetch(request)
        return persistedTransactions
    }
    
    func load(completion: @escaping (Result<[Transaction], Error>)-> Void) {
        context.perform {
            let request = PersistedTransaction.createFetchRequest()
            completion(Result {
                let persistedTransactions = try self.context.fetch(request)
                return persistedTransactions
            })
        }
    }
    
    func loadAllPersistedTransactions() -> [Transaction] {
        let request = PersistedTransaction.createFetchRequest()
        let persistedTransactions = try? self.context.fetch(request)
        return persistedTransactions ?? []
    }
    
    func loadTransactions(startingFrom date: Date) -> [Transaction] {
        let dateAsString = date.asString
        let request = PersistedTransaction.createFetchRequest()
        let predicate = NSPredicate(format: "transactionDate > %@", dateAsString)
        request.predicate = predicate
        let persistedTransactions = try? self.context.fetch(request)

        return persistedTransactions ?? []
    }
}
