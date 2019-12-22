//
//  SavedStocksViewModelTest.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 12/22/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class SavedStocksViewModelTest: XCTestCase {
    
    var sut: SavedStockVCViewModel?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testStateAfterInitialized() {
        sut = makeSUTwithData()
        let initialState = SavedStockVCViewModel.State.new
        XCTAssertEqual(sut!.state, initialState)
        XCTAssertTrue(sut!.stocks.isEmpty)
    }
    
    func testStateLoading() {
        sut = makeSUTnoData()
        let initialState = SavedStockVCViewModel.State.loading
        
        sut!.loadSavedStocks()
        
        XCTAssertEqual(sut!.state, initialState)
        XCTAssertTrue(sut!.stocks.isEmpty)
    }
    
    func testLoadDataWithNoSavedStocks() {
        sut = makeSUTnoData()
        let loadExpectation = expectation(description: #function)
        
        sut!.sendStateUpdates = { newState in
            switch newState {
            case .empty:
                loadExpectation.fulfill()
            default:
                break
            }
        }
        sut!.loadSavedStocks()
        
        wait(for: [loadExpectation], timeout: 1)
        
        XCTAssertEqual(sut!.state, SavedStockVCViewModel.State.empty)
        XCTAssertEqual(sut!.stocks.count, 0)
    }
    
    func testLoadedStateWithData() {
        sut = makeSUTwithData()
        let loadExpectation = expectation(description: #function)
        
        sut!.sendStateUpdates = { newState in
            switch newState {
            case .loaded:
                loadExpectation.fulfill()
            default:
                break
            }
        }
        sut!.loadSavedStocks()
        
        wait(for: [loadExpectation], timeout: 1)
        
        XCTAssertEqual(sut!.state, SavedStockVCViewModel.State.loaded)
        XCTAssertEqual(sut!.stocks.count, 2)
    }
    
    func testRemoveTickerWithData() {
        sut = makeSUTwithData()

        sut!.loadSavedStocks()
        
        XCTAssertEqual(sut!.stocks.count, 2)
        
        let tickerToRemove = sut!.stocks.first!.ticker
        sut!.removeTicker(tickerToRemove)
        XCTAssertEqual(sut!.stocks.count, 1)
    }
    
    // TODO: - Test Load Operations
    
    
    // MARK: - Fileprivate Functions
    
    fileprivate func makeSUTnoData() -> SavedStockVCViewModel {
        let mock = MockSavedStockDataManager()
        let vm = SavedStockVCViewModel(savedStockDataManager: mock)
        return vm
    }
    
    fileprivate func makeSUTwithData() -> SavedStockVCViewModel {
        let mock = MockSavedStockDataManagerWithData()
        let vm = SavedStockVCViewModel(savedStockDataManager: mock)
        return vm
    }
}

private class MockSavedStockDataManager: SavedStockDataManagerProtocol {
    func loadSavedStocks(completion: @escaping MockSavedStockDataManager.SavedStockFetchCompletion) {
        DispatchQueue.global().async {
            completion(Result {
                return []
            })
        }
    }
    func saveCompany(ticker: String, companyName: String) {}
    func removeFavoriteCompany(_ ticker: String, completion: (() -> Void)?) {}
}

private class MockSavedStockDataManagerWithData: SavedStockDataManagerProtocol {
    func loadSavedStocks(completion: @escaping MockSavedStockDataManager.SavedStockFetchCompletion) {
        DispatchQueue.global().async {
            completion(Result {
                return [
                    Stock(name: "Apple", ticker: "AAPL"),
                    Stock(name: "Facebook", ticker: "FB")
                ]
            })
        }
    }
    func saveCompany(ticker: String, companyName: String) {}
    func removeFavoriteCompany(_ ticker: String, completion: (() -> Void)?) {}
}
