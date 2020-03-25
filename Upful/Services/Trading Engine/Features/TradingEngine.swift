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
    
    func buy(transaction: Transaction, completion: ((Bool) -> Void)? = nil) {
        validatePurchaseAttempt(transaction) { (isValid) in
            if isValid { 
                DispatchQueue.global().async {
                    self.loggerManager.log(transaction, of: .buy, completion: { [unowned self] in
                        self.ledgerManager.save(transaction, completion: { [unowned self] in
                            AnalyticsLogger.instance.reportEvents(event: .performedTransaction(type: .buy))
                            
                            self.balanceManager.handleBuy(for: transaction.tradePrice,
                                                          shares: Int(transaction.numberOfShares))
                            completion?(isValid)
                            self.handleBuyCompletion?(self.balanceManager.totalEquityBalance,
                                                      self.balanceManager.currentCashBalance)
                        })
                    })
                }
            } else {
                completion?(isValid)
            }
        }
    }
    
    func sell(transaction: Transaction, completion: (() -> Void)? = nil) {
        DispatchQueue.global().async {
            self.loggerManager.log(transaction, of: .sell, completion: { [unowned self] in
                self.ledgerManager.save(transaction, completion: { [unowned self] in
                    AnalyticsLogger.instance.reportEvents(event: .performedTransaction(type: .sell))
                    
                    self.balanceManager.handleSell(for: transaction.tradePrice,
                                                   shares: Int(transaction.numberOfShares))
                    completion?()
                    self.handleSellCompletion?(self.balanceManager.totalEquityBalance,
                                               self.balanceManager.currentCashBalance)
                })
            })
        }
    }
        
    func updateEquityBalance(with holdings: [Holding]) {
        // cash + total movement + total value of shares
        let total = holdings.filter { $0.totalShareCount != 0 }
            .reduce(0) { (res, holding) -> Double in
                let totalHoldingValue = holding.currentTotalValue
                let totalPriceMovement = holding.totalPriceMovementDollar
                
                return totalHoldingValue + totalPriceMovement + res
        }
        
//        let totalMovement = holdings
//            .filter { $0.totalShareCount != 0 }
//            .map { $0.totalPriceMovementDollar }
//            .reduce(0) { (res, val) -> Double in return res + val }
//
//        let totalValue = holdings
//            .reduce(0) { (res, holding) -> Double in return res + holding.currentTotalValue }
        
        balanceManager.handleEquityUpdate(with: total)
    }
    
    // MARK: - Loading
    
    func loadHoldings(completion: (([Holding], Error?) -> Void)?) {
        ledgerManager.loadSavedTransactions { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let ledgerTransactions):
                let holdings = HoldingMapper(transactions: ledgerTransactions).map()
                self.updateEquityBalance(with: holdings)
                completion?(holdings.filter { $0.totalShareCount != 0 }, nil)
                
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
