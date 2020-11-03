//
//  DragController.swift
//  UpfulTests
//
//  Created by Yanik Simpson on 7/10/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import XCTest
@testable import Upful

class DragControllerTests: XCTestCase {
    
    var sut: DragController!
    
    override func setUpWithError() throws {
        let config = DragController.DragStateConfiguration(closedHeight: 50, partialHeight: 200, fullHeight: 700)
        sut = DragController(configuration: config)
    }
    
    func test_changePresentationStateFromVelocity() {
        sut.changeState(at: 0)
        XCTAssertEqual(sut.currentPresentationState, .closed)
        
        sut.changeState(at: 700)
        XCTAssertEqual(sut.currentPresentationState, DragViewPresentationState.partial)
        
        sut.changeState(at: 850)
        XCTAssertEqual(sut.currentPresentationState, DragViewPresentationState.full)
        
        sut.changeState(at: 1000)
        XCTAssertEqual(sut.currentPresentationState, DragViewPresentationState.full)
    }
    
    func test_changePresentationStateDecreaseFromVelocity() {
        sut.currentPosition = 2
        
        sut.changeState(at: 0)
        XCTAssertEqual(sut.currentPresentationState, .full)
        
        sut.changeState(at: -700)
        XCTAssertEqual(sut.currentPresentationState, DragViewPresentationState.partial)
        
        sut.changeState(at: -850)
        XCTAssertEqual(sut.currentPresentationState, DragViewPresentationState.closed)
        
        sut.changeState(at: -1000)
        XCTAssertEqual(sut.currentPresentationState, DragViewPresentationState.closed)
    }
    
    func test_fullPositionPresentationFromHeight() {
        sut.changeState(for: 650)
        XCTAssertEqual(sut.currentPresentationState, .full)
        
        sut.changeState(for: 700)
        XCTAssertEqual(sut.currentPresentationState, .full)
        
        sut.changeState(for: 500)
        XCTAssertEqual(sut.currentPresentationState, .full)
        
        
        sut.changeState(for: 250)
        XCTAssertEqual(sut.currentPresentationState, .partial)
        
        sut.changeState(for: 100)
        XCTAssertEqual(sut.currentPresentationState, .closed)
        
        sut.changeState(for: 100)
        XCTAssertEqual(sut.currentPresentationState, .closed)
        
        sut.changeState(for: 65)
        XCTAssertEqual(sut.currentPresentationState, .closed)
        
        
        sut.changeState(for: 250)
        XCTAssertEqual(sut.currentPresentationState, .partial)
        
        sut.changeState(for: 275)
        XCTAssertEqual(sut.currentPresentationState, .partial)
        
        sut.changeState(for: 175)
        XCTAssertEqual(sut.currentPresentationState, .partial)
    }
}
