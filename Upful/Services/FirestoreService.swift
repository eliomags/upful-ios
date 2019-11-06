//
//  FirestoreService.swift
//  Upful
//
//  Created by Yanik Simpson on 11/5/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation
import Firebase

protocol FirestoreService {
    associatedtype T
    associatedtype U
    func update(to : T)
    func fetch(from : T, completion: U)
}

class FirestoreAPI: FirestoreService {
    typealias FirestoreFetchCompletion<T> = (Result<[T],Error>) -> Void
    
    enum Collection: String {
        case popularStocks
        case savedCompanies
        case suggestions
    }
    
    // MARK: - API
    
    func update(to collection: Collection) {
        
    }
    
    func fetch(from collection: Collection, completion: @escaping FirestoreFetchCompletion<Any>) {
        let db = Firestore.firestore()
        let collectionPath = collection.rawValue
        db.collection(collectionPath).getDocuments { (snapshot, err) in
            if let error = err {
                completion(.failure(error))
            } else {
                var fetchedData = [Any]()
                for document in snapshot!.documents {
                    fetchedData.append(document.data())
//                    print("\(document.documentID) => \(document.data())")
                }
                completion(.success(fetchedData))
            }
        }
    }
}


