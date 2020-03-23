//
//  Holding.swift
//  Upful
//
//  Created by Yanik Simpson on 3/22/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

struct Holding {
    let ticker: String
    private(set) var transactions: [Transaction]
    
    
    init(ticker: String, transactions: [Transaction]) {
        self.ticker = ticker
        self.transactions = transactions
    }
}
