//
//  IntrinioAPI.swift
//  Upful
//
//  Created by Yanik Simpson on 8/10/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation


// MARK: - INTRINIO SEARCH RESULTS MODEL

struct IntrinioResponse: Decodable {
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
}

final class IntrinioAPI {
    
    // Screening
    private let endpoint = "https://api.intrinio.com/securities/search?"
    let numberOfResults = 20
    private let resultOrder = "&order_column=marketcap&order_direction=desc&primary_only=true&page_size="
    private let apiKey = "&api_key=OjNiMzRkZmFlNDBkYjIzYTgyMTNhNjcyZGNlZmYzMjE1"
    private var currentPage = 1

    func getScreenRequest(parameters: String, completion: @escaping (Result<[ScreenResult],NetworkingError>) -> Void) {
        guard let url = URL(string: endpoint + "conditions=" + parameters + resultOrder + String(numberOfResults) + apiKey) else { return }
        let decoder = JSONDecoder()
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if error != nil {
                completion(.failure(.failedNetworking))
            }
            guard let data = data else { return }
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let fetchedData = try decoder.decode(IntrinioResponse.self, from: data)
                print(fetchedData.data.count)
                completion(.success(fetchedData.data))
            } catch {
                completion(.failure(.parsingError))
            }
        }
        currentPage += 1
        task.resume()
    }
    
    //Lookup
    private let lookupEndpoint = "https://api-v2.intrinio.com/fundamentals/"
    // Q1TTM, Q2TTM, Q3TTM, FY, Q1, Q2, Q3, Q4, Q2YTD, Q3YTD
    private let documentType = "-calculations-2019-Q3TTM/standardized_financials?"
    
    func getCompanyData(ticker: String, completion: @escaping (Result<CompanyFundamentals, Error>) -> Void) {
        print(lookupEndpoint + ticker + documentType + apiKey)
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
                let companyData = try decoder.decode(CompanyFundamentals.self, from: data)
                completion(.success(companyData))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
