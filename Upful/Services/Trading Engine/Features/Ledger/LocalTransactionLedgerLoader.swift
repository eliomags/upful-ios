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
    
    func load(completion: @escaping (Result<[Transaction], Error>)-> Void) {
        let request = PersistedTransaction.createFetchRequest()
        completion(Result {
            let persistedTransactions = try self.container.persistentContainer.viewContext.fetch(request)
            return persistedTransactions
        })
    }
        
    func loadPrevious(_ transaction: Transaction, completion: @escaping (Result<Transaction?, Error>)-> Void) {
        load { (result) in
            switch result {
            case .success(let storedTransactions):
                let previousTransaction = storedTransactions.first(where: { $0.ticker == transaction.ticker })
                completion(.success(previousTransaction))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
}
