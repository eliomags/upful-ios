//
//  ExploreLogicController.swift
//  Upful
//
//  Created by Yanik Simpson on 1/10/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

class ExploreLogicController {
    
    var handleCompletion: (() -> Void)?
    var handleStateUpdates: ((State) -> Void)?
    
    // MARK: - Dependencies
    
    private let newsLoader: NewsLoaderProtocol
    private let stockSearcher: StockSearcherProtocol
    private let remoteStockLoader: RemoteStockLoaderProtocol
    private let remoteScreenerLoader: RemoteScreenerLoaderProtocol
    
    // MARK: - State

    enum State: Equatable {
        case normal, searching
    }
    
    var state: State = .normal {
        didSet {
            handleStateUpdates?(state)
        }
    }
    private(set) var marketNewsViewModels: [StockNewsViewModel] = []
    private(set) var stockViewModels: [StockViewModel] = []
    private(set) var screenerViewModels: [ScreenerViewModel] = []
    private(set) var stockSearchDisplay: [Company]  = []
    
    // MARK: - Initializer
    
    init(newsLoader: NewsLoaderProtocol = NewsLoader(),
         remoteStockLoader: RemoteStockLoaderProtocol = RemoteStockLoader(),
         remoteScreenerLoader: RemoteScreenerLoaderProtocol = RemoteScreenerLoader(),
         stockSearcher: StockSearcherProtocol = StockSearchService()
         ) {
        self.newsLoader = newsLoader
        self.remoteStockLoader = remoteStockLoader
        self.remoteScreenerLoader = remoteScreenerLoader
        self.stockSearcher = stockSearcher
    }
    
    // MARK: - API Methods
    
    func startLoad() {
//        loadNews()
        loadRemoteStocks()
        loadRemoteScreeners()
    }
    
    // MARK: Normal State
    
    func loadNews() {
        newsLoader.get(router: .getMarketNews) { [weak self] (result) in
            switch result {
            case .success(let fetchedMarketNews):
                let mappedNews = fetchedMarketNews.map { StockNewsViewModel(stockNews: $0) }
                self?.marketNewsViewModels = mappedNews
            case .failure(let err):
                print(err)
            }
            self?.handleCompletion?()
        }
    }

    func loadRemoteStocks() {
        remoteStockLoader.load { (result) in
            switch result {
            case .success(let loadedStocks):
                self.loadStockViewModels(from: loadedStocks)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    fileprivate func loadStockViewModels(from stocks: [Stock]) {
        let mappedLoadedStocks = stocks.map { StockViewModel(stock: $0,
                                                             stockPreviewLoader: StockPreviewLoader(ticker: $0.ticker, name: $0.name)) }
        stockViewModels = mappedLoadedStocks
        stockViewModels.forEach { (viewModel) in
            viewModel.previewFetchCompletion = handleCompletion
            viewModel.loadPreviewData()
        }
    }
    
    func loadRemoteScreeners() {
        remoteScreenerLoader.load { (result) in
            switch result {
            case .success(let fetchedScreenerViewModels):
                self.handleRemoteScreenerLoadCompletion(for: fetchedScreenerViewModels)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    fileprivate func handleRemoteScreenerLoadCompletion(for screenerViewModels: [ScreenerViewModel]) {
        guard screenerViewModels.count > 0 else { return }
        let sortedVMs = screenerViewModels.sorted(by: { $0.interest > $1.interest })
        self.screenerViewModels = Array(sortedVMs[0...3])
        handleCompletion?()
    }
    
    // MARK: Search State
    
    private var pendingSearchWorkItem: DispatchWorkItem?
     
    func startSearch(forCompaniesContaining searchText: String) {
        pendingSearchWorkItem?.cancel()
        
        let newSearchWorkItem = DispatchWorkItem { [weak self] in
            self?.searchForCompanies(containing: searchText)
        }
        pendingSearchWorkItem = newSearchWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                      execute: newSearchWorkItem)
    }
    
    func searchForCompanies(containing searchText: String) {
        stockSearcher.search(name: searchText) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let fetchedCompanies):
                self.handleSuccessfulSearch(updatingWith: fetchedCompanies)
            case .failure(_):
                self.handleStockSearchFailure()
            }
        }
    }
    
    // MARK: - Private Functions

    fileprivate func handleSuccessfulSearch(updatingWith fetchedCompanies: [Company]) {
        self.stockSearchDisplay = fetchedCompanies
        DispatchQueue.main.async {
            self.handleCompletion?()
        }
    }
    
    fileprivate func handleStockSearchFailure() {
        stockSearchDisplay.removeAll()
        handleCompletion?()
    }
}
