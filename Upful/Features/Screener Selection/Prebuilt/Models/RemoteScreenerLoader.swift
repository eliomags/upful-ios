//
//  RemoteScreenerLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 1/6/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

protocol RemoteScreenerLoaderProtocol {
    typealias ScreenerLoadCompletion = (Result<[ScreenerViewModel],Error>) -> Void
    func load(completion: @escaping ScreenerLoadCompletion)
}

class RemoteScreenerLoader: RemoteScreenerLoaderProtocol {
    
    private let remoteService: FirestoreAPI

    init(remoteService: FirestoreAPI = .init()) {
        self.remoteService = remoteService
    }
    
    func load(completion: @escaping ScreenerLoadCompletion) {
        remoteService.fetch(from: .screeners) { (result) in
            switch result {
            case .success(let screenerDocs):
                if let screenerItems = screenerDocs as? [[String: Any]] {
                    completion(Result {
                        return try self.map(items: screenerItems)
                    })
                } else {
                    completion(.failure(NSError()))
                }
            case .failure(_):
                break
            }
        }
    }
    
    fileprivate func map(items: [[String: Any]]) throws -> [ScreenerViewModel] {
        return (try items.map { (dictionary) -> ScreenerViewModel in
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            let viewModel = try JSONDecoder().decode(ScreenerViewModel.self, from: jsonData)
            return viewModel
        })
    }
}

struct ScreenerViewModel {
    let title: String
    let description: String
    let imageUrlString: String
    let searchParameters: [String]
    var counter: Int
}

extension ScreenerViewModel: Codable {}
