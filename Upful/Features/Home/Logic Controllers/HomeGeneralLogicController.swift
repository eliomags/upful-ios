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
    
    let tradingEngine = TradingEngine.shared
    private let preferenceDataManager: PreferenceDataManager
    private let stockScreeningService: StockScreener

    // MARK: - State
    enum SectionState {
        case new
        case empty
        case loading
        case loaded
        case error
    }
    
    private(set) var holdingsState: SectionState = .loading {
        didSet {
            DispatchQueue.main.async {
                self.holdingsLoadCompletion?(nil)
            }
        }
    }
    private(set) var preferenceState: SectionState = .loading {
        didSet {
            DispatchQueue.main.async {
                self.sendPreferenceStateUpdates?(self.preferenceState)
            }
        }
    }
    
    // MARK: - Submodels
    var performanceViewModel = HomePerformanceViewModel()

    private var holdingsLoader: Timer?
    private(set) var totalEquity: Double?
    private(set) var holdings = [Holding]()
    private(set) var pieChartViewModels: [PieChartConfigurable] = []
    private(set) var stocksYouMayLike: [StockViewModel] = []
    
    // MARK: - Properties
    lazy var loadCompletionHandler: Handler<[Holding]> = {
        var handler = Handler<[Holding]>(block: { [weak self] holdings in
            if let holdings = holdings {
                self?.holdings = holdings
                self?.totalEquity = self?.tradingEngine.balanceManager.totalEquityBalance
                self?.holdingsState = holdings.isEmpty ? .empty : .loaded
            }
        })
        return handler
    }()

    // MARK: - Configuration
    var holdingsLoadCompletion: ((Error?) -> Void)?
    var sendPreferenceStateUpdates: ((SectionState) -> Void)?
    var newsLoadCompletion: (() -> Void)?
    
    // MARK: - Initializer
    init(preferenceDataManager: PreferenceDataManager = .init(),
         stockScreeningService: StockScreener = StockScreeningService()
    ) {
        self.preferenceDataManager = preferenceDataManager
        self.stockScreeningService = stockScreeningService
    }
        
    func fetchTableData() {
        holdingsState = .loading
        startPreferenceLoad()
    }
        
    // MARK: - Holdings Loading

    func loadHoldings() {
        holdingsLoader?.invalidate()
        
        holdingsLoader = Timer.scheduledTimer(withTimeInterval: 15, repeats: true, block: {  (_) in
            self.startHoldingsLoad()
        })
        holdingsLoader?.fire()
    }
    
    func cancelHoldingsLoad() {
        holdingsLoader?.invalidate()
    }
    
    fileprivate func startHoldingsLoad() {
        tradingEngine.loadHandlerObservers.addHandler(loadCompletionHandler)
        tradingEngine.loadHoldings()
    }
    
    func loadPieChartViewModels() {
        let vmLoader = PieChartViewModelLoader()
        let cash = tradingEngine.balanceManager.currentCashBalance
        pieChartViewModels = vmLoader.makeViewModels(from: holdings, cash: cash)
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
        
    func startPreferenceLoad() {
        let preferenceFetchGroup = DispatchGroup()

        preferenceState = .loading
        let groupedPreferences = preferenceDataManager.getGroupedPreferences()
        if groupedPreferences.isEmpty {
            preferenceState = .new
            return
        }
        groupedPreferences.forEach { (preferenceArray) in
            let preferenceParameters = preferenceArray.joined(separator: ",")
            fetchSuggestedStocks(parameters: preferenceParameters, dispatchGroup: preferenceFetchGroup)
        }
        
        preferenceFetchGroup.notify(queue: .main) {
            self.preferenceState = .loaded
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                self.stocksYouMayLike.forEach {
                    $0.updateHandler = { [weak self] in
                        DispatchQueue.main.async { self?.preferenceState = .loaded }
                    }
                    $0.loadQuoteData()
                }
            }
        }
    }
    
    fileprivate func fetchSuggestedStocks(parameters: String, dispatchGroup: DispatchGroup? = nil) {
        dispatchGroup?.enter()
        
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
            dispatchGroup?.leave()
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
