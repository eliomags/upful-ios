//
//  HoldingMapper.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 3/22/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class HoldingMapperTests: XCTestCase {

    var sut: HoldingMapper!
    
    override func setUp() {
        sut = HoldingMapper()
    }
    
    // MARK: - Creation
    
    func test_map_whereAllTransactionsContainingSameTicker() {
        
        XCTAssertEqual(HoldingMapper.map(makeSUTWithSameTickers()).count, 1)
    }
    
    func test_map_whereAllTransactionsContainingDifferentTicker() {
        
        XCTAssertEqual(HoldingMapper.map(makeSUTWithTwoDifferentTickers()).count, 2)
    }
    
    func test_map_whereAllTransactionsContainingAllDifferentTicker() {
        
        XCTAssertEqual(HoldingMapper.map(makeSUTWithFourDifferentTickers()).count, 4)
    }
    
    func test_map_eachHoldingCorrectlyConfigured() {
        
        HoldingMapper.map(makeSUTWithFourDifferentTickers()).forEach { (holding) in
            let areAllTransactionTickersEqual = holding.transactions.allSatisfy { $0.ticker == holding.ticker }
            XCTAssertTrue(areAllTransactionTickersEqual)
        }
    }
    
    // MARK: - Fileprivate Helper Methods
    
    fileprivate func makeSUTWithSameTickers() -> [Transaction] {
        let transactions = [
            TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 1),
            TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 2),
        ]
        
        return transactions
    }
    
    fileprivate func makeSUTWithTwoDifferentTickers() -> [Transaction] {
        let transactions = [
            TransactionAdapter(ticker: "AAPL", shares: 1, tradePrice: 1),
            TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 1),
            TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 2),
        ]
        
        return transactions
    }
    
    fileprivate func makeSUTWithFourDifferentTickers() -> [Transaction] {
        let transactions = [
            TransactionAdapter(ticker: "AAPL", shares: 1, tradePrice: 1),
            TransactionAdapter(ticker: "FB", shares: 1, tradePrice: 1),
            TransactionAdapter(ticker: "ZM", shares: 1, tradePrice: 2),
            TransactionAdapter(ticker: "GE", shares: 1, tradePrice: 2),
            TransactionAdapter(ticker: "GE", shares: 1, tradePrice: 2),
        ]
        
        return transactions
    }
}
