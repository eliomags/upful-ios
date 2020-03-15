//
//  TransactionDataType.swift
//  Upful
//
//  Created by Yanik Simpson on 3/15/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

protocol TransactionDataType: class {
    var ticker: String { get set }
    var numberOfShares: Int32 { get set }
    var averagePrice: Double { get set }
    var currentPrice: Double { get set }
    var type: String? { get set }
    var transactionDate: String? { get set }
}
