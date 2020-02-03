//
//  RemoteScreenerLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 1/6/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation
import Firebase

protocol RemoteScreenerLoaderProtocol {
    typealias ScreenerLoadCompletion = (Result<[ScreenerViewModel],Error>) -> Void
    func load(completion: @escaping ScreenerLoadCompletion)
    static func incrementScreenerInterest(documentID: String)
}

class RemoteScreenerLoader: RemoteScreenerLoaderProtocol {
    private static var remoteService: FirestoreAPI = FirestoreAPI()

    init(remoteService: FirestoreAPI = .init()) {
        RemoteScreenerLoader.remoteService = remoteService
    }
    
    func load(completion: @escaping ScreenerLoadCompletion) {
        RemoteScreenerLoader.remoteService.fetch(from: .screeners) { (result) in
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
                completion(.failure(NSError()))
            }
        }
    }
    
    class func incrementScreenerInterest(documentID: String) {
        print("Incrementing", documentID)
//        let collection = FirestoreAPI.Collection.screeners.rawValue
//        let docRef = remoteService.db.collection(collection).document(documentID)
//        docRef.updateData([
//            "interest": FieldValue.increment(Int64(1))
//        ])
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
    var interest: Int
    let documentID: String?
}

extension ScreenerViewModel: Codable {}
