//
//  QuickSearchViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 11/5/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

class PopularCompanyViewModel {
    
    // MARK: - Dependencies
    
    private let intrinioAPI: IntrinioAPI
    private let popularCompanyLoader: PopularStockDataLoader
    private let stockDataGroup = DispatchGroup()

    // MARK: - State
    
    enum State {
        case awaiting
        case loading
        case loaded
        case error
    }
    
    private(set) var state: State = .awaiting {
        didSet {
            sendUpdates?(state)
        }
    }
    
    var sendUpdates: ((State) -> Void)?

    var popularCompanies: [PopularCompany] = []
    
    // MARK: - Initializer
    
    init(popularStockLoader: PopularStockDataLoader = .init(backendService: FirestoreAPI())) {
        self.popularCompanyLoader = popularStockLoader
        self.intrinioAPI = IntrinioAPI()
        listenForDataUpdates()
    }
    
    func initialFetch() {
        state = .loading
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.popularCompanyLoader.load()
        }
    }
    
    private func listenForDataUpdates() {
        popularCompanyLoader.dataUpdates = { [weak self] (data, error) in
            guard let self = self else { return }
            if let error = error { print(error)
            } else {
                self.popularCompanies = data
                self.popularCompanies.forEach({ (company) in
                    self.fetchPopularCompanyMarketCap(for: company)
                    self.fetchPopularCompanyPE(for: company)
                })
                self.stockDataGroup.notify(queue: .main, execute: { [weak self] in
                    guard let self = self else { return }
                    self.state = .loaded
                })
            }
        }
    }
        
    fileprivate func fetchPopularCompanyMarketCap(for popularCompany: PopularCompany) {
        stockDataGroup.enter()
        intrinioAPI.fetchStockSpecificFinancial(ticker: popularCompany.header, financial: .marketcap, frequency: .recent, completion: { (result) in
            switch result {
            case .success(let downloadedData):
                if downloadedData.isEmpty { return }
                popularCompany.marketcap = Int(downloadedData.first?.value ?? 0)
                self.stockDataGroup.leave()
            case .failure(_):
                self.stockDataGroup.leave()
            }
        })
    }

    fileprivate func fetchPopularCompanyPE(for popularCompany: PopularCompany) {
        stockDataGroup.enter()
        intrinioAPI.fetchStockSpecificFinancial(ticker: popularCompany.header, financial: .pricetoearnings, frequency: .recent, completion: { (result) in
            switch result {
            case .success(let downloadedData):
                if downloadedData.isEmpty { return }
                popularCompany.priceToEarnings = downloadedData.first?.value
                self.stockDataGroup.leave()
            case .failure(_):
                self.stockDataGroup.leave()
            }
        })
    }
}
