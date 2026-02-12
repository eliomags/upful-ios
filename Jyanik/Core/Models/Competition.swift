//
//  Competition.swift
//  Jyanik
//
//  Codable API model for a trading competition.
//  Not persisted locally -- used for JSON decoding from the API.
//

import Foundation

struct Competition: Codable, Identifiable {
    let id: String
    let type: String
    let status: String
    let startDate: String
    let endDate: String
    let totalPrizePool: Double
    let participantCount: Int
    let createdAt: String
}
