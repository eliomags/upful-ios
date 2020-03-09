//
//  BatchFinancialLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 2/23/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

protocol BatchFinancialLoader {
    typealias BatchFinancialLoaderCompletion = (Result<[StandardizedFinancial], NetworkError>) -> Void
    func fetchStockBatchFinancials(ticker: String, completion: @escaping BatchFinancialLoaderCompletion)
}

class StockBatchFinancialLoader: BatchFinancialLoader {
    private let apiKey = Constants.Intrinio.apiKey
    private let lookupEndpoint = "https://api-v2.intrinio.com/fundamentals/"
    // Q1TTM, Q2TTM, Q3TTM, FY, Q1, Q2, Q3, Q4, Q2YTD, Q3YTD
    private let documentType = "-calculations-2019-Q4/standardized_financials?"
    
    func fetchStockBatchFinancials(ticker: String,
                                   completion: @escaping BatchFinancialLoaderCompletion) {
        guard let url = URL(string: lookupEndpoint + ticker + documentType + apiKey) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(.failure(.connection))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let stock = try decoder.decode(StockData.self, from: data)
                completion(.success(stock.standardizedFinancials ?? []))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
}
