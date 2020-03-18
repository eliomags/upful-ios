//
//  TradingManager.swift
//  Upful
//
//  Created by Yanik Simpson on 3/17/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

struct TradingEngine {
    
    // MARK: - Dependencies
    
    private let balanceManager: BalanceManager
    private let loggerManager: TransactionLoggingManager
    private let ledgerManager: LedgerManager
    
    // MARK: - Configuration
    
    var handleEquityUpdate: ((_ equity: Double,_ cash: Double) -> Void)?
    var handleBuyCompletion: ((_ equity: Double,_ cash: Double) -> Void)?
    var handleSellCompletion: ((_ equity: Double,_ cash: Double) -> Void)?

    // MARK: - Initializer

    init(balanceDefaults: UserDefaults = UserDefaults.standard,
        loggerContainer: CoreDataModelContainerManager = TransactionLoggerContextManager.shared,
        ledgerContainer: CoreDataModelContainerManager = TransactionLedgerContextManager.shared
    ) {
        self.balanceManager = BalanceManager(userDefaults: balanceDefaults)
        self.loggerManager = TransactionLoggingManager(container: loggerContainer)
        self.ledgerManager = LedgerManager(container: ledgerContainer)
    }
    
    // MARK: - Methods
    
    func buy(transaction: TransactionDataType) {
        ledgerManager.handleBuy(transaction, completion: {
            self.balanceManager.handleBuy(for: transaction)
            
            self.loggerManager.log(transaction, of: .buy, completion: {
                self.handleBuyCompletion?(self.balanceManager.totalEquityBalance,
                                          self.balanceManager.currentCashBalance)
            })
        })
    }
    
    func sell(transaction: TransactionDataType) {
        do {
            try ledgerManager.handleSell(transaction, completion: {
                self.balanceManager.handleSell(for: transaction)
                self.loggerManager.log(transaction, of: .sell, completion: {
                    self.handleSellCompletion?(self.balanceManager.totalEquityBalance,
                                               self.balanceManager.currentCashBalance)
                })
            })
        } catch {
            fatalError("Failed to sell.")
        }
    }
    
    func update(with transactions: [TransactionDataType], completion: (() -> Void)? = nil) {
        ledgerManager.handlePriceUpdates(transactions, completion: { totalDollarMovement in
            self.balanceManager.handleEquityUpdate(with: totalDollarMovement)
            
            self.handleEquityUpdate?(self.balanceManager.totalEquityBalance,
                                     self.balanceManager.currentCashBalance)
            completion?()
        })
    }
    
    func loadLoggedTransactions(completion: @escaping (Result<[TransactionDataType],Error>) -> Void) {
        loggerManager.load(completion: completion)
    }
    
    func loadLedgerTransactions(completion: @escaping (Result<[TransactionDataType],Error>) -> Void) {
        ledgerManager.loadSavedTransactions(completion: completion)
    }
}
