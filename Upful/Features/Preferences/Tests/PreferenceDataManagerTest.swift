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
    
    
    override func setUp() {
        sut = PreferenceDataManager()
    }

    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    
    func testInit_data() {
        XCTAssertNotEqual(sut.data.count, 0)
    }

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
                        "dividendyield~gt~0.25"])
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
        XCTAssertEqual(industries, ["industry_category~eq~Automotive",
                                    "industry_category~eq~Computer Hardware"])
    }
    
}
