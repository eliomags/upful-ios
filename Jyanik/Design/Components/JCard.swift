//
//  JCard.swift
//  Jyanik
//
//  Configurable card container with shadow or border style
//

import SwiftUI

// MARK: - Card Style

enum JCardStyle {
    case shadow
    case bordered
}

// MARK: - JCard

struct JCard<Content: View>: View {
    let style: JCardStyle
    let padding: CGFloat
    let cornerRadius: CGFloat
    let content: Content

    init(
        style: JCardStyle = .shadow,
        padding: CGFloat = JSpacing.md,
        cornerRadius: CGFloat = JRadius.medium,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background(JColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .modifier(CardDecorationModifier(style: style, cornerRadius: cornerRadius))
    }
}

// MARK: - Decoration Modifier

private struct CardDecorationModifier: ViewModifier {
    let style: JCardStyle
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        switch style {
        case .shadow:
            content
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        case .bordered:
            content
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(JColor.border, lineWidth: 1)
                }
        }
    }
}

// MARK: - Backward-Compatible Alias

/// Backward-compatible alias — use `JCard(style: .bordered)` instead.
typealias JCardBordered = _JCardBorderedCompat

struct _JCardBorderedCompat<Content: View>: View {
    let padding: CGFloat
    let cornerRadius: CGFloat
    let content: Content

    init(
        padding: CGFloat = JSpacing.md,
        cornerRadius: CGFloat = JRadius.medium,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    var body: some View {
        JCard(style: .bordered, padding: padding, cornerRadius: cornerRadius) {
            content
        }
    }
}

// MARK: - Previews

#Preview("Cards") {
    VStack(spacing: JSpacing.md) {
        JCard {
            VStack(alignment: .leading, spacing: JSpacing.xs) {
                Text("Portfolio Value")
                    .font(JFont.subheadline)
                    .foregroundStyle(JColor.textSecondary)
                Text("$102,450.00")
                    .font(JFont.priceLarge)
                    .foregroundStyle(JColor.textPrimary)
                JPriceChangeView(2.45, style: .percent)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }

        JCard(style: .bordered) {
            HStack {
                Text("AAPL")
                    .font(JFont.headline)
                Spacer()
                Text("$178.50")
                    .font(JFont.price)
            }
        }
    }
    .padding()
    .background(JColor.background)
}
