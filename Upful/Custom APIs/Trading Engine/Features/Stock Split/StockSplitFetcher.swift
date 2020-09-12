//
//  StockSplitFetcher.swift
//  Upful
//
//  Created by Yanik Simpson on 8/15/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

final class StockSplitFetcher {
    
    typealias DataDownloader = (String, @escaping DataCompletionHandler) -> ()
    var dataDownloader: DataDownloader = HTTPClient().downloadContent
    
    func createEndpoint(_ ticker: String) -> String {
        let endpoint = Constants.IEXTrading.EndPoints.production
        let param = "splits/1yr"
        let key = Constants.IEXTrading.productionKey
        return endpoint + ticker + param + key
    }
    
    func getStockSplit(for ticker: String,
                       _ completion: @escaping (Result<[StockSplit], Error>) -> Void) {
        let endpoint = createEndpoint(ticker)
        dataDownloader(endpoint) { result in
            guard let data = try? result.get() else {
                completion(.failure(NetworkError.connection))
                return
            }
            let decoder = JSONDecoder()
            let splitData = try? decoder.decode([StockSplit].self, from: data)
            completion(.success(splitData ?? []))
        }
    }
    
}
