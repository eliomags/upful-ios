//
//  ExploreLogicController.swift
//  Upful
//
//  Created by Yanik Simpson on 1/10/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

class ExploreLogicController {
    
    // MARK: - Dependencies
    
    private let newsLoader: NewsLoaderProtocol
    private let stockSearcher: StockSearcherProtocol
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
    private(set) var stockSearchDisplay: [Company]  = []
    private(set) var marketNewsViewModels: [StockNewsViewModel] = []
    
    var handleCompletion: (() -> Void)?
    var handleStateUpdates: ((State) -> Void)?
    
    // MARK: - Initializer
    
    init(newsLoader: NewsLoaderProtocol = NewsLoader(),
         remoteScreenerLoader: RemoteScreenerLoaderProtocol = RemoteScreenerLoader(),
         stockSearcher: StockSearcherProtocol = StockSearchService()
         ) {
        self.newsLoader = newsLoader
        self.remoteScreenerLoader = remoteScreenerLoader
        self.stockSearcher = stockSearcher
    }
    
    // MARK: - API Methods
    
    func startLoad() {
        loadNews()
    }
    
    // MARK: Normal State
    
    func loadNews() {
//        newsLoader.get(router: .getMarketNews) { [weak self] (result) in
//            switch result {
//            case .success(let fetchedMarketNews):
//                let mappedNews = fetchedMarketNews.map({ StockNewsViewModel(stockNews: $0 )})
//                self?.marketNewsViewModels = mappedNews
//            case .failure(let err):
//                print(err)
//            }
//            self?.handleCompletion?()
//        }
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
//                     self.tableView.setEmptyView(state: .errorState)
    }
    
}
