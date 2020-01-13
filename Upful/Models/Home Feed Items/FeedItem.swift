//
//  Company.swift
//  Upful
//
//  Created by Yanik Simpson on 8/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

class PopularCompany {
    var header: String
    var details: String?
    var price: Double?
    var marketcap: Int?
    var priceToEarnings: Double?
    
    init(details: String, header: String) {
        self.details = details
        self.header = header
    }
}


