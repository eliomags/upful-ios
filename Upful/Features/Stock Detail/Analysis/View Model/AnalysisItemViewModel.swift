//
//  AnalysisItemViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 3/9/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class AnalysisItemViewModel {
    
    // MARK: - Dependencies
    
    private let financialLoader: FinancialLoader
    
    // MARK: - Properties
    
    var searchCriteria: SearchCriteria {
        didSet {
            loadFinancialData()
        }
    }
    let color: UIColor
    private let ticker: String
    private(set) var data: [CompanyHistoricalDatum] = []

    // MARK: - Configuration
    
    var updateHandler: (() -> Void) = {}
    
    // MARK: - Initializer
    
    init(ticker: String,
        searchCriteria: SearchCriteria,
         financialLoader: FinancialLoader = StockFinancialLoader(),
         color: UIColor) {
        self.ticker = ticker
        self.searchCriteria = searchCriteria
        self.financialLoader = financialLoader
        self.color = color
    }
    
    // MARK: - Methods
    
    func loadFinancialData() {
        let financialFrequency = PermissionManager.shared.isPremium ? FinancialsFrequency.fiveYear : .threeYear
        financialLoader.getStockFinancials(ticker: ticker, financialFrequency: financialFrequency, financial: searchCriteria) { [weak self] (result)  in
            self?.handleFinancialLoadCompletion(result)
        }
    }
    
    // MARK: - Fileprivate Methods
    
    func handleFinancialLoadCompletion(_ result: Result<[CompanyHistoricalDatum], NetworkError>) {
        switch result {
        case .success(let historicData):
            self.data = historicData
        case .failure(_):
            self.data.removeAll()
        }
        updateHandler()
    }
}


