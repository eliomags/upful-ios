//
//  Protocols.swift
//  Upful
//
//  Created by Yanik Simpson on 10/10/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

protocol DataManager: class {
    associatedtype T
    associatedtype U
    var data: [U] { get set }
    func remove(_ item: T)
    func update(_ item: T)
    func save()
}

protocol NetworkManager {
    associatedtype T
    func get(urlString: String, completion: Result<T,Error>)
}

extension NetworkManager {
    var apiKey: String {
        return Constants.Intrinio.apiKey
    }
}

