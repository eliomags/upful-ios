//
//  StockSearchService.swift
//  Upful
//
//  Created by Yanik Simpson on 1/11/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

protocol StockSearcherProtocol {
    func search(name: String, completion: @escaping (Result<[Company],Error>) -> Void)
}

class StockSearchService: StockSearcherProtocol {
    private let apiKey = Constants.Intrinio.apiKey
    private let companySearchEndpoint = "https://api-v2.intrinio.com/companies/search?query="
    
    func search(name: String, completion: @escaping (Result<[Company],Error>) -> Void) {
        guard let url = URL(string: companySearchEndpoint + name + "&page_size=4" + apiKey) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, _, err) in
            if let err = err { completion(.failure(err)) }
            guard let data = data else {
                completion(.failure(NSError()))
                return
            }
            completion(Result {
                let searchItems = try JSONDecoder().decode(Companies.self, from: data)
                return searchItems.companies
            })
        }
        task.resume()
    }
}
