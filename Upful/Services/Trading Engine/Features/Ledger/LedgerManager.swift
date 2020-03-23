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
    
    private let ledgerLogic = LedgerLogic()
    private let ledgerPersistence: TransactionLedgerPersistence
    private let ledgerLoader: LocalTransactionLedgerLoader
    
    // MARK: - Initializer
    
    init(container: CoreDataModelContainerManager = TransactionContainerManager.shared) {
        self.ledgerPersistence = TransactionLedgerPersistence(container: container)
        self.ledgerLoader = LocalTransactionLedgerLoader(container: container)
    }
    
    // MARK: - Methods
    
    func loadSavedTransactions(completion: @escaping (Result<[Transaction], Error>) -> Void) {
        ledgerLoader.load(completion: completion)
    }
    
    func handleBuy(_ transaction: Transaction, completion: (() -> Void)?) {
        ledgerLoader.load() { (result) in
            switch result {
            case .success(let storedTransactions):
                self.save(transaction,updating: storedTransactions, completion: completion)
                
            case .failure(let err):
                fatalError("Could not load previous transactions, \(err.localizedDescription)")
            }
        }
    }
    
    func handleSell(_ transaction: Transaction, completion: (() -> Void)?) {
        ledgerLoader.load() { (result) in
            switch result {
            case .success(let storedTransactions):
                self.save(transaction,updating: storedTransactions, completion: completion)

            case .failure(let err):
                fatalError("Could not load previous transactions, \(err.localizedDescription)")
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
    
    // MARK: - Helper
    
    fileprivate func save(_ transaction: Transaction, updating storedTransactions: [Transaction], completion: (() -> Void)?) {
        if storedTransactions.contains(where: { $0.ticker == transaction.ticker }) {
            storedTransactions.forEach { storedTransaction in
                if storedTransaction.ticker == transaction.ticker {
                    storedTransaction.currentPrice = transaction.currentPrice

                    self.ledgerPersistence.save(transaction, completion: completion)
                }
            }
        } else {
            self.ledgerPersistence.save(transaction, completion: completion)
        }
    }
}
