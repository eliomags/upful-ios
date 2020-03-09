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
        textExpectation.expectedFulfillmentCount = 3
        
        sut.updateHandler = { textExpectation.fulfill() }
        sut.loadPreviewData()
        
        wait(for: [textExpectation], timeout: 1)
        XCTAssertEqual(sut.stock.marketcap, 50)
        XCTAssertEqual(sut.stock.pricetoearnings, 50)

        XCTAssertEqual(sut.stock.stockQuote?.latestPrice, 20)
        XCTAssertEqual(sut.stock.stockQuote?.changePercent, 0.02)
    }
    
    func makeSUT() -> StockViewModel {
        let stock = Stock(name: "Facebook", ticker: "FB")
        let stockVM = StockViewModel(stock: stock, quoteLoader: MockQuoteLoader(), stockFinancialLoader: MockFinancialLoader())
        return stockVM
    }
}

fileprivate class MockQuoteLoader: QuoteLoader {
    func load(for ticker: String, completion: @escaping PriceLoaderCompletion) {
        completion(.success(StockQuote(latestPrice: 20, changePercent: 0.02)))
    }
}

fileprivate class MockFinancialLoader: FinancialLoader {
    func getStockFinancials(ticker: String, financialFrequency: FinancialsFrequency,
                            financial: SearchCriteria,
                            completion: @escaping (Result<[CompanyHistoricalDatum], NetworkError>) -> Void) {
        completion(.success([CompanyHistoricalDatum(date: "", value: 50)]))
    }
}
