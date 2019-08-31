//
//  IntrinioAPI.swift
//  Upful
//
//  Created by Yanik Simpson on 8/10/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation


// MARK: - INTRINIO SEARCH RESULTS MODEL

struct ScreeningResponse: Decodable {
    var data: [ScreenResult]
    var resultCount: Int?
    var pageSize: Int?
}

class ScreenResult: Decodable {
    let name: String?
    let ticker: String?
    let marketcap: Int?
    var divyield: Double?
    var pricetoearnings: Double?
    var ebitgrowth: Double?
    var news: [CompanyNewsModel]?
    var standardizedFinancials: [StandardizedFinancial]?
}

final class IntrinioAPI {
    
    // Screening
    private let endpoint = "https://api.intrinio.com/securities/search?"
    private let numberOfResults = 10
    private let resultOrder = "&order_column=marketcap&order_direction=desc&primary_only=true"
    private let apiKey = "&api_key=OjNiMzRkZmFlNDBkYjIzYTgyMTNhNjcyZGNlZmYzMjE1"
    
    enum OrderDirection: String {
        case desc
        case asc
    }
    
    private let sortBy = "&order_column=marketcap"
    var sortDirection: OrderDirection = .desc
    var screenPage = 1
    
    func newGetScreenRequest(parameters: String, completion: @escaping (Result<[ScreenResult],NetworkingError>) -> Void) {
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
    
    // Lookup historic financials
    private let historicLookupEnpoint = "https://api-v2.intrinio.com/securities/"
    private let searchType = "/historical_data/"
    private let frequency = "?frequency=yearly&start_date=2018-01-01"
    
    func getCompanyFinancials(ticker: String, financial: String, completion: @escaping (Result<[CompanyHistoricalDatum], Error>) -> Void) {
        guard let url = URL(string: historicLookupEnpoint + ticker + searchType + financial + frequency + apiKey) else { return }
        let decoder = JSONDecoder()
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data else { return }
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let companyData = try decoder.decode(HistoricalDataSearch.self, from: data)
                completion(.success(companyData.historicalData))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    //Lookup fundamentals
    private let lookupEndpoint = "https://api-v2.intrinio.com/fundamentals/"
    // Q1TTM, Q2TTM, Q3TTM, FY, Q1, Q2, Q3, Q4, Q2YTD, Q3YTD
    private let documentType = "-calculations-2019-Q2TTM/standardized_financials?"
    
    func getCompanyData(ticker: String, completion: @escaping (Result<[StandardizedFinancial], Error>) -> Void) {
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
                let companyData = try decoder.decode(ScreenResult.self, from: data)                
                completion(.success(companyData.standardizedFinancials ?? []))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    // Get Company NewsData
    
    private let newsEndpoint = "https://api-v2.intrinio.com/companies/"
    private let newsPageSize = "/news?page_size=4"
    
    func getCompanyNewsData(ticker: String, completion: @escaping (Result<ScreenResult, Error>) -> Void) {
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
                let companyData = try decoder.decode(ScreenResult.self, from: data)
                completion(.success(companyData))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
