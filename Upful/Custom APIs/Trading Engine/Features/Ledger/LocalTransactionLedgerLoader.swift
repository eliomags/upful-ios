//
//  LocalTransactionLedgerLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 3/15/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

final class LocalTransactionLedgerLoader: TransactionLoader {
    
    // MARK: - Dependencies

    private let container: CoreDataModelContainerManager

    // MARK: - Initializer

    init(container: CoreDataModelContainerManager = TransactionContainerManager.shared) {
        self.container = container
    }
    
    // MARK: - Methods
    
    func loadFiltering(_ ticker: String) -> [Transaction] {
        let request = PersistedTransaction.createFetchRequest()
        request.predicate = NSPredicate(format: "ticker == %@", ticker)
        let persistedTransactions = try! self.container.persistentContainer.viewContext.fetch(request)
        return persistedTransactions
    }
    
    func load(completion: @escaping (Result<[Transaction], Error>)-> Void) {
        let request = PersistedTransaction.createFetchRequest()
        completion(Result {
            let persistedTransactions = try self.container.persistentContainer.viewContext.fetch(request)
            return persistedTransactions
        })
    }
    
    func loadAllPersistedTransactions() -> [Transaction] {
        let request = PersistedTransaction.createFetchRequest()
        let persistedTransactions = try? self.container.persistentContainer.viewContext.fetch(request)
        return persistedTransactions ?? []
    }
}
