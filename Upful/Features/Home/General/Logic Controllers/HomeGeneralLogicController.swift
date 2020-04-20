//
//  HomeGeneralViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 12/27/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

class HomeGeneralLogicController {
    
    // MARK: - Dependencies
    
    private let preferenceDataManager: PreferenceDataManager
    private let stockScreeningService: StockScreener
    private let savedStockDataManager: LocalStockDataLoaderProtocol
    private let stockNewsLoader: NewsLoaderProtocol
    
    // MARK: - State
    
    enum SectionState {
        case new
        case empty
        case loading
        case loaded
        case error
    }
    
    private(set) var preferenceState: SectionState = .loading {
        didSet {
            sendPreferenceStateUpdates?(preferenceState)
        }
    }
    private(set) var stockNews: [StockNewsViewModel] = []
    private(set) var stocksYouMayLike: [StockViewModel] = []

    // MARK: - Configuration
    
    var holdingsLoadCompletion: ((Error?) -> Void)?
    var sendPreferenceStateUpdates: ((SectionState) -> Void)?
    var newsLoadCompletion: (() -> Void)?
    
    // MARK: - Initializer
    
    init(savedStockDataManager: LocalStockDataLoaderProtocol = LocalStockLoader(),
         preferenceDataManager: PreferenceDataManager = .init(),
         stockScreeningService: StockScreener = StockScreeningService(),
         stockNewsLoader: NewsLoaderProtocol = NewsLoader()
    ) {
        self.preferenceDataManager = preferenceDataManager
        self.savedStockDataManager = savedStockDataManager
        self.stockScreeningService = stockScreeningService
        self.stockNewsLoader = stockNewsLoader
    }
    
    // MARK: - API Methods
    
    func fetchTableData() {
        holdingsState = .loading
        startNewsLoad()
        startPreferenceLoad()
    }
    
    // MARK: - Holdings Loading
    
    private var holdingsLoader: Timer?
    private(set) var totalEquity: Double?
    private(set) var holdings = [Holding]()
    let tradingEngine = TradingEngine.shared
    
    private(set) var holdingsState: SectionState = .loading {
        didSet {
            holdingsLoadCompletion?(nil)
        }
    }

    func loadHoldings() {
        holdingsLoader?.invalidate()
        
        holdingsLoader = Timer.scheduledTimer(withTimeInterval: 9, repeats: true, block: {  (_) in
            self.startHoldingsLoad()
        })
        holdingsLoader?.fire()
    }
    
    func cancelHoldingsLoad() {
        holdingsLoader?.invalidate()
    }
    
    fileprivate func startHoldingsLoad() {
        self.tradingEngine.completionHandler = { [weak self] holdings in
            guard let self = self else { return }
            self.holdings = holdings
            self.totalEquity = self.tradingEngine.balanceManager.totalEquityBalance
            self.holdingsState = holdings.isEmpty ? .empty : .loaded
        }
        
        tradingEngine.loadHoldings()
    }
        
    // MARK: - News Loading
        
    func startNewsLoad() {
        savedStockDataManager.loadSavedStocks { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let savedStocks):
                self.loadNews(savedStocks)
                
            case .failure(_):
                self.getGeneralMarketNews()
            }
        }
    }
        
    fileprivate func loadNews(_ savedStocks: [Stock]) {
        if !savedStocks.isEmpty { getNewsForTickers(savedStocks)  }
        if savedStocks.isEmpty { getGeneralMarketNews() }
    }
    
    fileprivate func getGeneralMarketNews() {
        stockNewsLoader.get(router: .getMarketNews) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case.success(let news):
                self.handleNewsFetchCompletion(news: news)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    fileprivate func getNewsForTickers(_ savedStocks: [Stock])  {
        let stocks = savedStocks.map({ $0.ticker }).joined(separator: ",")
        stockNewsLoader.get(router: .getTickerNews(tickers: stocks)) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let news):
                self.handleNewsFetchCompletion(news: news)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    fileprivate func handleNewsFetchCompletion(news: [StockNews]) {
        let mappedNews = news.map { StockNewsViewModel(stockNews: $0) }
        self.stockNews = mappedNews
        newsLoadCompletion?()
    }
    
    // MARK: - Stock Preference Loading

    /*
     Gets a random combination of search parameters to perform search for Show More
     */
    func getRandomPreferenceGroup() -> [String] {
        let groupedPreferences = preferenceDataManager.getGroupedPreferences()
        if groupedPreferences.isEmpty { return [] }
        
        let randomElement = Int.random(in: 0...(groupedPreferences.count-1))
        return groupedPreferences[randomElement]
    }
        
    let preferenceFetchGroup = DispatchGroup()
    
    func startPreferenceLoad() {
        preferenceState = .loading
        let groupedPreferences = preferenceDataManager.getGroupedPreferences()
        if groupedPreferences.isEmpty {
            preferenceState = .new
            return
        }
        groupedPreferences.forEach { (preferenceArray) in
            let preferenceParameters = preferenceArray.joined(separator: ",")
            fetchSuggestedStocks(parameters: preferenceParameters)
        }
        
        preferenceFetchGroup.notify(queue: .main) {
            self.preferenceState = .loaded
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                self.stocksYouMayLike.forEach {
                    $0.updateHandler = { [weak self] in
                        DispatchQueue.main.async { self?.preferenceState = .loaded }
                    }
                    $0.loadQuoteData()
                }
            }
        }
    }
    
    fileprivate func fetchSuggestedStocks(parameters: String) {
        preferenceFetchGroup.enter()
        
        stockScreeningService.get(router: .getScreeningResults(parameters: parameters,
                                                               numberOfResults: 8), completion: {
            (result) in
            switch result {
            case .success(let fetchedStocks):
                let stockViewModels = fetchedStocks.map({ StockViewModel(stock: $0)})
                self.handlePreferenceFetchSuccess(with: stockViewModels)
            case .failure(_):
                self.preferenceState = .error
            }
            self.preferenceFetchGroup.leave()
        })
    }
    
    fileprivate func randomizeSuggestedStocks(stocks: [StockViewModel]) -> [StockViewModel] {
        var duplicateStocks = stocks
        duplicateStocks.removeDuplicates()
        if duplicateStocks.count > 3 { duplicateStocks = Array(duplicateStocks[0...2]) }
        return duplicateStocks
    }
    
    fileprivate func handlePreferenceFetchSuccess(with fetchedStocks: [StockViewModel]) {
        if self.preferenceState == .error { return }
        if fetchedStocks.isEmpty {
            self.fetchSuggestedStocks(parameters: "")
        } else {
            fetchedStocks.forEach {
                $0.updateHandler = { [weak self] in
                    DispatchQueue.main.async { self?.preferenceState = .loaded }
                }
                $0.loadQuoteData()
            }
            stocksYouMayLike = randomizeSuggestedStocks(stocks: fetchedStocks)
        }
    }
}
