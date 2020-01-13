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

    private let savedStockDataManager: SavedStockDataLoaderProtocol
    
    // MARK: - State

    enum State {
        case new
        case loading
        case loaded
        case empty
        case error
    }
    
    var sendStateUpdates: ((State) -> Void)?

    private(set) var state: State = .new {
        didSet {
            sendStateUpdates?(state)
        }
    }
    var stockViewModels: [StockViewModel] = []
    
    // MARK: - Initializer
    
    init(savedStockDataManager: SavedStockDataLoaderProtocol = SavedStockLoader()) {
        self.savedStockDataManager = savedStockDataManager
    }
    
    // MARK: - API Methods
    
    func loadSavedStocks() {
        state = .loading
        savedStockDataManager.loadSavedStocks { (result) in
            switch result {
            case .success(let savedStocks):
                let mappedViewModels = savedStocks.map { StockViewModel(stock: $0,
                                                                       stockPreviewLoader: StockPreviewLoader(ticker: $0.ticker, name: $0.name))}
                self.stockViewModels = mappedViewModels
                self.getPreviewData()
                self.refreshState()
            case .failure(_):
                self.state = .error
            }
        }
    }
    
    func removeTicker(_ ticker: String) {
        stockViewModels.removeAll(where: { $0.stock.ticker == ticker })
        savedStockDataManager.removeFavoriteCompany(ticker) {}
    }
    
    func refreshState() {
        state = stockViewModels.isEmpty ? .empty : .loaded
    }
    
    fileprivate func getPreviewData() {
        stockViewModels.forEach {
            $0.previewFetchCompletion = { [weak self] in
                guard let self = self else { return }
                self.state = .loaded
            }
            $0.loadPreviewData()
        }
    }
        
    func saveDatasourceConfiguration() {
        stockViewModels.forEach { (vm) in
            savedStockDataManager.removeFavoriteCompany(vm.stock.ticker) {}
            savedStockDataManager.saveCompany(ticker: vm.stock.ticker, companyName: vm.stock.name)
        }
    }
}
