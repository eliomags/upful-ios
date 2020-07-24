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
        XCTAssertEqual(sut.mainTicker, "TEST")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> StockComparisonViewModel {
        let fetch: StockComparisonViewModel.MetricDataFetch = getResultsForTickerTEST
        let sut = StockComparisonViewModel(mainTicker: "TEST")
        sut.fetch = fetch
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
