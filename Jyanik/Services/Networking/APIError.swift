//
//  APIError.swift
//  Jyanik
//
//  API error types for the networking layer
//

import Foundation

// MARK: - API Error

enum APIError: Error, LocalizedError {
    case unauthorized
    case forbidden
    case notFound
    case conflict
    case validationError(message: String)
    case serverError(statusCode: Int)
    case networkError(Error)
    case decodingError(Error)
    case timeout
    case noData
    case unknown(statusCode: Int)

    // MARK: - Factory

    static func from(statusCode: Int, responseBody: String? = nil) -> APIError {
        switch statusCode {
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 409:
            return .conflict
        case 422:
            let message = responseBody ?? "Validation failed"
            return .validationError(message: message)
        case 500...599:
            return .serverError(statusCode: statusCode)
        default:
            return .unknown(statusCode: statusCode)
        }
    }

    // MARK: - Helpers

    var isRetryable: Bool {
        switch self {
        case .serverError, .timeout, .networkError:
            return true
        default:
            return false
        }
    }

    // MARK: - LocalizedError

    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Your session has expired. Please sign in again."
        case .forbidden:
            return "You don't have permission to perform this action."
        case .notFound:
            return "The requested resource was not found."
        case .conflict:
            return "A conflict occurred. The resource may already exist."
        case .validationError(let message):
            return message
        case .serverError(let statusCode):
            return "Server error occurred (HTTP \(statusCode)). Please try again later."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError:
            return "Failed to process the server response."
        case .timeout:
            return "The request timed out. Please check your connection and try again."
        case .noData:
            return "No data received from the server."
        case .unknown(let statusCode):
            return "An unexpected error occurred (HTTP \(statusCode))."
        }
    }
}
