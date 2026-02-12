//
//  JPriceChangeView.swift
//  Jyanik
//
//  Displays a price change value with color-coded direction indicator
//

import SwiftUI

struct JPriceChangeView: View {
    let value: Double
    let style: Style

    enum Style {
        case dollar
        case percent
        case both
    }

    init(_ value: Double, style: Style = .percent) {
        self.value = value
        self.style = style
    }

    var body: some View {
        HStack(spacing: JSpacing.xxxs) {
            Image(systemName: iconName)
                .font(.caption2)

            Text(formattedText)
                .font(JFont.priceSmall)
        }
        .foregroundStyle(color)
    }

    // MARK: - Computed

    private var isPositive: Bool { value > 0 }
    private var isNeutral: Bool { value == 0 }

    private var color: Color {
        if isNeutral { return JColor.gainNeutral }
        return isPositive ? JColor.gainPositive : JColor.gainNegative
    }

    private var iconName: String {
        if isNeutral { return "minus" }
        return isPositive ? "arrow.up.right" : "arrow.down.right"
    }

    private var formattedText: String {
        let absValue = abs(value)
        let sign = isPositive ? "+" : (isNeutral ? "" : "-")

        switch style {
        case .dollar:
            return "\(sign)$\(absValue.formatted(.number.precision(.fractionLength(2))))"
        case .percent:
            return "\(sign)\(absValue.formatted(.number.precision(.fractionLength(2))))%"
        case .both:
            return "\(sign)$\(absValue.formatted(.number.precision(.fractionLength(2)))) (\(abs(value).formatted(.number.precision(.fractionLength(2))))%)"
        }
    }
}

// MARK: - Larger Variant

struct JPriceChangeBadge: View {
    let value: Double
    let style: JPriceChangeView.Style

    init(_ value: Double, style: JPriceChangeView.Style = .percent) {
        self.value = value
        self.style = style
    }

    var body: some View {
        let isPositive = value > 0
        let isNeutral = value == 0

        HStack(spacing: JSpacing.xxs) {
            Image(systemName: isNeutral ? "minus" : (isPositive ? "arrow.up.right" : "arrow.down.right"))
                .font(.caption)

            Text(formattedText)
                .font(JFont.footnoteSemibold)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, JSpacing.xs)
        .padding(.vertical, JSpacing.xxs)
        .background(badgeColor, in: Capsule())
    }

    private var badgeColor: Color {
        if value == 0 { return JColor.gainNeutral }
        return value > 0 ? JColor.gainPositive : JColor.gainNegative
    }

    private var formattedText: String {
        let absValue = abs(value)
        let sign = value > 0 ? "+" : (value == 0 ? "" : "-")

        switch style {
        case .dollar:
            return "\(sign)$\(absValue.formatted(.number.precision(.fractionLength(2))))"
        case .percent:
            return "\(sign)\(absValue.formatted(.number.precision(.fractionLength(2))))%"
        case .both:
            return "\(sign)$\(absValue.formatted(.number.precision(.fractionLength(2)))) (\(abs(value).formatted(.number.precision(.fractionLength(2))))%)"
        }
    }
}

// MARK: - Previews

#Preview("Price Change - Positive") {
    VStack(spacing: JSpacing.md) {
        JPriceChangeView(2.45, style: .percent)
        JPriceChangeView(12.50, style: .dollar)
        JPriceChangeView(3.21, style: .both)
    }
    .padding()
}

#Preview("Price Change - Negative") {
    VStack(spacing: JSpacing.md) {
        JPriceChangeView(-1.32, style: .percent)
        JPriceChangeView(-5.00, style: .dollar)
        JPriceChangeView(-0.87, style: .both)
    }
    .padding()
}

#Preview("Price Change - Neutral") {
    JPriceChangeView(0.0, style: .percent)
        .padding()
}

#Preview("Price Change Badge") {
    VStack(spacing: JSpacing.md) {
        JPriceChangeBadge(4.56, style: .percent)
        JPriceChangeBadge(-2.13, style: .percent)
        JPriceChangeBadge(0.0, style: .percent)
    }
    .padding()
}
