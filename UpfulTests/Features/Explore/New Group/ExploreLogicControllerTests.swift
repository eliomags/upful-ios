//
//  ExploreLogicControllerTests.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 11/6/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class ExploreLogicControllerTests: XCTestCase {

    var sut: ExploreLogicController!
    
    // MARK: - Initialization

    func testInitialState() {
        sut = makeSUT(mockNewsLoaderType: .withValues, stockSearcherType: .twoValues)
        XCTAssertEqual(sut.state, ExploreLogicController.State.normal, "State should be normal upon initialization.")
    }
    
    // MARK: - Remote Stock Loading
    
    func testPopularStockLoading() {
        sut = makeSUT(mockNewsLoaderType: .withValues, stockSearcherType: .twoValues)
        
        sut.startLoad()
        
        XCTAssertEqual(sut.stockViewModels.map { $0.stock.ticker }, ["FB", "AAPL"])
    }
    
    // TODO: Test Error Case
    
    // MARK: - Remote Screener Loader
    
    func testScreenerLoadingWithSuccessResult() {
        sut = makeSUT(mockNewsLoaderType: .withValues, stockSearcherType: .empty)
        let testExpectation = expectation(description: #function)

        sut.handleCompletion = { testExpectation.fulfill() }
        sut.loadRemoteScreeners()
        
        wait(for: [testExpectation], timeout: 1)
        XCTAssertEqual(sut.screenerViewModels.map { $0.title }, ["Title0", "Title1", "Title2", "Title3"])
    }
    
    // MARK: - News Fetch
    
    func testNewsFetchWithSuccessResult() {
        sut = makeSUT(mockNewsLoaderType: .withValues, stockSearcherType: .empty)
        let testExpectation = expectation(description: #function)
        
        sut.handleCompletion = { testExpectation.fulfill() }
        sut.loadNews()
        
        wait(for: [testExpectation], timeout: 1)
        XCTAssertEqual(sut.marketNewsViewModels.map { $0.title }, ["title1", "title2"])
    }
    
    func testNewsFetchWithErrorResult() {
        sut = makeSUT(mockNewsLoaderType: .error, stockSearcherType: .empty)
        let testExpectation = expectation(description: #function)
        
        sut.handleCompletion = { testExpectation.fulfill() }
        sut.loadNews()
        
        wait(for: [testExpectation], timeout: 1)
        XCTAssertEqual(sut.marketNewsViewModels.map { $0.title }, [])
    }
    
    // MARK: - Search For Manual Company Searcb
    
    func testSearchForCompanyWithSuccessResult() {
        sut = makeSUT(mockNewsLoaderType: .withValues, stockSearcherType: .twoValues)
        let testExpectation = expectation(description: #function)
        
        sut.handleCompletion = { testExpectation.fulfill() }
        sut.searchForCompanies(containing: "A")
        
        wait(for: [testExpectation], timeout: 1)
        XCTAssertEqual(sut.stockSearchDisplay.map { $0.ticker }, ["AAPL", "AMD"])
    }
    
    func testSearchForCompanyWithEmptyResults() {
        sut = makeSUT(mockNewsLoaderType: .withValues, stockSearcherType: .empty)
        let testExpectation = expectation(description: #function)
        
        sut.handleCompletion = { testExpectation.fulfill() }
        sut.searchForCompanies(containing: "A")
        
        wait(for: [testExpectation], timeout: 1)
        XCTAssertEqual(sut.stockSearchDisplay.map { $0.ticker }, [])
    }
    
    // MARK: - Helpers
    
    fileprivate func makeSUT(mockNewsLoaderType: MockNewsLoader.InitType,
                             stockSearcherType: MockStockSearcher.InitType) -> ExploreLogicController {
        let screenerLoader = MockRemoteScreenerLoader()
        let remoteStockLoader = MockRemoteStockLoader()
        let stockSearcher = MockStockSearcher(initType: stockSearcherType)
        let newsLoader = MockNewsLoader(initType: mockNewsLoaderType)
        
        let systemUnderTest = ExploreLogicController(newsLoader: newsLoader,
                                                     remoteStockLoader: remoteStockLoader,
                                                     remoteScreenerLoader: screenerLoader,
                                                     stockSearcher: stockSearcher)
        return systemUnderTest
    }
}

class MockNewsLoader: NewsLoaderProtocol {
    enum InitType {
        case withValues, error
    }
    private let initType: InitType
    
    init(initType: InitType) {
        self.initType = initType
    }
    
    func get(router: NewsLoader.Router, completion: @escaping StockNewsCompletion) {
        switch initType {
        case .withValues:
            completion(.success(handleCompletion()))
        case .error:
            completion(.failure(.connection))
        }
    }
    
    func handleCompletion() -> [StockNews] {
        let news1 = StockNews(newsUrl: "", imageUrl: "", title: "title1", text: "text1", sourceName: "", date: "", sentiment: "")
        let news2 = StockNews(newsUrl: "", imageUrl: "", title: "title2", text: "text2", sourceName: "", date: "", sentiment: "")
        return [news1, news2]
    }
}

class MockRemoteStockLoader: RemoteStockLoaderProtocol {
    func load(completion: @escaping (Result<[Stock], Error>) -> Void) {
        completion(Result {
            let stock1 = Stock(name: "Facebook", ticker: "FB")
            let stock2 = Stock(name: "Apple", ticker: "AAPL")
            
            return [stock1, stock2]
        })
    }
}

class MockStockSearcher: StockSearcherProtocol {
    enum InitType {
        case empty, twoValues, error
    }
    private let initType: InitType

    init(initType: InitType) {
        self.initType = initType
    }
    
    func search(name: String, completion: @escaping (Result<[Company], Error>) -> Void) {
        completion(Result {
            switch initType {
            case .empty:
                return returnEmpty()
            case .twoValues:
                return returnTwoValues()
            default:
                return []
            }
        })
    }
    
    func returnEmpty() -> [Company] {
        return []
    }
    
    func returnTwoValues() -> [Company] {
        let company1 = Company(id: nil, ticker: "AAPL", name: "Apple Inc.", lei: nil, cik: nil, filings: nil)
        let company2 = Company(id: nil, ticker: "AMD", name: "Advanced Micro Devices", lei: nil, cik: nil, filings: nil)
        return [company1, company2]
    }
}




