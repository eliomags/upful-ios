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
    var data: [SearchResult]
    var resultCount: Int?
    var pageSize: Int?
}

struct SearchResult: Decodable {
    let name: String?
    let ticker: String?
    let marketcap: Int?
}


final class IntrinioAPI {

    private let endpoint = "https://api.intrinio.com/securities/search?"
    let numberOfResults = 20
    private let resultOrder = "&order_column=marketcap&order_direction=desc&primary_only=true&page_size="
    private let apiKey = "&api_key=OjA4ZWY3NTc4YjFlOGUxNTYzNjkwMmEyOGUxNWJkZTRk"
    private var currentPage = 1

    func getScreenRequest(parameters: String, completion: @escaping (Result<[SearchResult],NetworkingError>) -> Void) {
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
            guard let data = data else { return completion(.failure(.noData)) }
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
}
