//
//  BalanceManagerTests.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 3/17/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class BalanceManagerTests: XCTestCase {
    
    var sut: BalanceManager!
    let userDefaultsSuiteName = "TestDefaults"

    override func setUp() {
       sut = BalanceManager(userDefaults: UserDefaults(suiteName: userDefaultsSuiteName)!)
    }

    override func tearDown() {
        UserDefaults().removePersistentDomain(forName: userDefaultsSuiteName)
    }
    
    func test_balanceSetOnInitialization() {
        XCTAssertEqual(sut.currentCashBalance, 25_000)
        XCTAssertEqual(sut.totalEquityBalance, 25_000)
    }
    
    func test_handleBuy_balanceUpdates() {
        let transaction1 = TransactionViewModel(ticker: "FB", shares: 1, averagePrice: 100, currentPrice: 100)
        
        sut.handleBuy(for: transaction1)
        
        XCTAssertEqual(sut.currentCashBalance, 24_900)
        XCTAssertEqual(sut.totalEquityBalance, 25_000)
        
        let transaction2 = TransactionViewModel(ticker: "FB", shares: 1, averagePrice: 900, currentPrice: 900)
        sut.handleBuy(for: transaction2)

        XCTAssertEqual(sut.currentCashBalance, 24_000)
        XCTAssertEqual(sut.totalEquityBalance, 25_000)
    }
    
    func test_handleSell_withBalanceUpdates() {
        let transaction1 = TransactionViewModel(ticker: "FB", shares: 1, averagePrice: 100, currentPrice: 100)
        sut.handleSell(for: transaction1)
        
        XCTAssertEqual(sut.currentCashBalance, 25_100)
        XCTAssertEqual(sut.totalEquityBalance, 25_000)
        
        let transaction2 = TransactionViewModel(ticker: "FB", shares: 1, averagePrice: 900, currentPrice: 900)
        sut.handleSell(for: transaction2)

        XCTAssertEqual(sut.currentCashBalance, 26_000)
        XCTAssertEqual(sut.totalEquityBalance, 25_000)
    }
    
    func test_handleEquityUpdate() {
        sut.handleEquityUpdate(with: -20_000)
        
        XCTAssertEqual(sut.currentCashBalance, 25_000)
        XCTAssertEqual(sut.totalEquityBalance, 5_000)
        
        sut.handleEquityUpdate(with: 20_000)
        
        XCTAssertEqual(sut.currentCashBalance, 25_000)
        XCTAssertEqual(sut.totalEquityBalance, 25_000)
    }
}
