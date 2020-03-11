//
//  PriceLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 2/21/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

protocol QuoteLoader {
    typealias PriceLoaderCompletion = (Result<StockQuote,NetworkError>) -> Void
    func load(for ticker: String, completion: @escaping PriceLoaderCompletion)
}

struct StockQuote: Codable {
    let latestPrice: Double
    let changePercent: Double
}

final class StockPriceLoader: QuoteLoader {
    fileprivate let priceComponent = "/quote"
    
    func load(for ticker: String, completion: @escaping PriceLoaderCompletion) {
        let url = URL(string: Constants.IEXTrading.EndPoints.production + ticker + priceComponent + Constants.IEXTrading.productionKey)!
//        let url = URL(string: Constants.IEXTrading.EndPoints.sandbox + ticker + priceComponent + Constants.IEXTrading.sandboxKey)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let _ = err { completion(.failure(.connection)) }
            if let data = data {
                do {
                    let quote = try JSONDecoder().decode(StockQuote.self, from: data)
                    completion(.success(quote))
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
