//
//  ChartDataPoint.swift
//  Jyanik
//
//  Codable API model for OHLCV chart data.
//  Not persisted locally -- used for JSON decoding from the API.
//

import Foundation

struct ChartDataPoint: Codable, Identifiable {
    let timestamp: Int
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Int

    var id: Int { timestamp }

    var date: Date {
        Date(timeIntervalSince1970: TimeInterval(timestamp))
    }
}
