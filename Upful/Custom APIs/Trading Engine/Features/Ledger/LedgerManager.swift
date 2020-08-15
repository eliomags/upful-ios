//
//  LedgerService.swift
//  Upful
//
//  Created by Yanik Simpson on 3/16/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

final class LedgerManager {
    
    // MARK: - Dependencies
    
    let ledgerPersistence: TransactionLedgerPersistence
    private let ledgerLoader: LocalTransactionLedgerLoader
    
    // MARK: - Initializer
    
    init(container: CoreDataModelContainerManager = TransactionContainerManager.shared) {
        self.ledgerPersistence = TransactionLedgerPersistence(container: container)
        self.ledgerLoader = LocalTransactionLedgerLoader(container: container)
    }
    
    // MARK: - Methods
    
    func getActiveTransactions(for ticker: String) -> [Transaction] {
        return ledgerLoader.loadFiltering(ticker)
    }
    
    func loadSavedTransactions(completion: @escaping (Result<[Transaction], Error>) -> Void) {
        ledgerLoader.load(completion: completion)
    }
    
    func save(_ transaction: Transaction, completion: (() -> Void)?) {
        ledgerPersistence.save(transaction, completion: completion)
    }
    
    func delete(_ transactions: [Transaction], completion: (() -> Void)?) {
        
    }
}
