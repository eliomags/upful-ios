//
//  BalanceManager.swift
//  Upful
//
//  Created by Yanik Simpson on 3/17/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

class BalanceManager {
    
    // MARK: - Dependencies
    
    private let userDefaults: UserDefaults
    
    // MARK: - Properties
    
    enum BalanceType: String {
        case equity, cash
    }
    
    private(set) lazy var currentCashBalance: Double = {
        if let _ = userDefaults.object(forKey: BalanceType.cash.rawValue) {
            return userDefaults.double(forKey: BalanceType.cash.rawValue)
        } else {
            userDefaults.set(25_000.0, forKey: BalanceType.cash.rawValue)
            return userDefaults.double(forKey: BalanceType.cash.rawValue)
        }
    }()
    
    private(set) lazy var totalEquityBalance: Double = {
        if let _ = userDefaults.object(forKey: BalanceType.equity.rawValue) {
            return userDefaults.double(forKey: BalanceType.equity.rawValue)
        } else {
            userDefaults.set(25_000.0, forKey: BalanceType.equity.rawValue)
            return userDefaults.double(forKey: BalanceType.equity.rawValue)
        }
    }()
    
    // MARK: - Initializer
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - Methods
    
    func handleBuy(for transaction: TransactionDataType) {
        currentCashBalance -= Double(transaction.numberOfShares) * transaction.currentPrice
        
        saveBalance()
    }
    
    func handleSell(for transaction: TransactionDataType) {
        currentCashBalance += Double(transaction.numberOfShares) * transaction.currentPrice
        
        saveBalance()
    }
    
    func handleEquityUpdate(with value: Double) {
        totalEquityBalance += value
        
        saveBalance()
    }
    
    private func saveBalance() {
        userDefaults.set(currentCashBalance, forKey: BalanceType.cash.rawValue)
        userDefaults.set(totalEquityBalance, forKey: BalanceType.equity.rawValue)
    }
}

