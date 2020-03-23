//
//  Holding.swift
//  Upful
//
//  Created by Yanik Simpson on 3/22/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

struct Holding {
    private(set) var transactions: [Transaction]
    
    var ticker: [String] {
        let copy = transactions.map { $0.ticker }
        
        return copy
    }
    
    init(transactions: [Transaction]) {
        self.transactions = transactions
    }
}
