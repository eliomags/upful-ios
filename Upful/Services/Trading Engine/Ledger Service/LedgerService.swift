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
    
    func loadSavedTransactions(completion: @escaping (Result<[TransactionDataType], Error>) -> Void) {
        ledgerLoader.load(completion: completion)
    }
    
    func handleBuy(_ transaction: TransactionDataType, completion: (() -> Void)?) {
        ledgerLoader.loadPrevious(transaction) { (result) in
            switch result {
            case .success(let storedTransaction):
                if let storedTransaction = storedTransaction {
                    self.ledgerLogic.handleBuyWithUpdate(transaction, storedTransaction: storedTransaction)
                    self.ledgerPersistence.save(storedTransaction, completion: completion)
                } else {
                    self.ledgerPersistence.save(transaction, completion: completion)
                }
                
            case .failure(let err):
                fatalError("Could not load previous transaction, \(err.localizedDescription)")
            }
        }
    }
    
    func handleSell(_ transaction: TransactionDataType, completion: (() -> Void)?) throws {
        ledgerLoader.loadPrevious(transaction) { (result) in
            switch result {
            case .success(let storedTransaction):
                if let storedTransaction = storedTransaction {
                    try? self.ledgerLogic.handleSell(transaction, storedTransaction: storedTransaction)
                    
                    if storedTransaction.numberOfShares == 0 {
                        self.ledgerPersistence.delete(storedTransaction, completion: completion)
                        return
                    }
                    self.ledgerPersistence.save(storedTransaction, completion: completion)
                } else {
                    fatalError("Did not find previous saved transaction.")
                }
                
            case .failure(let err):
                fatalError("Could not load previous transaction, \(err.localizedDescription)")
            }
        }
    }
    
    func handlePriceUpdates(_ transactions: [Transaction], completion: ((Double) -> Void)?) {
        loadSavedTransactions { (result) in
            switch result {
            case .success(let savedTransactions):
                self.ledgerLogic.handlePriceUpdates(currentTransactions: savedTransactions, updatedTransactions: transactions)
                
                // TODO: - May need to add saving
                
                let totalPriceChange = self.ledgerLogic.getTotalPriceChange(from: savedTransactions)
                completion?(totalPriceChange)
                
            case .failure(let err):
                fatalError("Could not load previous transactions, \(err.localizedDescription)")
            }
        }
    }
}
