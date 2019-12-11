//
//  HomePersistenceManager.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 12/5/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class HomePersistenceManagerTest: XCTestCase {

    var sut: HomePersistenceManager!
    
    override func setUp() {
        sut = HomePersistenceManager()
    }

    override func tearDown() {
        sut = nil
    }

    func test_getParameter() {
        
    }
}
