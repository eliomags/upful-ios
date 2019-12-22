//
//  StockSuggestionVCTest.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 10/12/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class SuggestionViewModelTest: XCTestCase {
    
    var sut: SuggestionViewModel!
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
        preferenceManager.save()
        // when initialized
        sut = SuggestionViewModel(dataManager: preferenceManager)
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
        preferenceManager.save()
        // when initialized
        sut = SuggestionViewModel(dataManager: preferenceManager)
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
        preferenceManager.save()
        // when initialized
        sut = SuggestionViewModel(dataManager: preferenceManager)
        print(sut.groupedPreferences)
        // then
        XCTAssertEqual(sut.groupedPreferences.count, 3)
    }
    
    // MARK: - Setting State
    
    func testInit_initialState() {
        initializeSystemUnderTest()
        
        let state = sut.state

        // then
        XCTAssertEqual(state, SuggestionViewModel.State.isLoading)
    }
    
        // This test case could be improved by injecting
    func testInit_setState_loading() {
        // given added Data
        initializeSystemUnderTest()
        let state = sut.state
        // then
        XCTAssertEqual(state, SuggestionViewModel.State.isLoading)
    }
    
//    func testInit_setState_empty() {
//        // when initialized with no gset preferences
//        sut = SuggestionViewModel(dataManager: preferenceManager, networkingAPI: IntrinioMock())
//        // then
//        XCTAssertEqual(sut.state, SuggestionViewModel.State.noPreferencesSet)
//    }
    
    
    
    // MARK: - Helper
    
    private func initializeSystemUnderTest() {
        // given added Data
        preferenceManager.update(.computerSoftware)
        preferenceManager.update(.computerHardware)
        preferenceManager.update(.electronics)
        preferenceManager.update(.growthAny)
        preferenceManager.update(.profitabilityAny)
        preferenceManager.update(.dividendAny)
        preferenceManager.save()

        // when initialized
        sut = SuggestionViewModel(dataManager: preferenceManager, networkingAPI: IntrinioMock())
    }
    
    class IntrinioMock: StockScreenNetworkingProtocol {
        var testParameter: String = ""
                
        func screenForPreferences(parameters: String, completion: @escaping (Result<[Stock], NetworkingError>) -> Void) {
            let returnStocks: [Stock] = []
            print("function called")
            completion(.success(returnStocks))
        }
    }
}
