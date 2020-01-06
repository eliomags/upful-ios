//
//  PrebuiltScreenerLogicController.swift
//  Upful
//
//  Created by Yanik Simpson on 1/6/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

enum ViewControllerState {
    case waiting
    case loading
    case loaded
    case error
}

class PrebuiltScreenerLogicController {
    
    // MARK: - Dependencies
    
    private let screenerLoader: RemoteScreenerLoaderProtocol
    
    // MARK: - State
    
    private(set) var screenerViewModels: [ScreenerViewModel] = []
    private(set) var state: ViewControllerState = .waiting {
        didSet {
            sendStateUpdates?(state)
        }
    }
    
    var sendStateUpdates: ((ViewControllerState) -> Void)?
    
    // MARK: - Initializer
    
    init(screenerLoader: RemoteScreenerLoaderProtocol = RemoteScreenerLoader()) {
        self.screenerLoader = screenerLoader
    }
    
    // MARK: - API
    
    func loadScreeners() {
        screenerLoader.load { (result) in
            switch result {
            case .success(let vms):
                self.handleLoadingSuccess(viewModels: vms)
            case .failure(_):
                self.handleLoadingError()
            }
        }
    }
    
    fileprivate func handleLoadingSuccess(viewModels: [ScreenerViewModel]) {
        screenerViewModels = viewModels
        state = .loaded
    }
    
    fileprivate func handleLoadingError() {
        state = .error
    }
    
}

