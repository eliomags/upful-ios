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
    
    var container: CoreDataModelContainerManager = TransactionContainerManager.shared
    
    // MARK: - Initializer

    init(balanceDefaults: UserDefaults = UserDefaults.standard,
         container: CoreDataModelContainerManager = TransactionContainerManager.shared) {
        self.container = container
        self.balanceManager = BalanceManager(userDefaults: balanceDefaults)
        self.loggerManager = TransactionLoggingManager(container: container)
        self.ledgerManager = LedgerManager(container: container)
    }
    
    // MARK: - Methods
    
    func buy(transaction: Transaction, completion: ((Bool) -> Void)? = nil) {
        validatePurchaseAttempt(transaction) { [unowned self] (isValid) in
            if isValid { 
                self.loggerManager.log(transaction, of: .buy, completion: { [unowned self] in
                    self.ledgerManager.save(transaction, completion: { [unowned self] in
                        AnalyticsLogger.instance.reportEvents(event: .performedTransaction(type: .buy))
                        
                        self.balanceManager.handleBuy(for: transaction.tradePrice,
                                                      shares: Int(transaction.numberOfShares))
                        completion?(isValid)
                    })
                })
                
            } else {
                completion?(isValid)
            }
        }
    }
    
    func sell(transaction: Transaction, completion: (() -> Void)? = nil) {
        loggerManager.log(transaction, of: .sell, completion: { [unowned self] in
            self.ledgerManager.save(transaction, completion: { [unowned self] in
                AnalyticsLogger.instance.reportEvents(event: .performedTransaction(type: .sell))
                
                self.balanceManager.handleSell(for: transaction.tradePrice,
                                               shares: Int(transaction.numberOfShares))
                DispatchQueue.main.async { completion?() }
            })
        })
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
    var syncProfile: (([Holding], Double) -> ())? = ProfileSyncCoordinator.shared.sync
    
    var stockSplitGroup: DispatchGroup?
    
    func loadHoldings() {
        mapTransactionsToHoldings { [unowned self] holdings in
            self.updateEquityBalance(with: holdings)
            self.applyStockSplits(for: holdings)
        }
    }
    
    func applyStockSplits(for holdings: [Holding]) {
        var stockSplitHandlers = [StockSplitHandler]()
        
        for ticker in holdings.map({ $0.ticker }) {
            let transactions = ledgerManager.getActiveTransactions(for: ticker)
            let splitHandler = StockSplitHandler(ticker: ticker, transactions: transactions)
            stockSplitHandlers.append(splitHandler)
        }
        
        stockSplitGroup = DispatchGroup()
        stockSplitGroup?.notify(queue: .global(qos: .userInitiated)) {
            self.mapTransactionsToHoldings { [unowned self] holdings in
                self.syncProfile?(holdings, self.balanceManager.totalEquityBalance)
                self.container.saveContext { [unowned self] in
                    self.completionHandler?(holdings)
                }
            }
        }
        
        stockSplitHandlers.begin(dispatchGroup: stockSplitGroup)
    }
    
    fileprivate func mapTransactionsToHoldings(_ block: @escaping ([Holding]) -> Void) {
        ledgerManager.loadSavedTransactions { [weak self] result in
            _ = result.map({ savedTransactions in
                self?.holdingMapper.completionHandler = block
                self?.holdingMapper.createHoldings(from: savedTransactions)
            })
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
