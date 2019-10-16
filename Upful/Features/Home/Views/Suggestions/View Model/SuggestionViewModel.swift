//
//  SuggestionViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 10/15/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

protocol StockScreenNetworkingProtocol {
    func screenForPreferences(parameters: String, completion: @escaping (Result<[Stock],NetworkingError>) -> Void)
}

class SuggestionViewModel {
    // MARK: - Dependencies
    
    let preferenceDataManager: PreferenceDataManager
    let networkingAPI: StockScreenNetworkingProtocol
    let analyticsMapper: AnalyticsLogger
    let dispatchGroup = DispatchGroup()
    
    // MARK: - State
    
    enum State {
        case pending
        case isLoading
        case loaded
        case noPreferencesSet
        case empty
    }
    
    var state: State = .pending {
        didSet {
            handleStateChange(completion: {
                stateChanged?(state)
            })
        }
    }
    
    // MARK: - Data
    
    var groupedPreferences: [[String]]
    var stockData: [Stock] = [] 
    
    // MARK: - Initializer
    
    init(dataManager: PreferenceDataManager = .init(), analyticsMapper: AnalyticsLogger = .init(), networkingAPI: StockScreenNetworkingProtocol = IntrinioAPI()) {
        self.preferenceDataManager = dataManager
        self.analyticsMapper = analyticsMapper
        self.networkingAPI = networkingAPI
        self.groupedPreferences = dataManager.getGroupedPreferences()
        setState()
    }
    
    // MARK: - State Changes
    
    var stateChanged: ((State) -> Void)?
    
    func setState() {
        groupedPreferences = preferenceDataManager.getGroupedPreferences()
        if groupedPreferences.isEmpty {
            state = .noPreferencesSet
        } else {
            state = .isLoading
        }
    }
    
    func shuffleResults() {
        if stockData.count <= 4 { return }
        stockData.shuffle()
        let difference = stockData.count - 4
        stockData.removeLast(difference)
    }
    
    func checkForRecievedData() {
        if self.stockData.isEmpty {
            self.state = .empty
        } else {
            self.shuffleResults()
            self.state = .loaded
        }
    }
    
    func handleStateChange(completion: (() -> Void)) {
        switch state {
            
        case .isLoading:
            fetchData(completion: nil)
            dispatchGroup.notify(queue: .main) {
                self.checkForRecievedData()
            }
        default:
            break
        }
        completion()
    }
    
    // MARK: - Helpers
        
    func fetchData(completion: (() -> Void)?) {
        guard groupedPreferences.count > 0 else { return }
        for count in 0...groupedPreferences.count - 1 {
            dispatchGroup.enter()
            var searchKeys = ""
            groupedPreferences[count].forEach { (parameter) in
                searchKeys += "\(parameter),"
            }
            fetchStockData(parameter: searchKeys)
        }
        completion?()
    }

    func fetchStockData(parameter: String) {
        networkingAPI.screenForPreferences(parameters: parameter) { (result) in
            switch result {
                
            case .success(let fetchedData):
                self.stockData.append(contentsOf: fetchedData)
                self.dispatchGroup.leave()
                
            case .failure(_):
                self.dispatchGroup.leave()
            }
        }
    }
    
}
