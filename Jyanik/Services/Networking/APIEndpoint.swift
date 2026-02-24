//
//  APIEndpoint.swift
//  Jyanik
//
//  API endpoint definition for building URLRequests
//

import Foundation

// MARK: - HTTP Method

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

// MARK: - API Endpoint

struct APIEndpoint {
    let path: String
    let method: HTTPMethod
    let queryItems: [URLQueryItem]?
    let body: (any Encodable)?
    let headers: [String: String]?
    let requiresAuth: Bool

    init(
        path: String,
        method: HTTPMethod = .get,
        queryItems: [URLQueryItem]? = nil,
        body: (any Encodable)? = nil,
        headers: [String: String]? = nil,
        requiresAuth: Bool = true
    ) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.body = body
        self.headers = headers
        self.requiresAuth = requiresAuth
    }

    // MARK: - Build URLRequest

    func urlRequest(baseURL: String) throws -> URLRequest {
        guard var components = URLComponents(string: baseURL + path) else {
            throw URLError(.badURL)
        }

        if let queryItems, !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // Apply custom headers
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        // Encode body using shared encoder (avoids duplicate allocation)
        if let body {
            request.httpBody = try APIClient.sharedEncoder.encode(AnyEncodable(body))
        }

        return request
    }
}

// MARK: - AnyEncodable

/// Type-erased Encodable wrapper to allow storing `any Encodable` in APIEndpoint.
struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void

    init(_ value: any Encodable) {
        _encode = { encoder in
            try value.encode(to: encoder)
        }
    }

    func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}
