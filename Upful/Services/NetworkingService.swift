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

final class NetworkService {
    static let shared = NetworkService()
    
    let intrioAPI = IntrinioAPI()
    
    
    private init() {}
}






















