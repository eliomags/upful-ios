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
        
    // MARK: - Initializer

    init(balanceDefaults: UserDefaults = UserDefaults.standard,
        loggerContainer: CoreDataModelContainerManager = TransactionContainerManager.shared,
        ledgerContainer: CoreDataModelContainerManager = TransactionContainerManager.shared) {
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
                    DispatchQueue.main.async { completion?() }
                })
            })
        }
    }
        
    func updateEquityBalance(with holdings: [Holding]) {
        // total movement + total value of shares
        let total = holdings.filter { $0.totalShareCount > 0 }
            .reduce(0) { (res, holding) -> Double in
                let totalHoldingValue = holding.currentTotalValue
                return totalHoldingValue + res
        }
    
        balanceManager.handleEquityUpdate(with: total)
    }
    
    // MARK: - Loading
    private let holdingMapper = HoldingMapper()
    var completionHandler: (([Holding]) -> Void)?

    func loadHoldings() {
        
        DispatchQueue.global().async {
            self.ledgerManager.loadSavedTransactions { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let ledgerTransactions):
                    self.holdingMapper.loadingHoldings(from: ledgerTransactions)
                    
                    self.holdingMapper.completionHandler = { [unowned self] holdings in
                        self.updateEquityBalance(with: holdings)
                        self.completionHandler?(holdings)
                    }
                    
                case .failure(_):
                    assertionFailure("Failed to load transactions from Core Data")
                }
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
