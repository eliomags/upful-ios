//
//  KeychainService.swift
//  Jyanik
//
//  Secure token storage using iOS Keychain
//

import Foundation
import Security

// MARK: - Keychain Service Protocol

protocol KeychainServiceProtocol {
    func save(_ data: Data, for key: String) throws
    func load(for key: String) throws -> Data?
    func delete(for key: String) throws
    func saveString(_ value: String, for key: String) throws
    func loadString(for key: String) throws -> String?
}

// MARK: - Keychain Errors

enum KeychainError: LocalizedError {
    case saveFailed(OSStatus)
    case loadFailed(OSStatus)
    case deleteFailed(OSStatus)
    case dataConversionFailed
    case unexpectedItemData

    var errorDescription: String? {
        switch self {
        case .saveFailed(let status):
            return "Keychain save failed with status: \(status)"
        case .loadFailed(let status):
            return "Keychain load failed with status: \(status)"
        case .deleteFailed(let status):
            return "Keychain delete failed with status: \(status)"
        case .dataConversionFailed:
            return "Failed to convert data for keychain storage"
        case .unexpectedItemData:
            return "Unexpected data format in keychain"
        }
    }
}

// MARK: - Keychain Keys

enum KeychainKey: String {
    case accessToken = "com.jyanik.accessToken"
    case refreshToken = "com.jyanik.refreshToken"
    case userID = "com.jyanik.userID"
    case appleUserID = "com.jyanik.appleUserID"
    case deviceID = "com.jyanik.deviceID"
}

// MARK: - Keychain Service Implementation

final class KeychainService: KeychainServiceProtocol {

    static let shared = KeychainService()

    private let serviceName: String

    init(serviceName: String = "com.jyanik.keychain") {
        self.serviceName = serviceName
    }

    // MARK: - Data Operations

    func save(_ data: Data, for key: String) throws {
        // First try to delete any existing item
        try? delete(for: key)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            throw KeychainError.saveFailed(status)
        }
    }

    func load(for key: String) throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        switch status {
        case errSecSuccess:
            return result as? Data
        case errSecItemNotFound:
            return nil
        default:
            throw KeychainError.loadFailed(status)
        }
    }

    func delete(for key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteFailed(status)
        }
    }

    // MARK: - String Convenience

    func saveString(_ value: String, for key: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.dataConversionFailed
        }
        try save(data, for: key)
    }

    func loadString(for key: String) throws -> String? {
        guard let data = try load(for: key) else { return nil }
        guard let string = String(data: data, encoding: .utf8) else {
            throw KeychainError.unexpectedItemData
        }
        return string
    }

    // MARK: - Typed Convenience

    func saveToken(_ token: String, for key: KeychainKey) throws {
        try saveString(token, for: key.rawValue)
    }

    func loadToken(for key: KeychainKey) throws -> String? {
        try loadString(for: key.rawValue)
    }

    func deleteToken(for key: KeychainKey) throws {
        try delete(for: key.rawValue)
    }

    // MARK: - Clear All

    func clearAll() throws {
        for key in [KeychainKey.accessToken, .refreshToken, .userID, .appleUserID] {
            try deleteToken(for: key)
        }
    }
}
