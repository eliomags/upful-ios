//
//  RemoteScreenerLoader.swift
//  Upful
//
//  Created by Yanik Simpson on 1/6/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit
// import FirebaseFirestore // REMOVED: Firebase removed during rebuild

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
//        print("Incrementing", documentID)
        let collection = FirestoreAPI.Collection.screeners.rawValue
        let docRef = remoteService.db.collection(collection).document(documentID)
        docRef.updateData([
            "interest": FieldValue.increment(Int64(1))
        ])
    }
    
    fileprivate func map(items: [[String: Any]]) throws -> [ScreenerViewModel] {
        return (try items.map { (dictionary) -> ScreenerViewModel in
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            let viewModel = try JSONDecoder().decode(ScreenerViewModel.self, from: jsonData)
            return viewModel
        })
    }
}

struct ScreenerViewModel: Codable {
    var title: String
    let description: String
    let searchParameters: [String]
    var interest: Int
    let documentID: String?
    let colorMap: [String: Double]?
    let symbol: String?
    
    init(title: String, description: String, searchParameters: [String],
         interest: Int, documentID: String,
         colorMap: [String: Double]?, symbol: String) {
        self.title = title
        self.description = description
        self.searchParameters = searchParameters
        self.interest = interest
        self.documentID = documentID
        self.colorMap = colorMap
        self.symbol = symbol
    }
}

extension ScreenerViewModel {
    func getColor() -> UIColor {
        guard let colorMap = colorMap else { return UIColor.appAccent2 }
        return UIColor(
            red: CGFloat(colorMap["red"] ?? 0)/255,
            green: CGFloat(colorMap["green"] ?? 0)/255,
            blue: CGFloat(colorMap["blue"] ?? 0)/255,
            alpha: CGFloat(colorMap["alpha"] ?? 1))
    }
    
    func getSymbol() -> UIImage? {
        guard let symbolName = symbol else { return nil }
        return UIImage(systemName: symbolName)?
            .withAlignmentRectInsets(.init(top: -3, left: -3, bottom: -3, right: -3))
            .withTintColor(.white, renderingMode: .alwaysOriginal)
    }
    
    func toScreener() -> Screener {
        return Screener(
            title: title, description: description,
            urlComponents: searchParameters,
            symbol: symbol ?? "pencil",
            colorMap: colorMapToString(),
            id: documentID ?? "")
    }
    
    func colorMapToString() -> String {
        var res = "not set"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self.colorMap ?? [:], options: [])
            let str = String(data: jsonData, encoding: .utf8)
            res = str ?? "Aint got shit"
        } catch {
            res = "error"
        }
        return res
    }
}
