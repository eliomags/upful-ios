//
//  StockViewModelTests.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 1/12/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class StockViewModelTests: XCTestCase {

    var sut: StockViewModel!
    
    func testInitializer() {
        sut = makeSUT()
        XCTAssertEqual(sut.stock.ticker, "FB")
    }
    
    func testPreviewLoad() {
        sut = makeSUT()
        let textExpectation = expectation(description: #function)
        textExpectation.expectedFulfillmentCount = 2
        
        sut.previewFetchCompletion = { textExpectation.fulfill() }
        sut.loadPreviewData()
        
        wait(for: [textExpectation], timeout: 1)
        XCTAssertEqual(sut.stock.pricetoearnings, 14)
        XCTAssertEqual(sut.stock.marketcap, 50)
    }

    func makeSUT() -> StockViewModel {
        let stock = Stock(name: "Facebook", ticker: "FB")
        let previewLoader = MockStockPreviewLoader()
        let vm = StockViewModel(stock: stock, stockPreviewLoader: previewLoader)
        return vm
    }
}

class MockStockPreviewLoader: StockPreviewLoaderProtocol {
    weak var delegate: StockPreviewLoaderDelegate?
    
    func start() {
        getPriceToEarningsPreviewData()
        getMarketCapPreviewData()
    }
    
    func getPriceToEarningsPreviewData() {
        delegate?.didLoadPriceToEarnings(with: 14)
    }
    
    func getMarketCapPreviewData() {
        delegate?.didLoadMarketcap(with: 50)
    }
}
