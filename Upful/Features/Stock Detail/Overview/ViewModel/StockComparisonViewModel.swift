//
//  ComparisonCellViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 7/22/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

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
    var searchingCriteria: SearchCriteria = .revenuegrowth {
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
    
    // MARK: Methods
    
    func fetchMetricForPrimary() {
        mainTickerResults.removeAll()

        fetchMetric(for: mainTicker) { [weak self] data in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.mainTickerResults = data
                self.handleLoadCompletion?()
            }
        }
    }
    
    func fetchMetricForSecondary() {
        guard let secondTicker = secondTicker else {
            return
        }
        
        secondTickerResults.removeAll()

        fetchMetric(for: secondTicker) { [weak self] data in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.secondTickerResults = data
                self.handleLoadCompletion?()
            }
        }
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
