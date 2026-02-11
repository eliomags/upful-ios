//
//  SavedStocksViewModelTest.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 12/22/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class SavedStockLogicControllerTests: XCTestCase {
    
    var sut: SavedStockLogicController!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testStateAfterInitialized() {
        sut = makeSUTwithData()
        let initialState = SavedStockLogicController.State.new
        XCTAssertEqual(sut!.state, initialState)
        XCTAssertTrue(sut!.stockViewModels.isEmpty)
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
        
        XCTAssertEqual(sut!.state, SavedStockLogicController.State.empty)
        XCTAssertEqual(sut!.stockViewModels.count, 0)
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
        
        XCTAssertEqual(sut!.state, SavedStockLogicController.State.loaded)
        XCTAssertEqual(sut!.stockViewModels.count, 1)
    }
    
    func testRemoveTickerWithData() {
        sut = makeSUTwithData()
        sut!.loadSavedStocks()
        let tickerToRemove = sut!.stockViewModels.first!.stock.ticker
        
        sut!.removeTicker(tickerToRemove)
        sut!.refreshState()
        
        XCTAssertEqual(sut!.stockViewModels.count, 0)
        XCTAssertEqual(sut!.state, SavedStockLogicController.State.empty)
    }
    
    // TODO: - Test Load Operations
    
    
    // MARK: - Fileprivate Functions
    
    fileprivate func makeSUTnoData() -> SavedStockLogicController {
        let mock = MockSavedStockDataManager()
        let vm = SavedStockLogicController(savedStockDataManager: mock)
        return vm
    }
    
    fileprivate func makeSUTwithData() -> SavedStockLogicController {
        let mock = MockSavedStockDataManagerWithData()
        let vm = SavedStockLogicController(savedStockDataManager: mock)
        return vm
    }
}

class MockSavedStockDataManager: LocalStockDataLoaderProtocol {
    func loadSavedStocks(completion: @escaping SavedStockFetchCompletion) {
        DispatchQueue.global().async {
            completion(Result {
                return []
            })
        }
    }
    func saveCompany(ticker: String, companyName: String) {}
    func removeFavoriteCompany(_ ticker: String, completion: (() -> Void)?) {}
}

class MockSavedStockDataManagerWithData: LocalStockDataLoaderProtocol {
    func loadSavedStocks(completion: @escaping SavedStockFetchCompletion) {
        completion(Result {
            return [
                Stock(name: "Apple", ticker: "AAPL")
            ]
        })
        
    }
    func saveCompany(ticker: String, companyName: String) {}
    func removeFavoriteCompany(_ ticker: String, completion: (() -> Void)?) {}
}
