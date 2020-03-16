//
//  LedgerService.swift
//  Upful
//
//  Created by Yanik Simpson on 3/16/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

struct LedgerService {
    
    // MARK: - Dependencies
    
    private let ledgerLogic = LedgerLogic()
    private let ledgerPersistence: TransactionLedgerPersistence
    private let ledgerLoader: LocalTransactionLedgerLoader
    
    // MARK: - Initializer
    
    init(container: CoreDataModelContainerManager = TransactionLedgerContextManager.shared) {
        self.ledgerPersistence = TransactionLedgerPersistence(container: container)
        self.ledgerLoader = LocalTransactionLedgerLoader(container: container)
    }
    
    // MARK: - Methods
    
    func handleBuy(_ transaction: TransactionDataType, completion: (() -> Void)?) {
        ledgerLoader.loadPrevious(transaction) { (result) in
            switch result {
            case .success(let storedTransaction):
                if let storedTransaction = storedTransaction {
                    self.ledgerLogic.handleBuyWithUpdate(transaction, storedTransaction: storedTransaction)
                    self.ledgerPersistence.save(storedTransaction)
                } else {
                    self.ledgerPersistence.save(transaction)
                }
            case .failure(let err):
                fatalError("Could not load previous transaction, \(err.localizedDescription)")
            }
            completion?()
        }
    }
    
    func loadSavedTransactions(completion: @escaping (Result<[TransactionDataType], Error>) -> Void) {
        ledgerLoader.load(completion: completion)
    }
}
