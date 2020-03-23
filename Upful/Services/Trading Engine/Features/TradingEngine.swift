//
//  TradingManager.swift
//  Upful
//
//  Created by Yanik Simpson on 3/17/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

final class TradingEngine {
    
    static let shared = TradingEngine()
    
    // MARK: - Dependencies
    
    let balanceManager: BalanceManager
    private let loggerManager: TransactionLoggingManager
    private let ledgerManager: LedgerManager
    
    // MARK: - Configuration
    
    var handleEquityUpdate: ((_ equity: Double,_ cash: Double) -> Void)?
    var handleBuyCompletion: ((_ equity: Double,_ cash: Double) -> Void)?
    var handleSellCompletion: ((_ equity: Double,_ cash: Double) -> Void)?

    // MARK: - Initializer

    init(balanceDefaults: UserDefaults = UserDefaults.standard,
        loggerContainer: CoreDataModelContainerManager = TransactionContainerManager.shared,
        ledgerContainer: CoreDataModelContainerManager = TransactionContainerManager.shared
    ) {
        self.balanceManager = BalanceManager(userDefaults: balanceDefaults)
        self.loggerManager = TransactionLoggingManager(container: loggerContainer)
        self.ledgerManager = LedgerManager(container: ledgerContainer)
    }
    
    // MARK: - Methods
    
    func buy(transaction: Transaction) {
        validatePurchaseAttempt(transaction) { (isValid) in
            if isValid {
                DispatchQueue.global().async {
                    self.loggerManager.log(transaction, of: .buy, completion: { [unowned self] in
                        self.ledgerManager.handleBuy(transaction, completion: { [unowned self] in
                        self.balanceManager.handleBuy(for: transaction)
                                                
                            self.handleBuyCompletion?(self.balanceManager.totalEquityBalance,
                                                      self.balanceManager.currentCashBalance)
                        })
                    })
                }
            }
        }
    }
    
    func sell(transaction: Transaction) {
        DispatchQueue.global().async {
            self.loggerManager.log(transaction, of: .sell, completion: { [unowned self] in

                self.ledgerManager.handleSell(transaction, completion: { [unowned self] in
                    self.balanceManager.handleSell(for: transaction)

                    self.handleSellCompletion?(self.balanceManager.totalEquityBalance,
                                               self.balanceManager.currentCashBalance)
                })
            })
        }
    }
    
    func update(with transactions: [Transaction], completion: (() -> Void)? = nil) {
        ledgerManager.handlePriceUpdates(transactions, completion: { totalDollarMovement in
            self.balanceManager.handleEquityUpdate(with: totalDollarMovement)
            
            self.handleEquityUpdate?(self.balanceManager.totalEquityBalance,
                                     self.balanceManager.currentCashBalance)
            completion?()
        })
    }
    
    // MARK: - Loading
    
    func loadLoggedTransactions(completion: @escaping (Result<[Transaction],Error>) -> Void) {
        loggerManager.load(completion: completion)
    }
    
    func loadLedgerTransactions(completion: @escaping (Result<[Transaction],Error>) -> Void) {
        ledgerManager.loadSavedTransactions(completion: completion)
    }
    
    // MARK: - Validation
    
    func validatePurchaseAttempt(_ transaction: Transaction, completion: ((Bool) -> Void)) {
        let attemptedPurchase = transaction.currentPrice * Double(transaction.numberOfShares)
        let isLessThanCashHolding = attemptedPurchase < balanceManager.currentCashBalance
        
        completion(isLessThanCashHolding)
    }
    
    // MARK: - TODO: Validate Sale Attempt
    
    func validateSaleAttempt() {
        
    }
}
