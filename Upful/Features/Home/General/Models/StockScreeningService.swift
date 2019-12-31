//
//  StockScreeningService.swift
//  Upful
//
//  Created by Yanik Simpson on 12/30/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

class StockScreeningService {
    enum Router {
        case getScreeningResults(parameters: String = "",
                                 numberOfResults: Int = 15,
                                 page: Int = 1,
                                 order: SortDirection = .descending)
        
        enum SortDirection: String {
            case descending = "desc"
            case ascending = "asc"
        }
        
        var scheme: String {
            switch self {
            case .getScreeningResults:
                return "https"
            }
        }
        
        var host: String {
            switch self {
            case .getScreeningResults:
                return "api.intrinio.com"
            }
        }
        
        var path: String {
            switch self {
            case .getScreeningResults:
                return "/securities/search"
            }
        }
        
        var parameters: [URLQueryItem] {
            let apiKey = "OjNiMzRkZmFlNDBkYjIzYTgyMTNhNjcyZGNlZmYzMjE1"
            switch self {
            case .getScreeningResults(let parameters,
                                      let numberOfResults,
                                      let pageNumber,
                                      let sortOrder):
                return [
                    URLQueryItem(name: "conditions", value: "name~gt~0,pricetoearnings~gt~0," + parameters),
                    URLQueryItem(name: "order_direction", value: sortOrder.rawValue),
                    URLQueryItem(name: "primary_only", value: "true"),
                    URLQueryItem(name: "order_column", value: "marketcap"),
                    URLQueryItem(name: "page_number", value: "\(pageNumber)"),
                    URLQueryItem(name: "page_size", value: "\(numberOfResults)"),
                    URLQueryItem(name: "api_key", value: apiKey)
                ]
            }
        }
    }
}

extension StockScreeningService {
    typealias StockDataRequestCompletion = (Result<[Stock], Error>) -> Void
    func get(router: Router, completion: @escaping StockDataRequestCompletion) {
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.queryItems = router.parameters
        
        guard let url = components.url else {
            completion(.failure(NSError()))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, _, err) in
            if let err = err { completion(.failure(err)) }
            if let data = data {
                DispatchQueue.main.async {
                    completion(Result {
                        let screeningResponse = try JSONDecoder().decode(ScreeningResponse.self, from: data)
                        return screeningResponse.data
                    })
                }
            }
        }
        task.resume()
    }
}
















