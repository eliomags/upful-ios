//
//  HistoricalPriceLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 6/21/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

struct IntraDayDataPoint: Codable {
    let label: String
    let date: String
    let average: Double?
}

extension Array where Element == IntraDayDataPoint {
    
    func convertToChartDataPoints() -> [ChartDataPoint] {
        return self.map { intraDayObject -> ChartDataPoint in
            let label: String
            
            let now = Date()
            let convertedDate = DateTransformer.convertStringToDate(intraDayObject.date)

            let isToday = Calendar.current.isDate(convertedDate, inSameDayAs: now)
            let estTimezone = " EST"
            
            if isToday {
                label = intraDayObject.label.appending(estTimezone)
            } else {
                let transformedDate = DateTransformer.convertToMonthAbbreviation(convertedDate)
                label = transformedDate + ":" + intraDayObject.label.appending(estTimezone)
            }
            
            return ChartDataPoint(label: label, close: intraDayObject.average)
        }
    }
}

class ChartDataPoint: Codable, Hashable {
    static func == (lhs: ChartDataPoint, rhs: ChartDataPoint) -> Bool {
        return lhs.label == rhs.label
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
    
    let label: String
    let close: Double?
    
    init(label: String, close: Double?) {
        self.label = label
        self.close = close
    }
}

class HistoricalPriceLoader {
    
    enum TimePeriod: String, CaseIterable {
        case oneDay
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
        
        private static let chartComponent = "chart"
        private static let intraDayComponent = "intraday-prices/chartInterval=15"
        
        static func buildDaily(environment: RequestBuilder, ticker: String) -> URLRequest {
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
            
            guard let url = URL(string: baseURL + ticker + "/" + intraDayComponent + token) else {
                fatalError("Error Constructing URL")
            }
            
            return URLRequest(url: url)
        }
        
        static func build(environment: RequestBuilder, ticker: String, period: TimePeriod) -> URLRequest {
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
            
            guard let url = URL(string: baseURL + ticker + "/" + chartComponent + "/" + period.rawValue + token) else {
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
        
        let session = URLSession.shared
        let request = constructRequest(for: period, ticker: ticker)
        
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
    
    private func parse(data: Data, timePeriod: TimePeriod) throws -> [ChartDataPoint] {
        let chartDataPoints: [ChartDataPoint]
        
        switch timePeriod {
        case .oneDay:
            let dataPointCollection = try JSONDecoder().decode([IntraDayDataPoint].self, from: data)
            chartDataPoints = dataPointCollection.convertToChartDataPoints()
        default:
            chartDataPoints = try JSONDecoder().decode([ChartDataPoint].self, from: data)
        }
    
        return chartDataPoints
    }
    
    // MARK: Private Helper
    
    private func constructRequest(for timePeriod: TimePeriod, ticker: String) -> URLRequest {
        let request: URLRequest
        let environment = RequestBuilder.production
        
        switch timePeriod {
        case .oneDay:
            request = RequestBuilder.buildDaily(environment: environment, ticker: ticker)
        default:
            request = RequestBuilder.build(environment: environment, ticker: ticker, period: timePeriod)
        }
        
        return request
    }
}

extension DateTransformer {
    
    fileprivate static func convertToMonthAbbreviation(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        return dateFormatter.string(from: date)
    }
}

