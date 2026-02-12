//
//  NewsArticle.swift
//  Jyanik
//
//  Codable API model for a financial news article.
//  Not persisted locally -- used for JSON decoding from the API.
//

import Foundation

struct NewsArticle: Codable, Identifiable {
    let id: String
    let title: String
    let summary: String
    let source: String
    let url: String
    let imageUrl: String?
    let publishedAt: String
    let tickers: [String]?
}
