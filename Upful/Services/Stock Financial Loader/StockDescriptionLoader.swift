//
//  StockDescriptionLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 2/21/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

enum DescriptionLoaderError: Error {
    case invalidData
    case connection
}

struct StockDetail: Codable {
    let description: String?
    let employees: Int?
    let city: String?
    let state: String?
}

protocol DescriptionLoader {
    typealias DescriptionLoaderCompletion = (Result<StockDetail,DescriptionLoaderError>) -> Void
    func loadDescription(for ticker: String, completion: @escaping DescriptionLoaderCompletion)
}

final class StockDescriptionLoader: DescriptionLoader {
    typealias DescriptionLoaderCompletion = (Result<StockDetail,DescriptionLoaderError>) -> Void
    
    var loadData: ((String, @escaping DataCompletionHandler) -> ())? = HTTPClient().downloadContentWithCache
    
    func parse<T:Codable>(data: Data, completion: (Result<T, NetworkError>) -> Void) {
        do {
            let stock = try JSONDecoder().decode(T.self, from: data)
            completion(.success(stock))
        } catch {
            completion(.failure(.parsing))
        }
    }
    
    func loadDescription(for ticker: String, completion: @escaping DescriptionLoaderCompletion) {
        let endpoint = "https://cloud.iexapis.com/stable/stock/\(ticker)/company?token=pk_93380460343741859a000b3c6414fedc"
        
        loadData?(endpoint, { result in
            switch result {
            case .success(let data):
                do {
                    let stock = try JSONDecoder().decode(StockDetail.self, from: data)
                    completion(.success(stock))
                } catch {
                    completion(.failure(.invalidData))
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}
