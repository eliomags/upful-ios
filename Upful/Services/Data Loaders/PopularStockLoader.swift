//
//  CompanyLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 11/6/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

protocol DataLoader {
    associatedtype T
    typealias DataLoaderCompletion = ((([T]),Error?) -> Void)
    var dataUpdates: DataLoaderCompletion? { get set }
    func load()
}

class PopularStockDataLoader: DataLoader {
    typealias PopularStockCallBack = ((([PopularCompany]),Error?) -> Void)
    
    private let backendService: FirestoreAPI
    
    init(backendService: FirestoreAPI) {
        self.backendService = backendService
    }
    
    var dataUpdates: PopularStockCallBack?
    
    func load() {
        backendService.fetch(from: .popularStocks) { (result) in
            switch result {
            case .success(let stockDocuments):
                if let stockDictionary = stockDocuments as? [[String: String]] {
                    var popularStocks: [PopularCompany] = []
                    stockDictionary.forEach({ (dictionary) in
                        let ticker = dictionary["ticker"] ?? ""
                        let name = dictionary["name"] ?? ""
                        let company = PopularCompany(details: name, header: ticker)
                        popularStocks.append(company)
                    })
                    self.dataUpdates?(popularStocks, nil)
                }
            case .failure(let error):
                self.dataUpdates?([], error)
            }
        }
    }
}
