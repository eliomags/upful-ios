//
//  SavedScreenersViewModelTest.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 12/25/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class SavedScreenersViewModelTest: XCTestCase {
    
    var sut: SavedScreenersViewModel!

    override func setUp() {
    }

    override func tearDown() {
        sut = nil
    }
    
    // MARK: - Load Screener
    
    func testStateAfterInitialized() {
        sut = makeSUTwithEmptyData()
        XCTAssertEqual(sut!.state, SavedScreenersViewModel.State.new)
        XCTAssertTrue(sut!.screeners.isEmpty)
    }
    
    func testLoadWithEmpty() {
        sut = makeSUTwithEmptyData()
        let expected = expectation(description: #function)
        
        sut.sendStateChanges = { (newState) in
            switch newState {
            case .empty:
                expected.fulfill()
            default: break
            }
        }
        sut.loadScreeners()
        
        wait(for: [expected], timeout: 1)
        XCTAssertEqual(sut!.state, SavedScreenersViewModel.State.empty)
        XCTAssertTrue(sut!.screeners.isEmpty)
    }
    
    func testLoadWithData() {
        sut = makeSUTwithData()
        let expected = expectation(description: #function)
        
        sut.sendStateChanges = { (newState) in
            switch newState {
            case .loaded:
                expected.fulfill()
            default: break
            }
        }
        sut.loadScreeners()
        
        wait(for: [expected], timeout: 1)
        XCTAssertEqual(sut!.state, SavedScreenersViewModel.State.loaded)
        XCTAssertTrue(!sut!.screeners.isEmpty)
    }
    
    func testLoadWithError() {
        sut = makeSUTwithError()
        let expected = expectation(description: #function)
        
        sut.sendStateChanges = { (newState) in
            switch newState {
            case .error:
                expected.fulfill()
            default: break
            }
        }
        sut.loadScreeners()
        
        wait(for: [expected], timeout: 1)
        XCTAssertEqual(sut!.state, SavedScreenersViewModel.State.error)
        XCTAssertTrue(sut!.screeners.isEmpty)
    }

    // MARK: - Remove Screener

    func testRemoveScreener() {
        sut = makeSUTwithData()
        sut!.screeners = [
            Screener(title: "No Title1", description: "test description1",
                     urlComponents: [], symbol: "",
                     colorMap: "", id: "test1"),
            Screener(title: "No Title2", description: "test description2",
                     urlComponents: [], symbol: "",
                     colorMap: "", id: "test2")
        ]
        
        XCTAssertEqual(sut!.screeners.count, 2)

        sut!.removeScreener("test1")
        XCTAssertEqual(sut!.screeners.count, 1)
        
        sut!.removeScreener("test2")
        sut!.refreshState()
        XCTAssertEqual(sut!.screeners.count, 0)
        XCTAssertEqual(sut!.state, SavedScreenersViewModel.State.empty)
    }

    // MARK: - Helpers
    
    fileprivate func makeSUTwithEmptyData() -> SavedScreenersViewModel {
        let screenerLoader = MockSavedScreenerLoaderEmpty()
        return SavedScreenersViewModel(savedScreenerLoader: screenerLoader)
    }
    
    fileprivate func makeSUTwithData() -> SavedScreenersViewModel {
        let screenerLoader = MockSavedScreenerLoaderLoaded()
        return SavedScreenersViewModel(savedScreenerLoader: screenerLoader)
    }
    
    fileprivate func makeSUTwithError() -> SavedScreenersViewModel {
        let screenerLoader = MockSavedScreenerLoaderError()
        return SavedScreenersViewModel(savedScreenerLoader: screenerLoader)
    }
}

private class MockSavedScreenerLoaderEmpty: LocalScreenerLoaderProtocol {
    func load(completion: @escaping SavedScreenerLoadingCompletion) {
        DispatchQueue.global().async {
            completion(Result {
                return []
            })
        }
    }
    func removeScreenerParameters(with title: String) {}
    func delete(with title: String) {}
    func save(screener: Screener) {}
}
private class MockSavedScreenerLoaderLoaded: LocalScreenerLoaderProtocol {
    func load(completion: @escaping SavedScreenerLoadingCompletion) {
        DispatchQueue.global().async {
            completion(Result {
                return [
                    Screener(title: "No Title1", description: "test description1",
                             urlComponents: [], symbol: "",
                             colorMap: "", id: "test1"),
                    Screener(title: "No Title2", description: "test description2",
                             urlComponents: [], symbol: "",
                             colorMap: "", id: "test2")
                ]
            })
        }
    }
    func removeScreenerParameters(with title: String) {}
    func delete(with title: String) {}
    func save(screener: Screener) {}
}
private class MockSavedScreenerLoaderError: LocalScreenerLoaderProtocol {
    func load(completion: @escaping SavedScreenerLoadingCompletion) {
        DispatchQueue.global().async {
            completion(.failure(NSError()))
        }
    }
    func removeScreenerParameters(with title: String) {}
    func delete(with title: String) {}
    func save(screener: Screener) {}
}
