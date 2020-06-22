//
//  HistoricalPriceLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 6/21/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

struct ChartDataPointCollection: Codable {
    let range: String
    let data: [ChartDataPoint]
}

class ChartDataPoint: Codable, Hashable {
    static func == (lhs: ChartDataPoint, rhs: ChartDataPoint) -> Bool {
        return lhs.date == rhs.date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
    
    let date: String
    let close: Double
    let changeOverTime: Double
}

class HistoricalPriceLoader {
    
    enum TimePeriod: String, CaseIterable {
        case oneDay = "dynamic"
        case fiveDay = "5d"
        case oneMonth = "1m"
        case threeMonth = "3m"
        case sixMonth = "6m"
        case yearToDate = "ytd"
        case oneYear = "1y"
        case fiveYear = "5y"
        
        var explicit: String {
            switch self {
            case .oneDay:
                return "1D"
            default:
                return self.rawValue.capitalized
            }
        }
    }
    
    enum RequestBuilder {
        case sandbox
        case production
        
        private static let urlComponent = "chart"
        
        static func build(environment: RequestBuilder = .sandbox, ticker: String, period: TimePeriod) -> URLRequest {
            let baseURL: String
            let token: String
            
            switch environment {
            case .sandbox:
                token = Constants.IEXTrading.sandboxKey
                baseURL = Constants.IEXTrading.EndPoints.sandbox
            case .production:
                token = Constants.IEXTrading.productionKey
                baseURL = Constants.IEXTrading.EndPoints.production
            }
            
            guard let url = URL(string: baseURL + ticker + "/" + urlComponent + "/" + period.rawValue + token) else {
                fatalError("Error Constructing URL")
            }
            return URLRequest(url: url)
        }
    }
    
    private(set) var cache: [TimePeriod: [ChartDataPoint]] = [:]
    
    typealias HistoricalPriceLoaderCompletion = (Result<[ChartDataPoint], NetworkError>) -> Void
    func load(ticker: String, period: TimePeriod, completion: @escaping HistoricalPriceLoaderCompletion) {
        
        if let cachedResponse = cache[period] {
            completion(.success(cachedResponse))
            return
        }
        
        let request = RequestBuilder.build(ticker: ticker, period: period)
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, _, error) in
            if let _ = error {
                completion(.failure(.connection))
            }
            
            if let data = data {
                do {
                    let datapoints = try self.parse(data: data, timePeriod: period)
                    self.cache[period] = datapoints
                    
                    completion(.success(datapoints))
                } catch {
                    completion(.failure(.parsing))
                }
            } else {
                completion(.failure(.invalidData))
            }
        }
        .resume()
    }
    
    func parse(data: Data, timePeriod: TimePeriod) throws -> [ChartDataPoint] {
        let chartDataPoints: [ChartDataPoint]
        
        switch timePeriod {
        case .oneDay:
            let dataPointCollection = try JSONDecoder().decode(ChartDataPointCollection.self, from: data)
            chartDataPoints = dataPointCollection.data
        default:
            chartDataPoints = try JSONDecoder().decode([ChartDataPoint].self, from: data)
        }
    
        return chartDataPoints
    }
}
