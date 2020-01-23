//
//  PermissionManagerTests.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 1/22/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class PermissionManagerTests: XCTestCase {

    var sut: PermissionManager!
    let userDefaultsSuiteName = "permissionManagerTestSuite"
    
    override func tearDown() {
        sut = nil
        UserDefaults().removePersistentDomain(forName: userDefaultsSuiteName)
        super.tearDown()
    }
    
    // MARK: - Free User Test
    
    func testFreeUserSetup() {
        sut = makeSUTWithFreeUser()
        XCTAssertFalse(sut.isPremium)
    }
    
    func testPermissionToSaveStockForFreeUser() {
        sut = makeSUTWithFreeUser()
        
        sut.getSavedStockCount = 0
        sut.getSaveStockPermission { (permissionGranted) in
            XCTAssertTrue(permissionGranted)
        }
        
        sut.getSavedStockCount = 3
        sut.getSaveStockPermission { (permissionGranted) in
            XCTAssertFalse(permissionGranted)
        }
        
        sut.getSavedStockCount = 5
        sut.getSaveStockPermission { (permissionGranted) in
            XCTAssertFalse(permissionGranted)
        }
    }
    
    func testPermissionToSaveScreenerForFreeUser() {
        sut = makeSUTWithFreeUser()
        
        sut.getSavedScreenerCount = 0
        sut.getSaveScreenerPermission { (permissionGranted) in
            XCTAssertTrue(permissionGranted)
        }
        
        sut.getSavedScreenerCount = 1
        sut.getSaveScreenerPermission { (permissionGranted) in
            XCTAssertFalse(permissionGranted)
        }
        
        sut.getSavedScreenerCount = 3
        sut.getSaveScreenerPermission { (permissionGranted) in
            XCTAssertFalse(permissionGranted)
        }
    }
    
    // MARK: - Premium User Test

    func testPremiumUserSetup() {
        sut = makeSUTWithPremiumUser()
        XCTAssertTrue(sut.isPremium)
    }
    
    func testPermissionToSaveStockForPremiumUser() {
        sut = makeSUTWithPremiumUser()
        
        sut.getSavedStockCount = 0
        sut.getSaveStockPermission { (permissionGranted) in
            XCTAssertTrue(permissionGranted)
        }
        
        sut.getSavedStockCount = 3
        sut.getSaveStockPermission { (permissionGranted) in
            XCTAssertTrue(permissionGranted)
        }
        
        sut.getSavedStockCount = 5
        sut.getSaveStockPermission { (permissionGranted) in
            XCTAssertTrue(permissionGranted)
        }
    }
    
    func testPermissionToSaveScreenerForPremiumUser() {
        sut = makeSUTWithPremiumUser()
        
        sut.getSavedScreenerCount = 0
        sut.getSaveScreenerPermission { (permissionGranted) in
            XCTAssertTrue(permissionGranted)
        }
        
        sut.getSavedScreenerCount = 1
        sut.getSaveScreenerPermission { (permissionGranted) in
            XCTAssertTrue(permissionGranted)
        }
        
        sut.getSavedScreenerCount = 3
        sut.getSaveScreenerPermission { (permissionGranted) in
            XCTAssertTrue(permissionGranted)
        }
    }

    // MARK: - Helpers
    
    func makeSUTWithPremiumUser() -> PermissionManager {
        UserDefaults(suiteName: userDefaultsSuiteName)?
            .set(true, forKey: PermissionManager.Constants.UserDefaults.isPremium)
        return PermissionManager(userDefaults: UserDefaults(suiteName: userDefaultsSuiteName)!)
    }
    
    func makeSUTWithFreeUser() -> PermissionManager {
        return PermissionManager(userDefaults: UserDefaults(suiteName: userDefaultsSuiteName)!)
    }
}
