//
//  NetworkingService.swift
//  Upful
//
//  Created by Yanik Simpson on 8/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

enum NetworkingError: Error {
    case failedNetworking
    case noData
    case parsingError
}


final class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    
    func getScreenRequest<T>(url: String, t: T.Type, completion: @escaping (Result<[T],NetworkingError>) -> Void) where T: Decodable {
        guard let url = URL(string: url) else { return }
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
                let fetchedData = try decoder.decode([T].self, from: data)
                print(fetchedData)
                completion(.success(fetchedData))
            } catch {
                completion(.failure(.parsingError))
            }
        }
        task.resume()
    }
    
}






















