//
//  MetricPreviewViewModelTests.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 8/6/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class MetricPreviewViewModelTests: XCTestCase {
    
    var sut: MetricPreviewViewModel!

    override func setUpWithError() throws {
        sut = MetricPreviewViewModel(ticker: "TEST", searchCriteria: .pricetoearnings)
    }

    func testStateOnIntialization() {
        sut.fetchMetricData = Self.fetchEmptyResult
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.historicalData.isEmpty)
        XCTAssertTrue(!sut.activityView.isAnimating)
    }

    // MARK: - Helper
    
    private static func fetchEmptyResult(_ ticker: String, _ freq: FinancialsFrequency, _ criteria: SearchCriteria,
                                         _ completion: (Result<[CompanyHistoricalDatum], NetworkError>) -> Void) {
        completion(.success([]))
    }
    
    private static func fetchDataResult(_ ticker: String, _ freq: FinancialsFrequency, _ criteria: SearchCriteria,
                                        _ completion: (Result<[CompanyHistoricalDatum], NetworkError>) -> Void) {
        completion(.success([.init(date: "2020-05-01", value: 10)]))
    }
    
    private static func fetchWithError(_ ticker: String, _ freq: FinancialsFrequency, _ criteria: SearchCriteria,
                                       _ completion: (Result<[CompanyHistoricalDatum], NetworkError>) -> Void) {
        completion(.failure(.connection))
    }
}
