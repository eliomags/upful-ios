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
}

protocol FinancialLoader {
    func get3YearData(
        ticker: String,
        financial: SearchCriteria,
        completion: @escaping (Result<[CompanyHistoricalDatum], NetworkError>) -> Void
    )
    func get5YearData(
        ticker: String,
        financial: SearchCriteria,
        completion: @escaping (Result<[CompanyHistoricalDatum], NetworkError>) -> Void)
}

final class StockFinancialLoader {
    private let apiKey = Constants.Intrinio.apiKey
    private enum FinancialsFrequency: Equatable {
        case threeYear
        case fiveYear
        
        var asString: String {
            switch self {
            case .threeYear:
                return "?frequency=yearly&start_date=2014-01-01&end_date=2021-01-01&sort_order=asc"
            case .fiveYear:
                return "?frequency=yearly&start_date=2016-01-01&end_date=2021-01-01&sort_order=asc"
            }
        }
    }
    private let historicLookupEnpoint = "https://api-v2.intrinio.com/securities/"
    private let searchType = "/historical_data/"
}

extension StockFinancialLoader: FinancialLoader {
    func get3YearData(ticker: String,
                      financial: SearchCriteria,
                      completion: @escaping (Result<[CompanyHistoricalDatum], NetworkError>) -> Void) {
        guard let url = URL(string: historicLookupEnpoint + ticker + searchType +
            financial.rawValue + FinancialsFrequency.threeYear.asString + apiKey) else { return }
        let decoder = JSONDecoder()
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let _ = error { completion(.failure(.connection)) }
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
    
    func get5YearData(ticker: String,
                      financial: SearchCriteria,
                      completion: @escaping (Result<[CompanyHistoricalDatum], NetworkError>) -> Void) {
        guard let url = URL(string: historicLookupEnpoint + ticker + searchType +
            financial.rawValue + FinancialsFrequency.fiveYear.asString + apiKey) else { return }
        let decoder = JSONDecoder()
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let _ = error { completion(.failure(.connection)) }
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
