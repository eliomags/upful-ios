//
//  APIResponse.swift
//  Jyanik
//
//  Generic API response wrapper matching backend format
//

import Foundation

// MARK: - API Response

struct APIResponse<T: Decodable>: Decodable {
    let success: Bool
    let data: T?
    let error: String?
    let pagination: Pagination?
}

// MARK: - Pagination

struct Pagination: Decodable {
    let page: Int
    let limit: Int
    let total: Int
    let totalPages: Int
    let hasMore: Bool

    enum CodingKeys: String, CodingKey {
        case page
        case limit
        case total
        case totalPages = "total_pages"
        case hasMore = "has_more"
    }
}

// MARK: - Empty Response

/// Used for endpoints that return `{ success: true }` with no data payload.
struct EmptyData: Decodable {}
