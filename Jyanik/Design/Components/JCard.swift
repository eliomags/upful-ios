//
//  JCard.swift
//  Jyanik
//
//  Rounded card container with shadow and surface background
//

import SwiftUI

struct JCard<Content: View>: View {
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
        content
            .padding(padding)
            .background(JColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Bordered Variant

struct JCardBordered<Content: View>: View {
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
        content
            .padding(padding)
            .background(JColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(JColor.border, lineWidth: 1)
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

        JCardBordered {
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
