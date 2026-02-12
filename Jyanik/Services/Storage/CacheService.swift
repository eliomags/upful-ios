//
//  CacheService.swift
//  Jyanik
//
//  Simple TTL-based cache using UserDefaults and FileManager for offline data
//

import Foundation
import OSLog

final class CacheService {

    // MARK: - Singleton

    static let shared = CacheService()

    // MARK: - Private

    private let defaults: UserDefaults
    private let fileManager: FileManager
    private let cacheDirectory: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let logger = Logger(subsystem: "com.jyanik", category: "CacheService")

    /// Metadata key prefix for TTL tracking.
    private static let metaPrefix = "cache_meta_"

    // MARK: - Init

    init(
        defaults: UserDefaults = .standard,
        fileManager: FileManager = .default
    ) {
        self.defaults = defaults
        self.fileManager = fileManager

        // Use the app's caches directory
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        self.cacheDirectory = caches.appendingPathComponent("com.jyanik.cache", isDirectory: true)

        // Ensure directory exists
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }

    // MARK: - Save

    /// Saves a Codable value to cache with an optional TTL (in seconds).
    /// - Parameters:
    ///   - key: Unique cache key.
    ///   - value: The value to cache.
    ///   - ttl: Time-to-live in seconds. Pass `nil` for no expiration.
    func save<T: Codable>(_ key: String, value: T, ttl: TimeInterval? = nil) {
        do {
            let data = try encoder.encode(value)
            let fileURL = fileURL(for: key)
            try data.write(to: fileURL, options: .atomic)

            // Store metadata (expiration date)
            let expiration: Date? = ttl.map { Date().addingTimeInterval($0) }
            let meta = CacheMeta(key: key, expiresAt: expiration)
            let metaData = try encoder.encode(meta)
            defaults.set(metaData, forKey: Self.metaPrefix + key)

            logger.debug("[Cache] Saved: \(key) (ttl: \(ttl.map { "\($0)s" } ?? "none"))")
        } catch {
            logger.error("[Cache] Failed to save \(key): \(error.localizedDescription)")
        }
    }

    // MARK: - Load

    /// Loads a cached value. Returns `nil` if not found, expired, or decoding fails.
    func load<T: Codable>(_ key: String) -> T? {
        // Check metadata for expiration
        if let metaData = defaults.data(forKey: Self.metaPrefix + key),
           let meta = try? decoder.decode(CacheMeta.self, from: metaData) {
            if let expiresAt = meta.expiresAt, Date() > expiresAt {
                // Expired - clean up
                clear(key)
                logger.debug("[Cache] Expired: \(key)")
                return nil
            }
        } else {
            // No metadata means no cache entry
            return nil
        }

        // Read file
        let fileURL = fileURL(for: key)
        guard let data = try? Data(contentsOf: fileURL) else {
            return nil
        }

        do {
            let value = try decoder.decode(T.self, from: data)
            logger.debug("[Cache] Hit: \(key)")
            return value
        } catch {
            logger.error("[Cache] Failed to decode \(key): \(error.localizedDescription)")
            return nil
        }
    }

    // MARK: - Clear

    /// Removes a specific cache entry.
    func clear(_ key: String) {
        let fileURL = fileURL(for: key)
        try? fileManager.removeItem(at: fileURL)
        defaults.removeObject(forKey: Self.metaPrefix + key)
        logger.debug("[Cache] Cleared: \(key)")
    }

    /// Removes all cached data.
    func clearAll() {
        // Remove all files in cache directory
        if let files = try? fileManager.contentsOfDirectory(
            at: cacheDirectory,
            includingPropertiesForKeys: nil
        ) {
            for file in files {
                try? fileManager.removeItem(at: file)
            }
        }

        // Remove all metadata keys
        let allKeys = defaults.dictionaryRepresentation().keys
        for key in allKeys where key.hasPrefix(Self.metaPrefix) {
            defaults.removeObject(forKey: key)
        }

        logger.info("[Cache] Cleared all cached data")
    }

    // MARK: - Private

    private func fileURL(for key: String) -> URL {
        // Sanitize key for filesystem
        let sanitized = key
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: ":", with: "_")
        return cacheDirectory.appendingPathComponent(sanitized)
    }
}

// MARK: - Cache Metadata

private struct CacheMeta: Codable {
    let key: String
    let expiresAt: Date?
}
