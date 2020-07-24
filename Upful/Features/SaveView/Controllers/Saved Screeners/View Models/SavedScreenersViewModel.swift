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
    
    let savedScreenerLoader: LocalScreenerLoaderProtocol
    
    
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
    
    
    init(savedScreenerLoader: LocalScreenerLoaderProtocol = LocalScreenerLoader()) {
        self.savedScreenerLoader = savedScreenerLoader
    }
    
    
    // MARK: -
    
    func loadScreeners() {
        state = .loading
        savedScreenerLoader.load { [weak self] (result) in
            switch result {
            case .success(let screeners):
                self?.screeners = screeners
                self?.refreshState()
            case .failure(_):
                self?.state = .error
            }
        }
    }
    
    func refreshState() {
        state = screeners.isEmpty ? .empty: .loaded
    }
    
    func removeScreener(_ id: String) {
        screeners.removeAll(where: { $0.id == id })
        savedScreenerLoader.delete(with: id)
    }
    
    func saveDatasourceConfiguration() {        
        screeners.forEach { (screener) in
            savedScreenerLoader.delete(with: screener.id)
        }
        screeners.forEach({ savedScreenerLoader.save(screener: $0) })
    }
}
