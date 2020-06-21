//
//  StockFinancialLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 2/23/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case invalidData
    case connection
    case parsing
}

enum FinancialsFrequency: Equatable {
    case threeYear
    case fiveYear
    case recent
}

protocol FinancialLoader {
    func getStockFinancials(
            ticker: String,
            financialFrequency: FinancialsFrequency,
            financial: SearchCriteria,
            completion: @escaping (Result<[CompanyHistoricalDatum], NetworkError>) -> Void
    )
}

fileprivate extension FinancialsFrequency {
    var asString: String {
        switch self {
        case .threeYear:
            return "?frequency=yearly&start_date=2016-01-01&end_date=2021-01-01&sort_order=asc"
        case .fiveYear:
            return "?frequency=yearly&start_date=2014-01-01&end_date=2021-01-01&sort_order=asc"
        case .recent:
            return "?frequency=yearly&start_date=2020-01-01"
        }
    }
}

final class StockFinancialLoader: FinancialLoader {
    private let apiKey = Constants.Intrinio.apiKey
    private let historicLookupEnpoint = "https://api-v2.intrinio.com/securities/"
    private let searchType = "/historical_data/"

    func getStockFinancials(ticker: String,
                      financialFrequency: FinancialsFrequency,
                      financial: SearchCriteria,
                      completion: @escaping (Result<[CompanyHistoricalDatum], NetworkError>) -> Void) {
        let urlString = historicLookupEnpoint + ticker + searchType + financial.rawValue + financialFrequency.asString + apiKey
        guard let url = URL(string: urlString) else { return }
        let decoder = JSONDecoder()
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(.failure(.connection))
                return
            }
            guard let data = data else {
                completion(.failure(.connection))
                return
            }
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let companyData = try decoder.decode(HistoricalDataSearch.self, from: data)
                completion(.success(companyData.historicalData))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
}
