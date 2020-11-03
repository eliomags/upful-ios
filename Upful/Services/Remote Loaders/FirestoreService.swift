//
//  FirestoreService.swift
//  Upful
//
//  Created by Yanik Simpson on 11/5/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol FirestoreService {
    associatedtype T
    associatedtype U
    func fetch(from : T, completion: U)
}

public class FirestoreAPI: FirestoreService {
    typealias FirestoreFetchCompletion<T> = (Result<[T],Error>) -> Void
    
    public enum Collection: String {
        case popularStocks
        case savedCompanies
        case suggestions
        case screeners
        case engagement
        case users
    }
    
    // MARK: - API
    
    let db = Firestore.firestore()
    
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


