//
//  ScreenerPersistenceServiceTests.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 2/15/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class ScreenerPersistenceServiceTests: XCTestCase {
    
    var sut: ScreenerPersistenceService!

    override func setUp() {
        super.setUp()
        sut = ScreenerPersistenceService()
    }

    func testMappedSearchParameters() {
//        let input = ["revenuegrowth~gte~0.02", "industry_category~contains~defense", "pricetoearnings~lt~50"]
        
        sut.mapValueComponents(from: "revenuegrowth~gte~0.02")
        sut.mapStringComponents(from: "industry_category~contains~defense")
    }
}
