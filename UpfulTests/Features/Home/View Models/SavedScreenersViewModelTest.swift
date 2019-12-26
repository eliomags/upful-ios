//
//  SavedScreenersViewModelTest.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 12/25/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import XCTest
import CoreData
@testable import Upful

class SavedScreenersViewModelTest: XCTestCase {
    
    var sut: SavedScreenersViewModel!

    override func setUp() {
    }

    override func tearDown() {
        sut = nil
    }
    
    // MARK: - Init
    
    func testStateAfterInitialized() {
        sut = makeSUTwithEmptyData()
        XCTAssertEqual(sut!.state, SavedScreenersViewModel.State.new)
        XCTAssertTrue(sut!.screeners.isEmpty)
    }
    
    func testEmptyState() {
        sut = makeSUTwithEmptyData()
        
        sut.loadScreeners()
        
        XCTAssertEqual(sut!.state, SavedScreenersViewModel.State.empty)
        XCTAssertTrue(sut!.screeners.isEmpty)
    }
    
    func testLoadedState() {
        sut = makeSUTwithData()
        
        sut.loadScreeners()
        
        XCTAssertEqual(sut!.state, SavedScreenersViewModel.State.loaded)
        XCTAssertTrue(!sut!.screeners.isEmpty)
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

}

private class MockSavedScreenerLoaderEmpty: SavedScreenerLoaderProtocol {
    func loadSavedScreeners(completion: @escaping SavedScreenerLoadingCompletion) {
        DispatchQueue.global().async {
            completion(Result {
                return []
            })
        }
    }
    func removeScreenerParameters(with title: String) {}
    func removeScreener(with title: String) {}
    func saveScreener(screener: Screener) {}
}

private class MockSavedScreenerLoaderLoaded: SavedScreenerLoaderProtocol {
    func loadSavedScreeners(completion: @escaping SavedScreenerLoadingCompletion) {
        DispatchQueue.global().async {
            completion(Result {
                let entity = NSEntityDescription()
                entity.name = "SavedScreener"
                return [
                
                ]
            })
        }
    }
    func removeScreenerParameters(with title: String) {}
    func removeScreener(with title: String) {}
    func saveScreener(screener: Screener) {}
}
