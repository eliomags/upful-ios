//
//  JFormatters.swift
//  Jyanik
//
//  Centralized formatters to avoid duplicate allocations across ViewModels
//

import Foundation

enum JFormatters {

    // MARK: - Currency

    /// Formats currency with zero decimals (e.g. "$5,000").
    static let currencyWhole: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "USD"
        f.maximumFractionDigits = 0
        return f
    }()

    /// Formats currency with 2 decimals (e.g. "$5,000.50").
    static let currency: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "USD"
        f.maximumFractionDigits = 2
        return f
    }()

    // MARK: - Date

    /// Medium date format (e.g. "Feb 20, 2026").
    static let mediumDate: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()

    // MARK: - ISO 8601

    /// ISO 8601 with fractional seconds.
    static let isoFractional: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    /// ISO 8601 basic (no fractional seconds).
    static let isoBasic: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()

    // MARK: - Helpers

    /// Formats a currency amount with zero decimals.
    static func prizePool(_ amount: Double) -> String {
        currencyWhole.string(from: NSNumber(value: amount)) ?? "$\(Int(amount))"
    }

    /// Formats a currency amount with 2 decimals.
    static func formatCurrency(_ value: Double) -> String {
        currency.string(from: NSNumber(value: value)) ?? "$\(String(format: "%.2f", value))"
    }

    /// Parses an ISO date string and returns a medium-formatted date string.
    static func mediumDateString(from dateString: String) -> String {
        if let date = isoFractional.date(from: dateString) {
            return mediumDate.string(from: date)
        }
        if let date = isoBasic.date(from: dateString) {
            return mediumDate.string(from: date)
        }
        // Fallback: try simple date format
        let simple = DateFormatter()
        simple.dateFormat = "yyyy-MM-dd"
        if let date = simple.date(from: dateString) {
            return mediumDate.string(from: date)
        }
        return dateString
    }
}
