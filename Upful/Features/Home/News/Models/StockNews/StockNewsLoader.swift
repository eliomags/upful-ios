//
//  StockNewsLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 12/27/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

class StockNewsLoader {
    enum Router {
        case getTickerNews(tickers: String)
        case getTickerBatchNews(tickers: String)
        case getMarketNews
        
        var scheme: String {
          switch self {
          case .getTickerNews, .getTickerBatchNews, .getMarketNews:
            return "https"
          }
        }
        
        var host: String {
          switch self {
          case .getTickerNews, .getTickerBatchNews, .getMarketNews:
            return "stocknewsapi.com"
          }
        }
        
        var path: String {
            switch self {
            case .getTickerNews, .getTickerBatchNews, .getMarketNews:
                return "/api/v1"
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
                    URLQueryItem(name: "items", value: "15"),
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
            }
        }
        
        var method: String {
          switch self {
            case .getTickerNews, .getTickerBatchNews, .getMarketNews:
              return "GET"
          }
        }
    
    }
}

extension StockNewsLoader {
    typealias StockNewsCompletion = (Result<[StockNews],Error>) -> Void
    
    func get(router: Router, completion: @escaping StockNewsCompletion) {
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.queryItems = router.parameters
        
        guard let url = components.url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                completion(Result{
                    let stockNews = try JSONDecoder().decode(StockNewsData.self, from: data)
                    return stockNews.data
                })
            }
        }
        task.resume()
    }
}

struct StockNewsData: Decodable {
    let data: [StockNews]
}

struct StockNews: Decodable {
    let newsUrl: String
    let imageUrl: String
    let title: String
    let text: String
    let sourceName: String
    let date: String
    let sentiment: String
    let tickers: [String]
    
    enum CodingKeys: String, CodingKey {
        case newsUrl = "news_url"
        case imageUrl = "image_url"
        case title, text
        case sourceName = "source_name"
        case date, sentiment, tickers
    }
}






