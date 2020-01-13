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
    
    private let backendService = FirestoreAPI()
    
    func load(completion: @escaping (Result<[Stock],Error>) -> Void) {
        let collectionRef = backendService.db.collection(FirestoreAPI.Collection.popularStocks.rawValue)
        collectionRef.order(by: "vote", descending: true).limit(to: 4).getDocuments { (snapshot, err) in
            if let err = err { completion(.failure(err)) }
            
            if let snapshot = snapshot {
                let documentData = snapshot.documents.map { $0.data() }
                completion(Result {
                    return try self.map(dictionaries: documentData)
                })
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
