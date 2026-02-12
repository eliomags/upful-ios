//
//  PayoutEndpoints.swift
//  Jyanik
//
//  Created by Claude Code on 2026-02-12.
//  Copyright © 2026 Upful. All rights reserved.
//

import Foundation

// MARK: - Payout Method

enum PayoutMethod: String, Codable, CaseIterable, Identifiable {
    case stripe = "stripe"
    case paypal = "paypal"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .stripe:
            return "Stripe"
        case .paypal:
            return "PayPal"
        }
    }

    var icon: String {
        switch self {
        case .stripe:
            return "creditcard.fill"
        case .paypal:
            return "dollarsign.circle.fill"
        }
    }
}

// MARK: - Payout Endpoints

enum PayoutEndpoints {
    static func getPayoutHistory() -> APIEndpoint {
        APIEndpoint(
            path: "/api/payouts/history",
            method: .get
        )
    }

    static func requestPayout(amount: Double, method: PayoutMethod) -> APIEndpoint {
        let body = PayoutRequestBody(amount: amount, method: method.rawValue)
        return APIEndpoint(
            path: "/api/payouts/request",
            method: .post,
            body: body
        )
    }

    static func getPayoutBalance() -> APIEndpoint {
        APIEndpoint(
            path: "/api/payouts/balance",
            method: .get
        )
    }
}
