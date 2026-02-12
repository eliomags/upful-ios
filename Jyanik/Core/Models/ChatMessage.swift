//
//  ChatMessage.swift
//  Jyanik
//
//  Codable API model for a chat message in competition chat rooms.
//  Not persisted locally -- used for JSON decoding from the API.
//

import Foundation

struct ChatMessage: Codable, Identifiable {
    let id: String
    let userId: String
    let username: String
    let content: String?
    let imageKey: String?
    let tickers: String?
    let isDeleted: Bool
    let createdAt: String

    // MARK: - Computed Properties

    var tickerArray: [String] {
        guard let tickers, !tickers.isEmpty else { return [] }
        return tickers
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    var formattedDate: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = formatter.date(from: createdAt)
                ?? ISO8601DateFormatter().date(from: createdAt) else {
            return createdAt
        }

        let displayFormatter = DateFormatter()
        displayFormatter.doesRelativeDateFormatting = true
        displayFormatter.dateStyle = .short
        displayFormatter.timeStyle = .short
        return displayFormatter.string(from: date)
    }
}
