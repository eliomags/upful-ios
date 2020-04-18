//
//  PieChartViewModelLoader.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 4/17/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class PieChartViewModelLoaderTest: XCTestCase {

    var sut: PieChartViewModelLoader!
    
    
    
    func test_loadViewModels() {
        sut = PieChartViewModelLoader()
        let fbTransaction = TransactionAdapter(ticker: "FB", shares: 5, tradePrice: 100)
        fbTransaction.type = "buy"
        let fbHolding = Holding(ticker: "FB", transactions: [fbTransaction])
        let appleHolding = Holding(ticker: "AAPL",
                                transactions: [TransactionAdapter(ticker: "AAPL", shares: 3, tradePrice: 100)])
        let muHolding = Holding(ticker: "MU",
                                transactions: [TransactionAdapter(ticker: "MU", shares: 10, tradePrice: 100)])
        let googlHolding = Holding(ticker: "GOOGL",
                                transactions: [TransactionAdapter(ticker: "GOOGL", shares: 5, tradePrice: 500)])
        let cash: Double = 16_000
        
        let output = sut.makeViewModels(from:
            [fbHolding, appleHolding, muHolding, googlHolding],
                                        cash: cash)
        XCTAssertEqual(output.map{ $0.title }, ["Cash", "FB", "AAPL", "MU", "GOOGL"])
        for vm in output {
            if vm.title == "Cash" {
                XCTAssertEqual(vm.color, UIColor.systemGreen)
                XCTAssertEqual(vm.value, 16000)
            }
            if vm.title == "FB" {
                XCTAssertEqual(vm.color, UIColor.appAccent3)
//                XCTAssertEqual(vm.value, 500)
            }
            if vm.title == "AAPL" {
                XCTAssertEqual(vm.color, UIColor.appAccent4)
//                XCTAssertEqual(vm.value, 300)
            }
            if vm.title == "MU" {
                XCTAssertEqual(vm.color, UIColor.appAccent5)
//                XCTAssertEqual(vm.value, 1000)
            }
            if vm.title == "GOOGL" {
                XCTAssertEqual(vm.color, UIColor.appAccent3)
//                XCTAssertEqual(vm.value, 2500)
            }
        }
    }
}
