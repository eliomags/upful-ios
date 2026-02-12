//
//  AccessibilityModifiers.swift
//  Jyanik
//
//  Reusable SwiftUI view modifiers and extensions for accessibility
//

import SwiftUI

// MARK: - Accessibility Label Helpers

extension View {
    /// Add stock price accessibility label (e.g., "Apple stock, $150.25, up 2.3%")
    func stockAccessibilityLabel(ticker: String, name: String, price: String, change: String, isPositive: Bool) -> some View {
        self.accessibilityLabel("\(name) stock, \(price), \(isPositive ? "up" : "down") \(change)")
    }

    /// Add portfolio value accessibility
    func portfolioAccessibilityLabel(value: String, change: String, isPositive: Bool) -> some View {
        self.accessibilityLabel("Portfolio value \(value), \(isPositive ? "gain" : "loss") of \(change)")
    }

    /// Add competition rank accessibility
    func rankAccessibilityLabel(rank: Int, total: Int, name: String) -> some View {
        self.accessibilityLabel("Rank \(rank) of \(total), \(name)")
    }

    /// Add trade action accessibility
    func tradeAccessibilityLabel(action: String, ticker: String, quantity: String, price: String) -> some View {
        self.accessibilityLabel("\(action) \(quantity) shares of \(ticker) at \(price)")
    }

    /// Add payout status accessibility
    func payoutAccessibilityLabel(amount: String, method: String, status: String) -> some View {
        self.accessibilityLabel("Payout of \(amount) via \(method), status: \(status)")
    }
}

// MARK: - Accessibility Traits

extension View {
    /// Mark as a price cell with updates trait
    func priceAccessibilityTraits() -> some View {
        self.accessibilityAddTraits(.updatesFrequently)
    }

    /// Mark as a header
    func headerAccessibility(_ text: String) -> some View {
        self.accessibilityAddTraits(.isHeader)
            .accessibilityLabel(text)
    }
}

// MARK: - Dynamic Type Support

extension View {
    /// Ensure minimum touch target of 44x44 points (Apple HIG)
    func accessibleTapTarget() -> some View {
        self.frame(minWidth: 44, minHeight: 44)
    }
}
