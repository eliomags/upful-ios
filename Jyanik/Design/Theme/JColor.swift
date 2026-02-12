//
//  JColor.swift
//  Jyanik
//
//  Design system color tokens with light/dark mode support
//

import SwiftUI

enum JColor {

    // MARK: - Brand

    /// Primary teal (#00B4D8 light, #0096B7 dark)
    static let primary = Color(light: .init(hex: 0x00B4D8), dark: .init(hex: 0x38CCE8))

    /// Darker teal for pressed/active states
    static let primaryDark = Color(light: .init(hex: 0x0096B7), dark: .init(hex: 0x00B4D8))

    /// Secondary accent - indigo
    static let secondary = Color(light: .init(hex: 0x6366F1), dark: .init(hex: 0x818CF8))

    /// Accent - warm amber for highlights
    static let accent = Color(light: .init(hex: 0xF59E0B), dark: .init(hex: 0xFBBF24))

    // MARK: - Surfaces

    /// Main background
    static let background = Color(light: .init(hex: 0xF8FAFC), dark: .init(hex: 0x0F172A))

    /// Card / elevated surface
    static let surface = Color(light: .white, dark: .init(hex: 0x1E293B))

    /// Secondary surface for grouped sections
    static let surfaceSecondary = Color(light: .init(hex: 0xF1F5F9), dark: .init(hex: 0x334155))

    // MARK: - Text

    /// Primary text
    static let textPrimary = Color(light: .init(hex: 0x0F172A), dark: .init(hex: 0xF1F5F9))

    /// Secondary text
    static let textSecondary = Color(light: .init(hex: 0x64748B), dark: .init(hex: 0x94A3B8))

    /// Tertiary / muted text
    static let textTertiary = Color(light: .init(hex: 0x94A3B8), dark: .init(hex: 0x64748B))

    // MARK: - Status

    /// Success / positive
    static let success = Color(light: .init(hex: 0x10B981), dark: .init(hex: 0x34D399))

    /// Warning
    static let warning = Color(light: .init(hex: 0xF59E0B), dark: .init(hex: 0xFBBF24))

    /// Error / destructive
    static let error = Color(light: .init(hex: 0xEF4444), dark: .init(hex: 0xF87171))

    /// Informational
    static let info = Color(light: .init(hex: 0x3B82F6), dark: .init(hex: 0x60A5FA))

    // MARK: - Financial

    /// Positive price movement / gain
    static let gainPositive = Color(light: .init(hex: 0x10B981), dark: .init(hex: 0x34D399))

    /// Negative price movement / loss
    static let gainNegative = Color(light: .init(hex: 0xEF4444), dark: .init(hex: 0xF87171))

    /// Neutral / no change
    static let gainNeutral = Color(light: .init(hex: 0x94A3B8), dark: .init(hex: 0x64748B))

    // MARK: - Borders & Dividers

    static let border = Color(light: .init(hex: 0xE2E8F0), dark: .init(hex: 0x334155))

    static let divider = Color(light: .init(hex: 0xE2E8F0), dark: .init(hex: 0x1E293B))

    // MARK: - Overlays

    static let overlay = Color.black.opacity(0.4)
    static let shimmer = Color(light: .init(hex: 0xE2E8F0), dark: .init(hex: 0x334155))
}

// MARK: - Adaptive Color Initializer

private extension Color {
    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
    }
}

// MARK: - Hex Color Initializer

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}
