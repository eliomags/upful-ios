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
                        self.ledgerManager.save(transaction, completion: { [unowned self] in
                            
                            self.balanceManager.handleBuy(for: transaction.tradePrice,
                                                          shares: Int(transaction.numberOfShares))
                                                
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
                self.ledgerManager.save(transaction, completion: { [unowned self] in
                    
                    self.balanceManager.handleSell(for: transaction.tradePrice,
                                                   shares: Int(transaction.numberOfShares))

                    self.handleSellCompletion?(self.balanceManager.totalEquityBalance,
                                               self.balanceManager.currentCashBalance)
                })
            })
        }
    }
    
    // TODO: - Load current price after holdings load
    
//    func update(with transactions: [Transaction], completion: (() -> Void)? = nil) {
//        ledgerManager.handlePriceUpdates(transactions, completion: { totalDollarMovement in
//            self.balanceManager.handleEquityUpdate(with: totalDollarMovement)
//
//            self.handleEquityUpdate?(self.balanceManager.totalEquityBalance,
//                                     self.balanceManager.currentCashBalance)
//            completion?()
//        })
//    }
    
    // MARK: - Loading
    
    func loadHoldings(completion: (([Holding], Error?) -> Void)?) {
        ledgerManager.loadSavedTransactions { (result) in
            switch result {
            case .success(let ledgerTransactions):
                let holdings = HoldingMapper(transactions: ledgerTransactions).map()
                
                completion?(holdings, nil)
                
            case .failure(let err):
                completion?([], err)
            }
        }
    }
    
    func loadLoggedTransactions(completion: @escaping (Result<[Transaction],Error>) -> Void) {
        loggerManager.load(completion: completion)
    }
    
    func loadLedgerTransactions(completion: @escaping (Result<[Transaction],Error>) -> Void) {
        ledgerManager.loadSavedTransactions(completion: completion)
    }
    
    // MARK: - Validation
    
    func validatePurchaseAttempt(_ transaction: Transaction, completion: ((Bool) -> Void)) {
        let attemptedPurchase = transaction.tradePrice * Double(transaction.numberOfShares)
        let isLessThanCashHolding = attemptedPurchase <= balanceManager.currentCashBalance
        
        completion(isLessThanCashHolding)
    }
    
    func validateSaleAttempt(transaction: Transaction, holding: Holding, completion: ((Bool) -> Void)) {
        let isLessThanCurrentShares = transaction.numberOfShares < holding.totalShareCount
        completion(isLessThanCurrentShares)
    }
}
