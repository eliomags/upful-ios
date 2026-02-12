//
//  ChatService.swift
//  Jyanik
//
//  Manages the in-app chat: fetching, sending, and reporting messages
//

import Foundation
import Observation
import OSLog

@Observable
final class ChatService {

    // MARK: - State

    private(set) var messages: [ChatMessageDTO] = []
    private(set) var isLoading = false
    private(set) var hasMoreMessages = true

    // MARK: - Dependencies

    private let apiClient: APIClient
    private let logger = Logger(subsystem: "com.jyanik", category: "ChatService")

    // MARK: - Init

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - Fetch Messages

    /// Fetches chat messages with cursor-based pagination.
    /// - Parameters:
    ///   - before: Message ID to paginate before (for loading older messages).
    ///   - limit: Number of messages to fetch per page.
    func fetchMessages(before: String? = nil, limit: Int = 50) async throws {
        isLoading = true
        defer { isLoading = false }

        let endpoint = SocialEndpoints.getChatMessages(before: before, limit: limit)
        let fetched: [ChatMessageDTO] = try await apiClient.request(endpoint)

        if before == nil {
            // Initial load
            messages = fetched
        } else {
            // Append older messages
            messages.append(contentsOf: fetched)
        }

        hasMoreMessages = fetched.count >= limit

        logger.info("[Chat] Fetched \(fetched.count) messages (before: \(before ?? "nil"))")
    }

    // MARK: - Send Message

    /// Sends a new chat message. Returns the created message.
    @discardableResult
    func sendMessage(
        content: String,
        imageKey: String? = nil,
        tickers: [String]? = nil
    ) async throws -> ChatMessageDTO {
        let endpoint = SocialEndpoints.sendChatMessage(
            content: content,
            imageKey: imageKey,
            tickers: tickers
        )
        let message: ChatMessageDTO = try await apiClient.request(endpoint)

        // Prepend to local list (newest first)
        messages.insert(message, at: 0)

        logger.info("[Chat] Sent message: \(message.id)")
        return message
    }

    // MARK: - Report Message

    /// Reports a message for moderation.
    func reportMessage(id: String) async throws {
        let endpoint = SocialEndpoints.reportMessage(id: id)
        try await apiClient.requestNoContent(endpoint)

        logger.info("[Chat] Reported message: \(id)")
    }

    // MARK: - Helpers

    /// Clears all local messages (e.g., on logout).
    func clearMessages() {
        messages = []
        hasMoreMessages = true
    }
}
