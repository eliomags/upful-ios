//
//  PrebuiltScreenerLogicControllerTests.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 1/6/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class PrebuiltScreenerLogicControllerTests: XCTestCase {

    var sut: PrebuiltScreenerLogicController!
    var mockScreenerLoader: MockRemoteScreenerLoader!
    
    func testInitialization() {
        sut = makeSUTWithData()
        
        XCTAssertEqual(sut.state, ViewControllerState.waiting)
        XCTAssertTrue(sut.screenerViewModels.isEmpty)
    }
    
    func testLoadScreenersResultingInSuccess() {
        sut = makeSUTWithData()
        let testexpectation = expectation(description: #function)
        
        sut.sendStateUpdates = { (state) in
            if state == .loaded { testexpectation.fulfill() }
        }
        sut.loadScreeners()
        
        wait(for: [testexpectation], timeout: 1)
        XCTAssertEqual(sut.state, ViewControllerState.loaded)
        XCTAssertFalse(sut.screenerViewModels.isEmpty)
    }
    
    func testLoadScreenersWithErrorResult() {
        sut = makeSUTWithError()
        let testexpectation = expectation(description: #function)
        
        sut.sendStateUpdates = { (state) in
            if state == .error { testexpectation.fulfill() }
        }
        sut.loadScreeners()
        
        wait(for: [testexpectation], timeout: 1)
        XCTAssertEqual(sut.state, ViewControllerState.error)
        XCTAssertTrue(sut.screenerViewModels.isEmpty)
    }
    
    
    // MARK: - Helpers
    
    func makeSUTWithData() -> PrebuiltScreenerLogicController {
        let screenerLoader = MockRemoteScreenerLoader()
        return PrebuiltScreenerLogicController(remoteScreenerLoader: screenerLoader)
    }
    func makeSUTWithError() -> PrebuiltScreenerLogicController {
        let screenerLoader = MockRemoteScreenerLoaderError()
        return PrebuiltScreenerLogicController(remoteScreenerLoader: screenerLoader)
    }
}

    // MARK: - Mocks

final class MockRemoteScreenerLoader: RemoteScreenerLoaderProtocol {
    func incrementScreenerInterest(documentID: String) {}
    
    func load(completion: @escaping ScreenerLoadCompletion) {
        DispatchQueue.global().async {
            let vm = ScreenerViewModel(title: "Cash Burn", description: "", imageUrlString: "", searchParameters: [], interest: 0, documentID: "testID")
            completion(Result { return [vm] })
        }
    }
}
final class MockRemoteScreenerLoaderError: RemoteScreenerLoaderProtocol {
    func incrementScreenerInterest(documentID: String) {}
    
    func load(completion: @escaping ScreenerLoadCompletion) {
        DispatchQueue.global().async {
            let error = NSError()
            completion(.failure(error))
        }
    }
}
