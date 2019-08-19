//
//  Company.swift
//  Upful
//
//  Created by Yanik Simpson on 8/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol HomeFeedItem {
    var header: String { get }
    var details: String { get }
}

struct PopularCompany: HomeFeedItem {
    var header: String
    var details: String
    var url: String {
        return "https://storage.googleapis.com/iex/api/logos/\(header).png"
    }
    
    init(details: String, header: String) {
        self.details = details
        self.header = header
    }
}


