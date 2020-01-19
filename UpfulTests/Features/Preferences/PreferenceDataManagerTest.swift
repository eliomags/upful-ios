//
//  PreferenceDataManagerTest.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 10/11/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class PreferenceDataManagerTest: XCTestCase {
    
    var sut: PreferenceDataManager!
    let userDefaultsSuiteName = "TestDefaults"
    
    override func setUp() {
        sut = PreferenceDataManager(userDefaults: UserDefaults(suiteName: userDefaultsSuiteName)!
            , dataLoader: .init())
        sut.savedPreferences.removeAll()
    }

    override func tearDown() {
        sut = nil
        UserDefaults().removePersistentDomain(forName: userDefaultsSuiteName)
        super.tearDown()
    }
    
    func testInit_data() {
        XCTAssertNotEqual(sut.data.count, 0)
    }
    
    // MARK: - Protocol Methods

    func test_updatePreferences() {
        // given
        let preferenceCount = sut.savedPreferences.count
        // when
        sut.update(.automotive)
        // then
        XCTAssertEqual(sut.savedPreferences.count,
                       preferenceCount + 1)
    }
    
    func test_removePreference() {
        // given
        let preferenceCount = sut.savedPreferences.count
        // when
        sut.update(.automotive)
        sut.remove(.automotive)
        // then
        XCTAssertEqual(sut.savedPreferences.count,
                       preferenceCount)
    }
    
    func test_getParametersForNetworking() {
        // given
        sut.update(.automotive)
        sut.update(.growthAny)
        sut.update(.computerHardware)
        sut.update(.dividendHigh)
        // when
        let networkingParameters = sut.getParametersForNetworking()
        // then
        XCTAssertEqual(networkingParameters,
                       ["revenuegrowth~gt~0",
                        "dividendyield~gt~0.03"])
    }
    
    func test_getIndustriesForNetworking() {
        // given
        sut.update(.automotive)
        sut.update(.growthAny)
        sut.update(.computerHardware)
        sut.update(.dividendHigh)

        // when
        let industries = sut.getIndustriesForNetworking()
        
        // then
        XCTAssertEqual(industries, ["industry_category~contains~Automotive",
                                    "industry_category~contains~Computer Hardware"])
    }
    
    func test_getAllStringsForNetworking_withOneIndustry() {
        // when
        sut.update(.automotive)
        sut.update(.profitabilityLow)
        sut.update(.growthAny)
        sut.update(.dividendHigh)
        
        sut.save()
        
        // then
        let networkingStrings = sut.getGroupedPreferences()
        XCTAssertEqual(networkingStrings.count, 1)
    }
    
    func test_getAllStringsForNetworking_withTwoIndustry() {
        // when
        sut.update(.automotive)
        sut.update(.industryRetail)
        sut.update(.profitabilityLow)
        sut.update(.growthAny)
        sut.update(.dividendHigh)
        
        sut.save()

        // then
        let networkingStrings = sut.getGroupedPreferences()
        XCTAssertEqual(networkingStrings.count, 2)
    }
    
    func test_getAllStringsForNetworking_withThreeIndustry() {
        // when
        sut.update(.automotive)
        sut.update(.industryRetail)
        sut.update(.defense)
        sut.update(.profitabilityLow)
        sut.update(.growthAny)
        sut.update(.dividendHigh)
        
        sut.save()

        // then
        let networkingStrings = sut.getGroupedPreferences()
        XCTAssertEqual(networkingStrings.count, 3)
    }
    
    func test_save_and_dataFetch_notEmpty() {
        // given
        sut.update(.automotive)
        sut.save()
        // when user data is removed and fetched using user defaults
        sut.data.removeAll()
        sut.savedPreferences.removeAll()
        sut.fetchRecent()
        // then
        XCTAssertTrue(!(sut.savedPreferences.isEmpty))
    }
    
}
