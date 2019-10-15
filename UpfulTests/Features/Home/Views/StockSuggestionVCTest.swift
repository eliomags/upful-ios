//
//  StockSuggestionVCTest.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 10/12/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class StockSuggestionViewControllerTest: XCTestCase {
    
    var sut: StockSuggestionViewController!
    var preferenceManager: PreferenceDataManager!

    override func setUp() {
        preferenceManager = PreferenceDataManager()
        preferenceManager.savedPreferences.removeAll()
    }

    override func tearDown() {
        sut = nil
        preferenceManager = nil
        
        super.tearDown()
    }

    // MARK: - Initialzed
    
    func testInit_withOneIndustrySelection() {
        // given added Data
        preferenceManager.update(.automotive)
        preferenceManager.update(.growthAny)
        preferenceManager.update(.profitabilityLow)
        preferenceManager.update(.dividendAny)
        
        // when initialized
        sut = StockSuggestionViewController(dataManager: preferenceManager)
        // then
        XCTAssertEqual(sut.groupedPreferences.count, 1)
    }
    
    func testInit_withTwoIndustrySelection() {
        // given added Data
        preferenceManager.update(.automotive)
        preferenceManager.update(.computerHardware)
        preferenceManager.update(.growthAny)
        preferenceManager.update(.profitabilityLow)
        preferenceManager.update(.dividendAny)
        
        // when initialized
        sut = StockSuggestionViewController(dataManager: preferenceManager)
            // then
        XCTAssertEqual(sut.groupedPreferences.count, 2)
    }
    
    func testInit_withThreeIndustrySelection() {
        // given added Data
        preferenceManager.update(.computerSoftware)
        preferenceManager.update(.computerHardware)
        preferenceManager.update(.electronics)
        preferenceManager.update(.growthAny)
        preferenceManager.update(.profitabilityAny)
        preferenceManager.update(.dividendAny)
        
        // when initialized
        sut = StockSuggestionViewController(dataManager: preferenceManager)
        print(sut.groupedPreferences)
        // then
        XCTAssertEqual(sut.groupedPreferences.count, 3)
    }
    
    // MARK: - State
    
    func testInit_initialState() {
        initializeSystemUnderTest()
        
        let state = sut.state

        // then
        XCTAssertEqual(state, StockSuggestionViewController.State.pending)
    }
    
        // This test case could be improved by injecting
    func testInit_loadedState() {
        // given added Data
        initializeSystemUnderTest()
        
        sut.viewDidLoad()
        let state = sut.state
        // then
        XCTAssertEqual(state, StockSuggestionViewController.State.isLoading)
    }
    
    
    
    
    // MARK: - Helper
    
    private func initializeSystemUnderTest() {
        // given added Data
        preferenceManager.update(.computerSoftware)
        preferenceManager.update(.computerHardware)
        preferenceManager.update(.electronics)
        preferenceManager.update(.growthAny)
        preferenceManager.update(.profitabilityAny)
        preferenceManager.update(.dividendAny)
        
        // when initialized
        sut = StockSuggestionViewController(dataManager: preferenceManager,networkingAPI: IntrinioMock())
    }
    
    
    class IntrinioMock: StockScreenNetworkingProtocol {
        enum TestParameter: String {
            case empty
            case value
            case error
        }
        var testParameter: String = ""
                
        func screenForPreferences(parameters: String, completion: @escaping (Result<[Stock], NetworkingError>) -> Void) {
            let returnStocks: [Stock] = []
            completion(.success(returnStocks))
            
        }
    }

}
