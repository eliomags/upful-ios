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
    
    enum PreferenceState {
        case new
        case loading
        case loaded
        case error
    }
    
    private(set) var stocksYouMayLike: [StockViewModel] = []
    private(set) var preferenceState: PreferenceState = .loading {
        didSet {
            sendPreferenceStateUpdates?(preferenceState)
        }
    }
    private(set) var stockNews: [StockNewsViewModel] = []
    
    // MARK: - Configuration
    
    var holdingsLoadCompletion: ((Error?) -> Void)?
    var sendPreferenceStateUpdates: ((PreferenceState) -> Void)?
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
        loadHoldings()
        startNewsLoad()
        startPreferenceLoad()
    }
    
    // MARK: - Holdings Loading
    
    let tradingEngine = TradingEngine.shared
    private(set) var holdings = [Holding]()
    private var holdingsLoader: Timer?
    private(set) var totalEquity: Double?
    
    func loadHoldings() {
        holdingsLoader?.invalidate()
        startHoldingsLoad()
        
        holdingsLoader = Timer.scheduledTimer(withTimeInterval: 9, repeats: true, block: {  (_) in
            self.startHoldingsLoad()
        })
        holdingsLoader?.fire()
    }
    
    func cancelHoldingsLoad() {
        holdingsLoader?.invalidate()
    }
    
    fileprivate func startHoldingsLoad() {
        tradingEngine.loadHoldings { [weak self] (holdings, err) in
            guard let self = self else { return }
            if let _ = err {
                DispatchQueue.main.async { self.holdingsLoadCompletion?(NSError()) }
                return
            }
            self.holdings = holdings
            self.holdings.forEach { self.loadQuotes(for: $0) }
            
            DispatchQueue.main.async { self.holdingsLoadCompletion?(nil) }
            
            self.holdingsLoadGroup.notify(queue: .main, execute: {
                self.totalEquity = self.tradingEngine.balanceManager.totalEquityBalance
                self.holdingsLoadCompletion?(nil)
            })
        }
    }
    
    private let quoteLoader = StockPriceLoader()
    private let holdingsLoadGroup = DispatchGroup()

    fileprivate func loadQuotes(for holding: Holding) {
        holdingsLoadGroup.enter()
        
        quoteLoader.load(for: holding.ticker) { (result) in
            switch result {
            case .success(let quote):
                holding.currentPrice = quote.latestPrice
                self.tradingEngine.updateEquityBalance(with: self.holdings)
                
            case .failure(_):
                DispatchQueue.main.async { self.holdingsLoadCompletion?(NSError()) }
            }
            self.holdingsLoadGroup.leave()
        }
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
