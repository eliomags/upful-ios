//
//  AppConfig.swift
//  Jyanik
//
//  Configuration management for different environments
//

import Foundation

// MARK: - Environment

enum AppEnvironment: String {
    case development = "dev"
    case staging = "staging"
    case production = "prod"

    var displayName: String {
        switch self {
        case .development: return "Development"
        case .staging: return "Staging"
        case .production: return "Production"
        }
    }
}

// MARK: - App Configuration

struct AppConfig {

    // MARK: - Current Environment

    static var current: AppEnvironment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }

    // MARK: - API Configuration

    struct API {
        static var baseURL: String {
            switch AppConfig.current {
            case .development:
                return "http://localhost:8787"
            case .staging:
                return "https://api-staging.jyanik.com"
            case .production:
                return "https://api.jyanik.com"
            }
        }

        static var websocketURL: String {
            switch AppConfig.current {
            case .development:
                return "ws://localhost:8787/ws"
            case .staging:
                return "wss://api-staging.jyanik.com/ws"
            case .production:
                return "wss://api.jyanik.com/ws"
            }
        }

        static let timeout: TimeInterval = 30
        static let maxRetries: Int = 3
    }

    // MARK: - Feature Flags

    struct Features {
        static var isCompetitionsEnabled: Bool {
            AppConfig.current != .development
        }

        static var isAnalyticsEnabled: Bool {
            AppConfig.current == .production
        }

        static var isCrashReportingEnabled: Bool {
            AppConfig.current != .development
        }

        static var isDebugMenuEnabled: Bool {
            AppConfig.current == .development
        }
    }

    // MARK: - App Info

    struct App {
        static let name = "Jyanik"
        static let bundleID = Bundle.main.bundleIdentifier ?? "com.jyanik.app"
        static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        static let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        static let minimumIOSVersion = "17.0"
    }

    // MARK: - Third Party Keys

    struct Keys {
        static let mixpanelToken = Secrets.mixpanelToken
        // Future: Add keys here as services are integrated
    }
}
