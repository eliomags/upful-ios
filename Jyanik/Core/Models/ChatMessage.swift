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
        guard let date = Self.isoFormatterFractional.date(from: createdAt)
                ?? Self.isoFormatterBasic.date(from: createdAt) else {
            return createdAt
        }
        return Self.relativeDateFormatter.string(from: date)
    }

    // MARK: - Cached Formatters

    private static let isoFormatterFractional: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    private static let isoFormatterBasic = ISO8601DateFormatter()

    private static let relativeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}
