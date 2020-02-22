//
//  PriceLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 2/21/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

enum PriceLoaderError: Error {
    case invalidData
    case connection
}

protocol PriceLoader {
    typealias PriceLoaderCompletion = (Result<Double,PriceLoaderError>) -> Void
    func load(for ticker: String, completion: @escaping PriceLoaderCompletion)
}

final class StockPriceLoader: PriceLoader {
    fileprivate struct EndPoints {
        fileprivate static let sandbox = "https://sandbox.iexapis.com/stable/stock/"
        fileprivate static let production = "https://cloud.iexapis.com/stable/stock/"
    }
    fileprivate let priceComponent = "/price"
    
    func load(for ticker: String, completion: @escaping PriceLoaderCompletion) {
//        let url = URL(string: EndPoints.production + ticker + priceComponent + Constants.IEXTrading.productionKey)!
        let url = URL(string: EndPoints.sandbox + ticker + priceComponent + Constants.IEXTrading.sandboxKey)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let _ = err { completion(.failure(.connection)) }
            if let data = data {
                do {
                    let price = try JSONDecoder().decode(Double.self, from: data)
                    completion(.success(price))
                } catch {
                    completion(.failure(.invalidData))
                }
            } else {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
}
