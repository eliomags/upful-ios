//
//  PopularCompanyViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 10/16/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation
//import Firebase
//
//enum FirestoreCollection: String {
//    case popularStocks
//}
//
//enum FirestoreDocuments: String {
//    case popularStocks = "popular_stocks"
//}
//
//
//class FirestoreService {
//
//    init() {}
//    
//    func get(completion: @escaping (Result<[String],Error>) -> Void) {
//        let docRef = Firestore.firestore()
//            .collection(FirestoreCollection.popularStocks.rawValue)
//            .document(FirestoreDocuments.popularStocks.rawValue)
//        
//        docRef.getDocument { (document, error) in
//            if let error = error {
//                completion(.failure(error))
//            }
//        if let stock = document.flatMap({
//              $0.data().flatMap({ (data) in
//                return data["stocks"]
//              })
//            }) {
//            completion(.success(stock as! [String] ))
//            } else {
//                completion(.success([]))
//            }
//        }
//    }
//}
//
//
//class PopularCompanyViewModel {
//    // MARK: - Dependencies
//    
//    let firestoreService: FirestoreService
//    let intrinioAPI: IntrinioAPI
//    
//    let dispatchGroup = DispatchGroup()
//    
//    // MARK: - State
//    
//    enum State {
//        case isLoading
//        case loaded
//        case error
//    }
//    
//    var state: State = .isLoading {
//        didSet {
//            
//        }
//    }
//    
//    var stateChanged: ((State) -> ())?
//    
//    func handleStateChange() {
//        
//    }
//
//    // MARK: - Data
//    
//    var popularCompanies: [PopularCompany] = []
//    
//    // MARK: - Initializer
//    
//    init(intrinioAPI: IntrinioAPI = .init(), firestoreService: FirestoreService = .init()) {
//        self.intrinioAPI = intrinioAPI
//        self.firestoreService = firestoreService
//        
//        firestoreService.get { (result) in
//            switch result {
//                
//            case .success(let fetchedData):
//                print(fetchedData)
//            case .failure(let error):
//                print("Error", error.localizedDescription)
//            }
//        }
//    }
//    
//    func popularCompanyFactory(ticker: String) -> PopularCompany {
//        return PopularCompany(details: "", header: ticker)
//    }
//    
//    fileprivate func fetchPopularCompanyData(companies: [String]) {
//        companies.forEach { (popularCompany) in
//            intrinioAPI.fetchStockSpecificFinancial(ticker: popularCompany, financial: .marketcap, frequency: .recent, completion: { (result) in
//                switch result {
//                    
//                case .success(let downloadedData):
//                    if downloadedData.isEmpty { return }
//                
//                case .failure(_):
//                    break
//                }
//            })
//            
//            intrinioAPI.fetchStockSpecificFinancial(ticker: popularCompany, financial: .pricetoearnings, frequency: .recent, completion: { (result) in
//                switch result {
//                    
//                case .success(let downloadedData):
//                    if downloadedData.isEmpty { return }
//                    
//                case .failure(_):
//                    break
//                }
//            })
//        }
//    }
//    
//}
