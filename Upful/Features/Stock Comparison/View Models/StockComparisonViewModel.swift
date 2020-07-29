//
//  StockComparisonViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 7/22/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class StockComparisonViewModel {
    
    typealias MetricDataFetch = (String, FinancialsFrequency, SearchCriteria,
        @escaping (Result<[CompanyHistoricalDatum], NetworkError>) -> Void) -> ()
    var fetch: MetricDataFetch
    
    var mainTicker: String {
        didSet {
            fetchMetricForPrimary()
        }
    }
    var secondTicker: String? {
        didSet {
            fetchMetricForSecondary()
        }
    }
    var searchingCriteria: SearchCriteria = .pricetoearnings {
        didSet {
            fetchMetricForPrimary()
            fetchMetricForSecondary()
        }
    }
    
    private(set) var mainTickerResults = [CompanyHistoricalDatum]()
    private(set) var secondTickerResults = [CompanyHistoricalDatum]()
    
    var handleLoadCompletion: (() -> Void)?
    
    // MARK: Initializer
    
    init(mainTicker: String,
        fetching: @escaping MetricDataFetch = StockFinancialLoader().getStockFinancials) {
        fetch = fetching
        self.mainTicker = mainTicker
        fetchMetricForPrimary()
    }
    
    deinit {
        print("Show deinit", self)
    }
    
    // MARK: Methods
    
    func fetchMetricForPrimary() {
        mainTickerResults.removeAll()

        fetchMetric(for: mainTicker) { data in
            self.mainTickerResults = data
            self.handleLoadCompletion?()
        }
    }
    
    func fetchMetricForSecondary() {
        secondTickerResults.removeAll()
        guard let secondTicker = secondTicker else { return }

        fetchMetric(for: secondTicker) { data in
            self.secondTickerResults = data
            self.handleLoadCompletion?()
        }
    }
    
    func createCoordinatorFromTickerCellTap(in viewController: UIViewController, at row: Int) -> Coordinator? {
        var selectedTicker: String?
        
        let savedStockCoordinator = SavedStockCoordinator(presenter: viewController, selectedTicker: selectedTicker)
        savedStockCoordinator.presenting.handleCellSelection = { [unowned self] item in
            if row == 2 {
                selectedTicker = self.mainTicker
                self.mainTicker = item.title
            }
            else if row == 3 {
                selectedTicker = self.secondTicker
                self.secondTicker = item.title
            }
            self.handleLoadCompletion?()
        }
        return savedStockCoordinator
    }
    
    // MARK: Helper
    
    fileprivate func fetchMetric(for ticker: String, _ completion: @escaping ([CompanyHistoricalDatum]) -> Void) {
        fetch(ticker, .fiveYear, searchingCriteria) { result in
            switch result {
            case .success(let critera):
                completion(critera)
            case .failure(_):
                completion([])
            }
        }
    }
}
