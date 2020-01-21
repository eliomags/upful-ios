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
    
    private let remoteScreenerLoader: RemoteScreenerLoaderProtocol
    
    // MARK: - State
    
    private(set) var popularScreenerViewModels: [ScreenerViewModel] = []
    private(set) var screenerViewModels: [ScreenerViewModel] = []
    private(set) var state: ViewControllerState = .waiting {
        didSet {
            sendStateUpdates?(state)
        }
    }
    
    var sendStateUpdates: ((ViewControllerState) -> Void)?
    
    // MARK: - Initializer
    
    init(remoteScreenerLoader: RemoteScreenerLoaderProtocol = RemoteScreenerLoader()) {
        self.remoteScreenerLoader = remoteScreenerLoader
    }
    
    // MARK: - API
    
    func loadScreeners() {
        state = .loading
        getRemoteScreeners()
    }
    
    fileprivate func getRemoteScreeners() {
        remoteScreenerLoader.load { (result) in
            switch result {
            case .success(let vms):
                self.handleLoadingSuccess(viewModels: vms)
            case .failure(_):
                self.handleLoadingError()
            }
        }
    }
    
    func getPopularScreeners(retrievedScreeners: [ScreenerViewModel]) {
        if retrievedScreeners.count > 3 {
            let sortedScreeners = retrievedScreeners.sorted(by: { $0.interest > $1.interest })
            let topScreeners = Array(sortedScreeners[0...2])
            let restOfScreeners = Array(sortedScreeners[3...]).shuffled()
            popularScreenerViewModels = topScreeners
            screenerViewModels = restOfScreeners
        } else {
            screenerViewModels = retrievedScreeners
        }
    }
    
    func incrementScreenerInterest(at indexPath: IndexPath) {
        let section = indexPath.section
        var docID = ""
        
        if section == PrebuiltScreenerViewController.Section.popular.rawValue {
            docID = popularScreenerViewModels[indexPath.row].documentID ?? ""
        }
        if section == PrebuiltScreenerViewController.Section.all.rawValue {
            docID = screenerViewModels[indexPath.row].documentID ?? ""
        }
        RemoteScreenerLoader.incrementScreenerInterest(documentID: docID)
    }
    
    
    fileprivate func handleLoadingSuccess(viewModels: [ScreenerViewModel]) {
        getPopularScreeners(retrievedScreeners: viewModels)
        state = .loaded
    }
    
    fileprivate func handleLoadingError() {
        state = .error
    }
}

