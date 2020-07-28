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
    case urlError
}

typealias DownloadCompletionHandler = (Result<Data,Error>) -> ()

final class NetworkService {
    
    private let allowedDiskSize = 100 * 1024 * 1024
    private lazy var cache: URLCache = {
        return URLCache(memoryCapacity: 0, diskCapacity: allowedDiskSize, diskPath: "upfulCache")
    }()

    func downloadContentWithCache(fromUrlString: String, completionHandler: @escaping DownloadCompletionHandler) {
        guard let downloadUrl = URL(string: fromUrlString) else { return }
        let urlRequest = URLRequest(url: downloadUrl)

        if let cachedData = cache.cachedResponse(for: urlRequest) {
            completionHandler(.success(cachedData.data))
        } else {
            createAndRetrieveURLSession().dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    completionHandler(.failure(error))
                } else {
                    let cachedData = CachedURLResponse(response: response!, data: data!)
                    self.cache.storeCachedResponse(cachedData, for: urlRequest)
                    completionHandler(.success(data!))
                }
            }.resume()
        }
    }
    
    func downloadContent(fromUrlString: String, completionHandler: @escaping DownloadCompletionHandler) {
        guard let downloadUrl = URL(string: fromUrlString) else { return }
        let urlRequest = URLRequest(url: downloadUrl)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else {
                let cachedData = CachedURLResponse(response: response!, data: data!)
                self.cache.storeCachedResponse(cachedData, for: urlRequest)
                completionHandler(.success(data!))
            }
        }.resume()
    }
    
    private func createAndRetrieveURLSession() -> URLSession {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
        sessionConfiguration.urlCache = cache
        return URLSession(configuration: sessionConfiguration)
    }
}






















