//
//  StockOverviewViewModelTests.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 2/23/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class StockOverviewViewModelTests: XCTestCase {
    
    var sut: StockOverviewViewModel!
    
    override func setUp() {
        sut = makeSUT()
    }

    func test_loadData_with_loadingCompletionHandler() {
        var callCount = 0
        let exp = expectation(description: #function)
        sut.loadingCompletionHandler = {
            callCount += 1
            exp.fulfill()
        }

        sut.loadData()
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(callCount, 1)
    }
    
    func test_loadData_with_loadingCompletionHandler_MultipleCalls() {
        var callCount = 0
        let exp = expectation(description: #function)
        exp.expectedFulfillmentCount = 2
        sut.loadingCompletionHandler = {
            callCount += 1
            exp.fulfill()
        }

        sut.loadData()
        sut.loadData()
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(callCount, 2)
    }

    // MARK: - Helper Methods
    
    fileprivate func makeSUT() -> StockOverviewViewModel {
        let quoteLoader = MockQuoteLoader()
        let financialLoader = MockFinancialLoader()
        let batchLoader = MockBatchFinancialLoader()
        let newsLoader = MockStockNewsLoader()
        let descriptionLoader = MockDescriptionLoader()
        let sut = StockOverviewViewModel(ticker: "FB", companyName: "Facebook",
                               priceLoader: quoteLoader,
                               financialLoader: financialLoader,
                               batchFinancialLoader: batchLoader, 
                               stockNewsLoader: newsLoader,
                               descriptionLoader: descriptionLoader)
        return sut
    }
    
    fileprivate final class MockQuoteLoader: QuoteLoader {
        func load(for ticker: String, completion: @escaping PriceLoaderCompletion) {
            completion(.success(StockQuote(latestPrice: 5, changePercent: -0.4)))
        }
    }
    fileprivate final class MockFinancialLoader: FinancialLoader {
        func getStockFinancials(ticker: String, financialFrequency: FinancialsFrequency, financial: SearchCriteria, completion: @escaping (Result<[CompanyHistoricalDatum], NetworkError>) -> Void) {
            let data = CompanyHistoricalDatum(date: "1/2/20", value: 50)
            completion(.success([data]))
        }
    }
    fileprivate final class MockBatchFinancialLoader: BatchFinancialLoader {
        func fetchStockBatchFinancials(ticker: String, completion: @escaping BatchFinancialLoaderCompletion) {
            let standardizedFin = StandardizedFinancial(dataTag: nil, value: 5)
            completion(.success([standardizedFin]))
        }
    }
    fileprivate final class MockStockNewsLoader: NewsLoaderProtocol {
        func get(router: NewsLoader.Router, completion: @escaping StockNewsCompletion) {
            let news = StockNews(newsUrl: "google.com", imageUrl: "url.com",
                                 title: "title", text: "description",
                                 sourceName: "google.com", date: "1/2/20",
                                 sentiment: "Positive")
            completion(.success([news]))
        }
    }
    fileprivate final class MockDescriptionLoader: DescriptionLoader {
        func loadDescription(for ticker: String, completion: @escaping DescriptionLoaderCompletion) {
            let detail = StockDetail(description: "description", employees: 50,
                                     city: "Los Angeles", state: "CA")
            completion(.success(detail))
        }
    }
}
