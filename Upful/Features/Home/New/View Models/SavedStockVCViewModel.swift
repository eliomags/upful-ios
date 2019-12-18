//
//  SavedStockVCViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 12/17/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

class SavedStockVCViewModel {
    
    // MARK: - Dependencies

    private let savedStockDataManager = SavedStockDataManager()
    
    // MARK: - State

    enum State {
        case new
        case loading
        case loaded
        case empty
        case error
    }
    
    private(set) var state: State = .new {
        didSet {
            sendStateUpdates?(state)
        }
    }
    private(set) var savedStocks: [SavedStock] = [] {
        didSet {
            state = savedStocks.isEmpty ? .empty: .loaded
        }
    }

    var sendStateUpdates: ((State) -> Void)?
    

    func loadSavedStocks() {
        state = .loading
        savedStockDataManager.loadSavedStocks { (result) in
            switch result {
            case .success(let stocks):
                self.savedStocks = stocks
            case .failure(_):
                self.state = .error
            }
        }
    }
    
    func removeTicker(_ ticker: String) {
        savedStockDataManager.removeFavoriteCompany(ticker) { [weak self] in
            self?.loadSavedStocks()
        }
    }
}
