//
//  TransactionLogger.swift
//  Upful
//
//  Created by Yanik Simpson on 3/17/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

protocol TransactionLogger {
    func log(_ transaction: TransactionDataType, of type: TransactionType, completion: (() -> Void)?)
}
