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
    
    
    // MARK: - Creation
    
    func test_map_whereAllTransactionsContainingSameTicker() {
        sut = makeSUTWithSameTickers()
        
        XCTAssertEqual(sut.map().count, 1)
    }
    
    func test_map_whereAllTransactionsContainingDifferentTicker() {
        sut = makeSUTWithTwoDifferentTickers()
        
        XCTAssertEqual(sut.map().count, 2)
    }
    
    func test_map_whereAllTransactionsContainingAllDifferentTicker() {
        sut = makeSUTWithFourDifferentTickers()
        
        XCTAssertEqual(sut.map().count, 4)
    }
    
    // MARK: - Fileprivate Helper Methods
    
    fileprivate func makeSUTWithSameTickers() -> HoldingMapper {
        let transactions = [
            TransactionViewModel(ticker: "FB", shares: 1, tradePrice: 1, currentPrice: 2),
            TransactionViewModel(ticker: "FB", shares: 1, tradePrice: 2, currentPrice: 2),
        ]
        
        return HoldingMapper(transactions: transactions)
    }
    
    fileprivate func makeSUTWithTwoDifferentTickers() -> HoldingMapper {
        let transactions = [
            TransactionViewModel(ticker: "AAPL", shares: 1, tradePrice: 1, currentPrice: 1),
            TransactionViewModel(ticker: "FB", shares: 1, tradePrice: 1, currentPrice: 2),
            TransactionViewModel(ticker: "FB", shares: 1, tradePrice: 2, currentPrice: 2),
        ]
        
        return HoldingMapper(transactions: transactions)
    }
    
    fileprivate func makeSUTWithFourDifferentTickers() -> HoldingMapper {
        let transactions = [
            TransactionViewModel(ticker: "AAPL", shares: 1, tradePrice: 1, currentPrice: 1),
            TransactionViewModel(ticker: "FB", shares: 1, tradePrice: 1, currentPrice: 2),
            TransactionViewModel(ticker: "ZM", shares: 1, tradePrice: 2, currentPrice: 2),
            TransactionViewModel(ticker: "GE", shares: 1, tradePrice: 2, currentPrice: 2),
            TransactionViewModel(ticker: "GE", shares: 1, tradePrice: 2, currentPrice: 2),
        ]
        
        return HoldingMapper(transactions: transactions)
    }
}
