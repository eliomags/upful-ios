//
//  StockComparisonViewModelTests.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 7/24/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class StockComparisonViewModelTests: XCTestCase {
    
    func test_loadResultsOnInit() {
        let sut = makeSUT()
        let exp = expectation(description: #function)
        sut.loadCompletionHandler.subscribe { _ in exp.fulfill() }

        wait(for: [exp], timeout: 0.5)
        XCTAssertEqual(sut.mainTicker, "TEST")
        XCTAssertNil(sut.secondTicker)
        XCTAssertFalse(sut.mainTickerResults.isEmpty)
        XCTAssertTrue(sut.secondTickerResults.isEmpty)
    }
    
    func test_fetchMainTickerResultsOnMainTickerChange() {
        let sut = makeSUT()
        let exp = expectation(description: #function)
        exp.expectedFulfillmentCount = 2
        sut.loadCompletionHandler.subscribe { _ in exp.fulfill() }
        
        sut.mainTicker = "TEST2"
        
        wait(for: [exp], timeout: 0.5)
        XCTAssertEqual(sut.mainTicker, "TEST2")
        XCTAssertFalse(sut.mainTickerResults.isEmpty)
    }
    
    func test_fetchSecondTickerResultsOnSecondTickerChange() {
        let sut = makeSUT()
        let exp = expectation(description: #function)
        exp.expectedFulfillmentCount = 2
        sut.loadCompletionHandler.subscribe { _ in exp.fulfill() }

        sut.secondTicker = "2TEST"
        
        wait(for: [exp], timeout: 0.5)
        XCTAssertEqual(sut.secondTicker, "2TEST")
        XCTAssertFalse(sut.secondTickerResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> StockComparisonViewModel {
        let fetch: StockComparisonViewModel.MetricDataFetch = getResultsForTickerTEST
        let sut = StockComparisonViewModel(mainTicker: "TEST", fetching: fetch)
        return sut
    }
    
    func getResultsForTickerTEST(
            ticker: String,
            financialFrequency: FinancialsFrequency,
            financial: SearchCriteria,
            completion: @escaping (Result<[CompanyHistoricalDatum], NetworkError>) -> Void) {
        DispatchQueue.main.async {
            completion(.success([CompanyHistoricalDatum(date: "7/24/20", value: 200)]))
        }
    }
}
