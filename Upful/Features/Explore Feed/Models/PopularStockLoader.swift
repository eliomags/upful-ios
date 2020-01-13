//
//  CompanyLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 11/6/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

protocol RemoteStockLoaderProtocol {
    func load(completion: @escaping (Result<[Stock],Error>) -> Void)
}

class RemoteStockLoader: RemoteStockLoaderProtocol {
    
    private let backendService: FirestoreAPI
    
    init(backendService: FirestoreAPI) {
        self.backendService = backendService
    }
    
    func load(completion: @escaping (Result<[Stock],Error>) -> Void) {
        backendService.fetch(from: .popularStocks) { (result) in
            switch result {
            case .success(let stockDocuments):
                if let stockDictionaries = stockDocuments as? [[String: Any]] {
                    completion(Result {
                        return try self.map(dictionaries: stockDictionaries)
                    })
                }
            case .failure(_):
                completion(.failure(NSError()))
            }
        }
    }
    
    fileprivate func map(dictionaries: [[String: Any]]) throws -> [Stock] {
        return (try dictionaries.map { (dictionary) -> Stock in
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            let stock = try JSONDecoder().decode(Stock.self, from: jsonData)
            return stock
        })
    }
}
