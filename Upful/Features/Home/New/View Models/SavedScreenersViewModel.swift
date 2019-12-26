//
//  SavedScreenersViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 12/22/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

class SavedScreenersViewModel {
    
    // MARK: - Depenedencies
    
    let savedScreenerLoader: SavedScreenerLoaderProtocol
    
    
    // MARK: - State
    
    enum State {
        case new, loading, loaded, error, empty
    }
    
    var screeners: [Screener] = []
    
    private(set) var state: State = .new {
        didSet {
            sendStateChanges?(state)
        }
    }
    var sendStateChanges: ((State) -> Void)?
    
    
    init(savedScreenerLoader: SavedScreenerLoaderProtocol = SavedScreenerLoader()) {
        self.savedScreenerLoader = savedScreenerLoader
    }
    
    
    // MARK: -
    
    func loadScreeners() {
        state = .loading
        savedScreenerLoader.loadSavedScreeners { (result) in
            switch result {
            case .success(let screeners):
                self.screeners = screeners
                self.refreshState()
            case .failure(_):
                self.state = .error
            }
        }
    }
    
    func refreshState() {
        state = screeners.isEmpty ? .empty: .loaded
    }
    
    func removeScreener(_ title: String) {
        screeners.removeAll(where: { $0.title == title })
        savedScreenerLoader.removeScreenerParameters(with: title)
        savedScreenerLoader.removeScreener(with: title)
    }
    
    func saveDatasourceConfiguration() {        
        screeners.forEach { (screener) in
            savedScreenerLoader.removeScreenerParameters(with: screener.title)
            savedScreenerLoader.removeScreener(with: screener.title)
        }
        
        screeners.forEach({ savedScreenerLoader.saveScreener(screener: $0) })
    }
    
}
