//
//  PayoutDTOs.swift
//  Jyanik
//
//  Created by Claude Code on 2026-02-12.
//  Copyright © 2026 Upful. All rights reserved.
//

import Foundation

// MARK: - Payout Balance DTO

struct PayoutBalanceDTO: Decodable {
    let availableBalance: Double
    let pendingBalance: Double
    let totalEarned: Double
    let currency: String
}

// MARK: - Payout History Item DTO

struct PayoutHistoryItemDTO: Decodable, Identifiable {
    let id: String
    let amount: Double
    let method: String
    let status: String  // "completed", "pending", "failed"
    let requestedAt: String
    let completedAt: String?
}

// MARK: - Payout Request Body

struct PayoutRequestBody: Encodable {
    let amount: Double
    let method: String
}

// MARK: - Payout Status Helper

extension PayoutHistoryItemDTO {
    var statusBadgeColor: (text: String, background: String) {
        switch status.lowercased() {
        case "completed":
            return ("success", "success")
        case "pending":
            return ("warning", "warning")
        case "failed":
            return ("error", "error")
        default:
            return ("textSecondary", "surfaceSecondary")
        }
    }

    var statusDisplayText: String {
        status.capitalized
    }
}
