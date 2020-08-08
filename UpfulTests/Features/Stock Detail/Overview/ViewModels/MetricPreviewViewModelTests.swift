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

    func test_stateOnIntialization() {
        sut.fetchMetricData = Self.fetchEmptyResult
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.historicalData.isEmpty)
        XCTAssertFalse(sut.activityView.isAnimating)
    }
    
    func test_loadingState() {
        sut.fetchMetricData = Self.fetchWithResult

        sut.loadHistoricalData()
        
        XCTAssertTrue(sut.isLoading)
        XCTAssertTrue(sut.historicalData.isEmpty)
        XCTAssertTrue(sut.activityView.isAnimating)
    }
    
    func test_loadCompletion() {
        sut.fetchMetricData = Self.fetchWithResult
        let delegate = DelegateTest()
        sut.delegate = delegate
        
        let exp = expectation(description: #function)
        
        sut.loadHistoricalData()
        
        delegate.completion = { results in
            XCTAssertFalse(results.isEmpty)
            XCTAssertFalse(self.sut.isLoading)
            XCTAssertFalse(self.sut.activityView.isAnimating)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.5)
    }
    
    func test_percentChangeCalculation_positiveToPositive() {
        let percentChange = sut.calculateTotalChange(1, 2)
        XCTAssertEqual(percentChange, "100%")
    }
    
    func test_percentChangeCalculation_positiveToPositiveOverflow() {
        let percentChange = sut.calculateTotalChange(1, 1000)
        XCTAssertEqual(percentChange, "999%")
    }
    
    func test_percentChangeCalculation_negativeToPositive() {
        let percentChange = sut.calculateTotalChange(-1, 2)
        XCTAssertEqual(percentChange, "999%")
    }
    
    func test_percentChangeCalculation_negativeToNegative() {
        let percentChange = sut.calculateTotalChange(-1.5, -3)
        XCTAssertEqual(percentChange, "")
    }
    
    func test_percentChangeCalculation_positiveToNegative() {
        let percentChange = sut.calculateTotalChange(1, -3)
        XCTAssertEqual(percentChange, "-999%")
    }
    
    func test_percentChangeCalculation_zeroToPositive() {
        let percentChange = sut.calculateTotalChange(0, 3)
        XCTAssertEqual(percentChange, "999%")
    }
    
    func test_percentChangeCalculation_zeroToNegative() {
        let percentChange = sut.calculateTotalChange(0, 3)
        XCTAssertEqual(percentChange, "999%")
    }
    
    func test_percentChangeCalculation_positiveToZero() {
        let percentChange = sut.calculateTotalChange(1, 0)
        XCTAssertEqual(percentChange, "-100%")
    }
    
    // MARK: - Helper
    
    class DelegateTest: MetricPreviewViewModelDelegate {
        var completion: (([CompanyHistoricalDatum]) -> Void)?
        func didLoadCellData(cell: MetricPreviewTableViewCell?, with results: [CompanyHistoricalDatum]) {
            completion?(results)
        }
    }
    
    private static func fetchEmptyResult(_ ticker: String, _ freq: FinancialsFrequency, _ criteria: SearchCriteria,
                                         _ completion: (Result<[CompanyHistoricalDatum], NetworkError>) -> Void) {
        completion(.success([]))
    }
    
    private static func fetchWithResult(_ ticker: String, _ freq: FinancialsFrequency, _ criteria: SearchCriteria,
                                        _ completion: (Result<[CompanyHistoricalDatum], NetworkError>) -> Void) {
        completion(.success([.init(date: "2020-05-01", value: 10)]))
    }
    
    private static func fetchWithError(_ ticker: String, _ freq: FinancialsFrequency, _ criteria: SearchCriteria,
                                       _ completion: (Result<[CompanyHistoricalDatum], NetworkError>) -> Void) {
        completion(.failure(.connection))
    }
}
