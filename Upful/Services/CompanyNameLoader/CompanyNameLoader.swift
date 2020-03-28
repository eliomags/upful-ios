//
//  CompanyNameLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 3/28/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

final class CompanyNameLoader {
    func loadName(for ticker: String, completion: @escaping (Result<String,Error>) -> Void) {
        let urlString = "https://api-v2.intrinio.com/companies/\(ticker)?\(Constants.Intrinio.apiKey)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            
            guard let data = data else {
                return
            }
            
            let stock = try? JSONDecoder().decode(Stock.self, from: data)
            completion(.success(stock?.name ?? ""))
        }
        task.resume()
    }
}
