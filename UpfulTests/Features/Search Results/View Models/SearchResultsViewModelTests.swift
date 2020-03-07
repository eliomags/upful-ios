//
//  SearchResultsViewModelTests.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 2/26/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

fileprivate final class MockViewModelDelegate: SearchResultsViewModelDelegate {
    func didCompleteStockFetch(fetchedStocks: [Stock]) {

    }
    
    func didFailStockFetch(with error: NetworkError, for stock: Stock?) {

    }
    
    var calledFailScreenerSave = false
    var calledCompletedScreenerSave = false
    
    func didCompleteScreenerSave() {
        calledCompletedScreenerSave = true
    }
    func didFailScreenerSave() {
        calledFailScreenerSave = true
    }
}

class SearchResultsViewModelTests: XCTestCase {

    var sut: SearchResultsViewModel!
    fileprivate var vmDelegate: MockViewModelDelegate!
    
    override func setUp() {
        sut = makeSUT()
        vmDelegate = MockViewModelDelegate()
        sut.delegate = vmDelegate
    }
    
    func testHandleSaveCompletionWithSavePermission() {
        sut.saveScreenerPermission = { (permissionResult) in permissionResult(true) }
        
        sut.handleSaveCompletion(with: "")
         
        XCTAssertTrue(vmDelegate.calledCompletedScreenerSave)
    }
    
    func testHandleSaveCompletionWithDeniedPermission() {
        sut.saveScreenerPermission = { (permissionResult) in permissionResult(false) }
        
        sut.handleSaveCompletion(with: "")
        
        XCTAssertTrue(vmDelegate.calledFailScreenerSave)
    }
    
    func testCheckIfScreenerCurrentlySaved() {
        sut.checkIfScreenerCurrentlySaved { (isCurrentlySaved) in
            XCTAssertFalse(isCurrentlySaved)
        }
        
        sut.screener = ScreenerViewModel(title: "", description: "", searchParameters: [], interest: 0, documentID: "Test2", colorMap: [:], symbol: "")
        sut.checkIfScreenerCurrentlySaved { (isCurrentlySaved) in
            XCTAssertTrue(isCurrentlySaved)
        }
    }
    
    func testScreenForStocks() {
        sut.screenForStocks()
        
        XCTAssertEqual(sut.searchResults.map { $0.ticker },
                       ["FB", "AAPL"])
    }
    
    // MARK: - Fileprivate Functions
    
    fileprivate func makeSUT() -> SearchResultsViewModel {
        let vm = SearchResultsViewModel(
            localScreenerLoader: MockLocalScreenerLoader(),
            stockScreener: MockStockScreener()
        )
        return vm
    }
}

fileprivate class MockStockScreener: StockScreener {
    var screenerPage: Int = 1
    var screenerSortDirection: ScreenerRouter.SortDirection = .descending
    
    func get(router: ScreenerRouter, completion: @escaping StockScreenerRequestCompletion) {
        screenerPage += 1
        let stocks = [
            Stock(name: "Facebook", ticker: "FB"),
            Stock(name: "Apple", ticker: "AAPL")
        ]
        completion(.success(stocks))
    }
}

fileprivate class MockLocalScreenerLoader: LocalScreenerLoaderProtocol {
    func load(completion: @escaping SavedScreenerLoadingCompletion) {
        let screeners = [
            Screener(title: "", description: "", urlComponents: [], symbol: "", colorMap: "", id: "Test1"),
            Screener(title: "", description: "", urlComponents: [], symbol: "", colorMap: "", id: "Test2")
        ]
        completion(.success(screeners))
    }
    func delete(with id: String) {}
    func save(screener: Screener) {}
}
