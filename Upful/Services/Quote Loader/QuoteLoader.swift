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

struct QuoteClose: Codable {
    let uClose: Double
    let date: String
}

final class StockPriceLoader: QuoteLoader {
    let httpClient = HTTPClient()
    
    func load(for ticker: String, completion: @escaping PriceLoaderCompletion) {
        let priceComponent = "/quote"
//        let url = URL(string: Constants.IEXTrading.EndPoints.sandbox + ticker + priceComponent + Constants.IEXTrading.sandboxKey)!
        let urlString = Constants.IEXTrading.EndPoints.production +
            ticker +
            priceComponent +
            Constants.IEXTrading.productionKey
        
        httpClient.downloadContent(fromUrlString: urlString) { result in
            switch result {
            case .failure(_):
                completion(.failure(.connection))
            case .success(let data):
                do {
                    let quote = try JSONDecoder().decode(StockQuote.self, from: data)
                    completion(.success(quote))
                } catch {
                    completion(.failure(.invalidData))
                }
            }
        }
    }
    
    func loadEndOfDayPriceOnDate(for ticker: String, date: String,
                                 completion: @escaping (Result<Double,NetworkError>) -> Void) {
        let urlString = Constants.IEXTrading.EndPoints.production +
            ticker + "chart/" +
            "date/\(date)" + "?" +
            "chartByDay=true&" +
            Constants.IEXTrading.appendingProductionKey

        httpClient.downloadContent(fromUrlString: urlString) { result in
            switch result {
            case .failure(_):
                completion(.failure(.connection))
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode([QuoteClose].self, from: data)
                    if let entry = response.first {
                        completion(.success(entry.uClose))
                    } else {
                        completion(.failure(.invalidData))
                    }
                } catch {
                    completion(.failure(.invalidData))
                }
            }
        }
    }
}
