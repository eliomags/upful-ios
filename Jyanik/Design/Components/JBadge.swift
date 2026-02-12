//
//  JBadge.swift
//  Jyanik
//
//  Badge components for notification counts, status dots, and labels
//

import SwiftUI

// MARK: - Count Badge

/// Numeric badge for notification counts, typically overlaid on icons.
struct JBadge: View {
    let count: Int
    let maxDisplay: Int

    init(_ count: Int, maxDisplay: Int = 99) {
        self.count = count
        self.maxDisplay = maxDisplay
    }

    var body: some View {
        if count > 0 {
            Text(count > maxDisplay ? "\(maxDisplay)+" : "\(count)")
                .font(JFont.caption2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(.horizontal, JSpacing.xxs + 2)
                .padding(.vertical, JSpacing.xxxs)
                .background(JColor.error, in: Capsule())
                .fixedSize()
        }
    }
}

// MARK: - Dot Badge

/// Small colored dot for status indicators.
struct JDotBadge: View {
    let color: Color
    let size: CGFloat

    init(color: Color = JColor.error, size: CGFloat = 8) {
        self.color = color
        self.size = size
    }

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
    }
}

// MARK: - Text Badge / Tag

/// Labeled badge with colored background, used for tags and status labels.
struct JTextBadge: View {
    let text: String
    let color: Color
    let style: Style

    enum Style {
        case filled
        case tinted
    }

    init(_ text: String, color: Color = JColor.primary, style: Style = .tinted) {
        self.text = text
        self.color = color
        self.style = style
    }

    var body: some View {
        Text(text)
            .font(JFont.captionMedium)
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, JSpacing.xs)
            .padding(.vertical, JSpacing.xxxs + 1)
            .background(backgroundColor, in: Capsule())
    }

    private var foregroundColor: Color {
        switch style {
        case .filled: return .white
        case .tinted: return color
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .filled: return color
        case .tinted: return color.opacity(0.15)
        }
    }
}

// MARK: - Previews

#Preview("Count Badge") {
    HStack(spacing: JSpacing.xl) {
        ZStack(alignment: .topTrailing) {
            Image(systemName: "bell")
                .font(.title2)
            JBadge(3)
                .offset(x: 8, y: -8)
        }

        ZStack(alignment: .topTrailing) {
            Image(systemName: "envelope")
                .font(.title2)
            JBadge(150)
                .offset(x: 10, y: -8)
        }
    }
    .padding()
}

#Preview("Dot Badge") {
    HStack(spacing: JSpacing.lg) {
        HStack(spacing: JSpacing.xxs) {
            JDotBadge(color: JColor.success)
            Text("Online")
                .font(JFont.caption)
        }

        HStack(spacing: JSpacing.xxs) {
            JDotBadge(color: JColor.warning)
            Text("Away")
                .font(JFont.caption)
        }

        HStack(spacing: JSpacing.xxs) {
            JDotBadge(color: JColor.error)
            Text("Offline")
                .font(JFont.caption)
        }
    }
    .padding()
}

#Preview("Text Badges") {
    HStack(spacing: JSpacing.xs) {
        JTextBadge("Pro", color: JColor.accent, style: .filled)
        JTextBadge("Active", color: JColor.success)
        JTextBadge("Pending", color: JColor.warning)
        JTextBadge("Closed", color: JColor.error)
    }
    .padding()
}
