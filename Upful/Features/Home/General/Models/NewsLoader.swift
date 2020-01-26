//
//  StockNewsLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 12/27/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

class NewsLoader {
    enum Router {
        case getTickerNews(tickers: String)
        case getTickerBatchNews(tickers: String)
        case getMarketNews
        case getBatchMarketNews
        
        var scheme: String {
          switch self {
          case .getTickerNews, .getTickerBatchNews, .getMarketNews, .getBatchMarketNews:
            return "https"
          }
        }
        
        var host: String {
          switch self {
          case .getTickerNews, .getTickerBatchNews, .getMarketNews, .getBatchMarketNews:
            return "stocknewsapi.com"
          }
        }
        
        var path: String {
            switch self {
            case .getTickerNews, .getTickerBatchNews:
                return "/api/v1"
            case .getMarketNews, .getBatchMarketNews:
                return "/api/v1/category"
            }
        }
        
        var parameters: [URLQueryItem] {
            let apiKey = Constants.StockNewsAPI.token

            switch self {
            case .getTickerNews(let savedTickers):
                return [
                    URLQueryItem(name: "tickers", value: savedTickers),
                    URLQueryItem(name: "items", value: "3"),
                    URLQueryItem(name: "type", value: "article"),
                    URLQueryItem(name: "token", value: apiKey)
                ]
            case .getTickerBatchNews(let savedTickers):
                return [
                    URLQueryItem(name: "tickers", value: savedTickers),
                    URLQueryItem(name: "items", value: "8"),
                    URLQueryItem(name: "type", value: "article"),
                    URLQueryItem(name: "token", value: apiKey)
                ]
            case .getMarketNews:
              return [
                    URLQueryItem(name: "section", value: "general"),
                    URLQueryItem(name: "items", value: "3"),
                    URLQueryItem(name: "type", value: "article"),
                    URLQueryItem(name: "token", value: apiKey)
                ]
            case .getBatchMarketNews:
                return [
                    URLQueryItem(name: "section", value: "general"),
                    URLQueryItem(name: "items", value: "8"),
                    URLQueryItem(name: "type", value: "article"),
                    URLQueryItem(name: "token", value: apiKey)
                ]
            }
        }
        
        var method: String {
          switch self {
          case .getTickerNews, .getTickerBatchNews, .getMarketNews, .getBatchMarketNews:
              return "GET"
          }
        }
    }
}

protocol NewsLoaderProtocol {
    typealias StockNewsCompletion = (Result<[StockNews],NetworkingError>) -> Void
    func get(router: NewsLoader.Router, completion: @escaping StockNewsCompletion)
}

extension NewsLoader: NewsLoaderProtocol {
    func get(router: Router, completion: @escaping StockNewsCompletion) {
//        var components = URLComponents()
//        components.scheme = router.scheme
//        components.host = router.host
//        components.path = router.path
//        components.queryItems = router.parameters
//
//        guard let url = components.url else { return }
//
//        let task = URLSession.shared.dataTask(with: url) { (data, response, err) in
//            DispatchQueue.main.async {
//                if let _ = err { completion(.failure(.urlError)) }
//                guard let data = data else {
//                    completion(.failure(.noData))
//                    return
//                }
//                if let stockNews = try? JSONDecoder().decode(StockNewsData.self, from: data) {
//                    completion(.success(stockNews.data))
//                } else {
//                    completion(.failure(.parsingError))
//                }
//            }
//        }
//        task.resume()
        
        completion(.success([]))

    }
}





