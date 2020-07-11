//
//  DragController.swift
//  Upful
//
//  Created by Yanik Simpson on 7/9/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

typealias DragStateConfiguration = DragController.DragStateConfiguration
typealias DragViewPresentationState = DragController.DragViewPresentationState

class DragController {
    
    struct DragStateConfiguration {
        let closedHeight: CGFloat
        let partialHeight: CGFloat
        let fullHeight: CGFloat
    }
    
    @objc enum DragViewPresentationState: Int, CaseIterable {
        case closed
        case partial
        case full
    }
    
    // MARK: Properties
    
    private(set) var configuration: DragStateConfiguration
    
    var currentPresentationState: DragViewPresentationState {
        return DragViewPresentationState.allCases[currentPosition]
    }
    
    var currentPosition: Int = DragViewPresentationState.partial.rawValue {
        didSet {
            presentationStateChangeHandler?(currentPresentationState)
        }
    }
    
    // MARK: Callbacks
    
    var presentationStateChangeHandler: ((DragViewPresentationState) -> Void)?
    
    // MARK: Initializer
    
    init(configuration: DragStateConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: Methods
    
    static let velocityThreshold: CGFloat = 900
    
    func changeState(at velocity: CGFloat) {
        let velocityDidMeetOrExceedThreshold = abs(velocity) >= DragController.velocityThreshold
        
        if velocity > 0 && velocityDidMeetOrExceedThreshold {
            if currentPosition == DragViewPresentationState.allCases.count-1 { return }
            currentPosition = DragViewPresentationState.allCases.count-1
        }
            
        else if velocity < 0 && velocityDidMeetOrExceedThreshold {
            if currentPosition == 0 { return }
            currentPosition = 0
        }
    }
    
    func changeState(for position: CGFloat) {
        let diffFromFull = abs(position - configuration.fullHeight)
        let diffFromPartial = abs(position - configuration.partialHeight)
        let diffFromClose = abs(position - configuration.closedHeight)
        
        let sortedDiffs = [abs(diffFromFull), abs(diffFromPartial), abs(diffFromClose)].sorted()
        
        if sortedDiffs.first! == diffFromFull {
            currentPosition = DragViewPresentationState.full.rawValue
        }
        else if sortedDiffs.first! == diffFromPartial {
            currentPosition = DragViewPresentationState.partial.rawValue
        }
        else if sortedDiffs.first! == diffFromClose {
            currentPosition = DragViewPresentationState.closed.rawValue
        }
    }
}


