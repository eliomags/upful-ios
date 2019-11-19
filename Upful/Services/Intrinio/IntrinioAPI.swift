//
//  IntrinioAPI.swift
//  Upful
//
//  Created by Yanik Simpson on 8/10/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

final class IntrinioAPI: StockScreenNetworkingProtocol {
    private let apiKey = Constants.Intrinio.apiKey
    
    /// Used to fetch company filings in the details screen
    func getCompanyFilings(ticker: String, completion: @escaping (Result<[Filings],Error>) -> Void) {
        guard let filingsUrl = URL(string: "https://api-v2.intrinio.com/companies/" +
            ticker + "/filings?report_type=10-K,10-K/A,10-Q,10-Q/A&start_date=2018-01-01" +
            apiKey) else { return }
        let decoder = JSONDecoder()
        let session = URLSession.shared
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let task = session.dataTask(with: filingsUrl) { (data, _, err) in
            if let err = err {
                completion(.failure(err))
            }
            guard let data = data else { return }
            do {
                let companyFilings = try decoder.decode(Company.self, from: data)
                completion(.success(companyFilings.filings ?? []))
            } catch let error {
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    private let companySearchEndpoint = "https://api-v2.intrinio.com/companies/search?query="
    
    func searchByName(name: String, completion: @escaping (Result<[Company],Error>) -> Void) {
        guard let url = URL(string: companySearchEndpoint + name + "&page_size=4" + apiKey) else { return }
        let decoder = JSONDecoder()
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, _, err) in
            if let err = err {
                completion(.failure(err))
            }
            guard let data = data else { return }
            do {
                let searchItems = try decoder.decode(Companies.self, from: data)
                completion(.success(searchItems.companies))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    // MARK: - Screening for stocks
    
    private let endpoint = "https://api.intrinio.com/securities/search?"
    private let numberOfResults = 22
    private let resultOrder = "&order_column=marketcap&order_direction=desc&primary_only=true"
    enum OrderDirection: String {
        case desc
        case asc
    }
    private let sortBy = "&order_column=marketcap"
    var sortDirection: OrderDirection = .desc
    var screenPage = 1
    
    func performStockScreening(parameters: String, completion: @escaping (Result<[Stock],NetworkingError>) -> Void) {
        guard let url = URL(string: endpoint + "conditions=name~gt~0,\(parameters)" + sortBy + "&order_direction=\(sortDirection.rawValue)&primary_only=true" + "&page_number=\(screenPage)" + "&page_size=\(numberOfResults)" + apiKey) else { return }
        let decoder = JSONDecoder()
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, resp, error) in
            if error != nil {
                completion(.failure(.failedNetworking))
            }
            guard let data = data else { return }
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let fetchedData = try decoder.decode(ScreeningResponse.self, from: data)
                completion(.success(fetchedData.data))
            } catch {
                completion(.failure(.parsingError))
            }
        }
        screenPage += 1
        task.resume()
    }
    
    func screenForPreferences(parameters: String, completion: @escaping (Result<[Stock],NetworkingError>) -> Void) {
        guard let url = URL(string: endpoint + "conditions=name~gt~0,pricetoearnings~gte~0,\(parameters)" + "&order_column=marketcap" + "&primary_only=true" + "&page_size=8" + apiKey) else {
            completion(.failure(.urlError))
            return
        }
        let decoder = JSONDecoder()
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, resp, error) in
            if error != nil {
                completion(.failure(.failedNetworking))
            }
            guard let data = data else { return }
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let fetchedData = try decoder.decode(ScreeningResponse.self, from: data)
                completion(.success(fetchedData.data))
            } catch {
                completion(.failure(.parsingError))
            }
        }
        task.resume()
    }
    
    /// MARK: - Lookup historic financials
    enum FinancialsFrequency: String {
        case recent = "?frequency=yearly&start_date=2018-01-01"
        case historic = "?frequency=yearly&start_date=2016-01-01&end_date=2021-01-01&sort_order=asc"
    }
    
    private let historicLookupEnpoint = "https://api-v2.intrinio.com/securities/"
    private let searchType = "/historical_data/"
    
    func fetchStockSpecificFinancial(ticker: String, financial: SearchCriteria, frequency: FinancialsFrequency, completion: @escaping (Result<[CompanyHistoricalDatum], Error>) -> Void) {
        guard let url = URL(string: historicLookupEnpoint + ticker + searchType +
            financial.rawValue + frequency.rawValue + apiKey) else { return }
        let decoder = JSONDecoder()
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error { completion(.failure(error)) }
            guard let data = data else { return }
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let companyData = try decoder.decode(HistoricalDataSearch.self, from: data)
                completion(.success(companyData.historicalData))
            } catch let error { completion(.failure(error)) }
        }
        task.resume()
    }
    
    /// MARK: - Lookup fundamentals
    
    private let lookupEndpoint = "https://api-v2.intrinio.com/fundamentals/"
    // Q1TTM, Q2TTM, Q3TTM, FY, Q1, Q2, Q3, Q4, Q2YTD, Q3YTD
    private let documentType = "-calculations-2019-Q2TTM/standardized_financials?"
    
    func fetchStockBatchFinancials(ticker: String, completion: @escaping (Result<[StandardizedFinancial], Error>) -> Void) {
        guard let url = URL(string: lookupEndpoint + ticker + documentType + apiKey) else { return }

        let decoder = JSONDecoder()
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data else { return }
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let companyData = try decoder.decode(Stock.self, from: data)                
                completion(.success(companyData.standardizedFinancials ?? []))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    /// MARK: - Get Company NewsData
    
    private let newsEndpoint = "https://api-v2.intrinio.com/companies/"
    private let newsPageSize = "/news?page_size=4"
    
    func getCompanyNewsData(ticker: String, completion: @escaping (Result<Stock, Error>) -> Void) {
        guard let url = URL(string: newsEndpoint + ticker + newsPageSize + apiKey) else { return }
        let decoder = JSONDecoder()
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data else { return }
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let companyData = try decoder.decode(Stock.self, from: data)
                completion(.success(companyData))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
