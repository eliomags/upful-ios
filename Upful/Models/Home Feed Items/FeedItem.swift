//
//  Company.swift
//  Upful
//
//  Created by Yanik Simpson on 8/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol FeedItem {
    var header: String { get }
    var details: String { get }
}

struct PopularCompany: FeedItem {
    var header: String
    var details: String
    var url: String {
        return "https://storage.googleapis.com/iex/api/logos/\(header).png"
    }
    var price: Double?
    var marketcap: Double?
    var priceToEarnings: Double?
    
    init(details: String, header: String) {
        self.details = details
        self.header = header
    }
}


