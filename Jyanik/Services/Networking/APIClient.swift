//
//  APIClient.swift
//  Jyanik
//
//  Actor-based API client with automatic token refresh and retry logic
//

import Foundation
import OSLog

// MARK: - API Client

actor APIClient {

    static let shared = APIClient()

    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let keychain: KeychainService
    private let logger = Logger(subsystem: "com.jyanik", category: "APIClient")
    private let maxRetries = AppConfig.API.maxRetries
    private let baseURL = AppConfig.API.baseURL

    /// Guards against multiple concurrent token refresh attempts.
    private var activeRefreshTask: Task<String, Error>?

    // MARK: - Init

    init(
        keychain: KeychainService = .shared,
        sessionConfiguration: URLSessionConfiguration = .default
    ) {
        self.keychain = keychain

        sessionConfiguration.timeoutIntervalForRequest = AppConfig.API.timeout
        sessionConfiguration.timeoutIntervalForResource = AppConfig.API.timeout * 3
        sessionConfiguration.waitsForConnectivity = true
        self.session = URLSession(configuration: sessionConfiguration)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        self.encoder = encoder
    }

    // MARK: - Public Request Methods

    /// Performs a network request and decodes the response into the specified type.
    ///
    /// Handles automatic token injection, 401 refresh, and retry for transient errors.
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        var lastError: Error = APIError.unknown(statusCode: 0)

        for attempt in 0..<maxRetries {
            do {
                let urlRequest = try await buildRequest(for: endpoint)
                logRequest(urlRequest, attempt: attempt)

                let (data, response) = try await session.data(for: urlRequest)

                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.unknown(statusCode: 0)
                }

                logResponse(httpResponse, data: data)

                // Handle 401 - attempt token refresh once
                if httpResponse.statusCode == 401 && endpoint.requiresAuth {
                    let newToken = try await refreshAccessToken()
                    // Retry the request with the new token
                    var retryRequest = urlRequest
                    retryRequest.setValue("Bearer \(newToken)", forHTTPHeaderField: "Authorization")

                    let (retryData, retryResponse) = try await session.data(for: retryRequest)

                    guard let retryHTTPResponse = retryResponse as? HTTPURLResponse else {
                        throw APIError.unknown(statusCode: 0)
                    }

                    logResponse(retryHTTPResponse, data: retryData)
                    return try handleResponse(retryData, response: retryHTTPResponse)
                }

                return try handleResponse(data, response: httpResponse)

            } catch let error as APIError where error.isRetryable && attempt < maxRetries - 1 {
                lastError = error
                let delay = retryDelay(for: attempt)
                logRetry(attempt: attempt, delay: delay, error: error)
                try await Task.sleep(for: .seconds(delay))
                continue

            } catch let error as URLError where isTransientURLError(error) && attempt < maxRetries - 1 {
                lastError = APIError.networkError(error)
                let delay = retryDelay(for: attempt)
                logRetry(attempt: attempt, delay: delay, error: error)
                try await Task.sleep(for: .seconds(delay))
                continue

            } catch {
                throw error
            }
        }

        throw lastError
    }

    /// Performs a network request that returns no meaningful body (e.g., DELETE, 204).
    func requestNoContent(_ endpoint: APIEndpoint) async throws {
        var lastError: Error = APIError.unknown(statusCode: 0)

        for attempt in 0..<maxRetries {
            do {
                let urlRequest = try await buildRequest(for: endpoint)
                logRequest(urlRequest, attempt: attempt)

                let (data, response) = try await session.data(for: urlRequest)

                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.unknown(statusCode: 0)
                }

                logResponse(httpResponse, data: data)

                // Handle 401 - attempt token refresh once
                if httpResponse.statusCode == 401 && endpoint.requiresAuth {
                    let newToken = try await refreshAccessToken()
                    var retryRequest = urlRequest
                    retryRequest.setValue("Bearer \(newToken)", forHTTPHeaderField: "Authorization")

                    let (retryData, retryResponse) = try await session.data(for: retryRequest)

                    guard let retryHTTPResponse = retryResponse as? HTTPURLResponse else {
                        throw APIError.unknown(statusCode: 0)
                    }

                    logResponse(retryHTTPResponse, data: retryData)
                    try validateStatusCode(retryHTTPResponse, data: retryData)
                    return
                }

                try validateStatusCode(httpResponse, data: data)
                return

            } catch let error as APIError where error.isRetryable && attempt < maxRetries - 1 {
                lastError = error
                let delay = retryDelay(for: attempt)
                logRetry(attempt: attempt, delay: delay, error: error)
                try await Task.sleep(for: .seconds(delay))
                continue

            } catch let error as URLError where isTransientURLError(error) && attempt < maxRetries - 1 {
                lastError = APIError.networkError(error)
                let delay = retryDelay(for: attempt)
                logRetry(attempt: attempt, delay: delay, error: error)
                try await Task.sleep(for: .seconds(delay))
                continue

            } catch {
                throw error
            }
        }

        throw lastError
    }

    // MARK: - Request Building

    private func buildRequest(for endpoint: APIEndpoint) async throws -> URLRequest {
        var request = try endpoint.urlRequest(baseURL: baseURL)

        if endpoint.requiresAuth {
            if let token = try? keychain.loadToken(for: .accessToken) {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }

        return request
    }

    // MARK: - Response Handling

    private func handleResponse<T: Decodable>(_ data: Data, response: HTTPURLResponse) throws -> T {
        try validateStatusCode(response, data: data)

        guard !data.isEmpty else {
            throw APIError.noData
        }

        do {
            // First try to decode as APIResponse wrapper
            let apiResponse = try decoder.decode(APIResponse<T>.self, from: data)

            if apiResponse.success, let responseData = apiResponse.data {
                return responseData
            }

            if let errorMessage = apiResponse.error {
                throw APIError.validationError(message: errorMessage)
            }

            // If success is true but data is nil, try decoding the whole APIResponse as T
            // This handles cases where T itself is APIResponse or the data is at the top level
            throw APIError.noData

        } catch is APIError {
            throw APIError.noData

        } catch let decodingError as DecodingError {
            // Fallback: try decoding `T` directly from the response body
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                logDecodingError(decodingError, data: data)
                throw APIError.decodingError(decodingError)
            }
        }
    }

    private func validateStatusCode(_ response: HTTPURLResponse, data: Data) throws {
        switch response.statusCode {
        case 200...299:
            return
        default:
            let body = String(data: data, encoding: .utf8)
            // Try to extract error message from response JSON
            if let body, let jsonData = body.data(using: .utf8),
               let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
               let errorMessage = json["error"] as? String {
                if response.statusCode == 422 {
                    throw APIError.validationError(message: errorMessage)
                }
            }
            throw APIError.from(statusCode: response.statusCode, responseBody: body)
        }
    }

    // MARK: - Token Refresh

    /// Refreshes the access token. Coalesces concurrent refresh calls into a single network request.
    private func refreshAccessToken() async throws -> String {
        // If a refresh is already in flight, await its result
        if let existingTask = activeRefreshTask {
            return try await existingTask.value
        }

        let task = Task<String, Error> { [weak self] in
            guard let self else { throw APIError.unauthorized }

            guard let refreshToken = try? self.keychain.loadToken(for: .refreshToken) else {
                throw APIError.unauthorized
            }

            let endpoint = AuthEndpoints.refreshToken(refreshToken: refreshToken)
            let request = try endpoint.urlRequest(baseURL: self.baseURL)

            let (data, response) = try await self.session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unknown(statusCode: 0)
            }

            guard httpResponse.statusCode == 200 else {
                // Refresh failed - clear tokens, user needs to re-authenticate
                try? self.keychain.clearAll()
                throw APIError.unauthorized
            }

            let tokenResponse = try self.decoder.decode(
                APIResponse<TokenPair>.self,
                from: data
            )

            guard let tokens = tokenResponse.data else {
                throw APIError.noData
            }

            try self.keychain.saveToken(tokens.accessToken, for: .accessToken)
            try self.keychain.saveToken(tokens.refreshToken, for: .refreshToken)

            return tokens.accessToken
        }

        activeRefreshTask = task

        do {
            let token = try await task.value
            activeRefreshTask = nil
            return token
        } catch {
            activeRefreshTask = nil
            throw error
        }
    }

    // MARK: - Retry Helpers

    private func retryDelay(for attempt: Int) -> Double {
        // Exponential backoff: 1s, 2s, 4s...
        pow(2.0, Double(attempt))
    }

    private func isTransientURLError(_ error: URLError) -> Bool {
        switch error.code {
        case .timedOut, .networkConnectionLost, .notConnectedToInternet,
             .cannotConnectToHost, .cannotFindHost, .dnsLookupFailed:
            return true
        default:
            return false
        }
    }

    // MARK: - Logging (DEBUG only)

    private func logRequest(_ request: URLRequest, attempt: Int) {
        #if DEBUG
        let method = request.httpMethod ?? "?"
        let url = request.url?.absoluteString ?? "nil"
        if attempt > 0 {
            logger.debug("[API] \(method) \(url) (attempt \(attempt + 1))")
        } else {
            logger.debug("[API] \(method) \(url)")
        }
        #endif
    }

    private func logResponse(_ response: HTTPURLResponse, data: Data) {
        #if DEBUG
        let url = response.url?.absoluteString ?? "nil"
        let size = ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: .memory)
        logger.debug("[API] \(response.statusCode) \(url) (\(size))")
        #endif
    }

    private func logRetry(attempt: Int, delay: Double, error: Error) {
        #if DEBUG
        logger.warning("[API] Retry \(attempt + 1)/\(self.maxRetries) after \(delay)s - \(error.localizedDescription)")
        #endif
    }

    private func logDecodingError(_ error: DecodingError, data: Data) {
        #if DEBUG
        let body = String(data: data, encoding: .utf8) ?? "<binary>"
        logger.error("[API] Decoding error: \(error.localizedDescription)")
        logger.error("[API] Response body: \(body.prefix(500))")
        #endif
    }
}

// MARK: - Token Pair (used only for refresh)

private struct TokenPair: Decodable {
    let accessToken: String
    let refreshToken: String
}
