//
//  UpfulProducts.swift
//  Upful
//
//  Created by Yanik Simpson on 10/22/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

public struct UpfulProducts {
    enum ProductID: String, CaseIterable {
        case oneMonth = "com.syanik.Upful.Yanik.MonthlySubscription"
    }
    
    static let productIds: Set<String> = Set(UpfulProducts.ProductID.allCases.map({ $0.rawValue }))
//    public static let store = PaymentService(productIDs: productIds)
}
