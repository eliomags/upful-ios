//
//  JLoadingView.swift
//  Jyanik
//
//  Loading states: shimmer skeleton, full-screen spinner, inline indicator
//

import SwiftUI

// MARK: - Full Screen Loading

/// Centered loading spinner with optional message.
struct JLoadingView: View {
    let message: String?

    init(_ message: String? = nil) {
        self.message = message
    }

    var body: some View {
        VStack(spacing: JSpacing.md) {
            ProgressView()
                .controlSize(.large)
                .tint(JColor.primary)

            if let message {
                Text(message)
                    .font(JFont.subheadline)
                    .foregroundStyle(JColor.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(JColor.background)
    }
}

// MARK: - Inline Loading

/// Small inline loading indicator for buttons, rows, etc.
struct JInlineLoading: View {
    let message: String?

    init(_ message: String? = nil) {
        self.message = message
    }

    var body: some View {
        HStack(spacing: JSpacing.xs) {
            ProgressView()
                .tint(JColor.textSecondary)

            if let message {
                Text(message)
                    .font(JFont.caption)
                    .foregroundStyle(JColor.textSecondary)
            }
        }
    }
}

// MARK: - Shimmer / Skeleton Loading

/// Animated placeholder that mimics content shape while loading.
struct JShimmer: View {
    let width: CGFloat?
    let height: CGFloat

    @State private var isAnimating = false

    init(width: CGFloat? = nil, height: CGFloat = 16) {
        self.width = width
        self.height = height
    }

    var body: some View {
        RoundedRectangle(cornerRadius: JRadius.small)
            .fill(JColor.shimmer)
            .frame(width: width, height: height)
            .overlay {
                GeometryReader { geometry in
                    let gradientWidth = geometry.size.width * 0.4
                    LinearGradient(
                        colors: [
                            .clear,
                            .white.opacity(0.3),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: gradientWidth)
                    .offset(x: isAnimating ? geometry.size.width + gradientWidth : -gradientWidth)
                }
                .clipShape(RoundedRectangle(cornerRadius: JRadius.small))
            }
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    isAnimating = true
                }
            }
    }
}

// MARK: - Skeleton Card

/// Pre-built skeleton for a typical card layout.
struct JSkeletonCard: View {
    var body: some View {
        JCard {
            VStack(alignment: .leading, spacing: JSpacing.sm) {
                HStack {
                    JShimmer(width: 40, height: 40)
                        .clipShape(Circle())
                    VStack(alignment: .leading, spacing: JSpacing.xxs) {
                        JShimmer(width: 120, height: 14)
                        JShimmer(width: 80, height: 12)
                    }
                    Spacer()
                }
                JShimmer(height: 14)
                JShimmer(width: 200, height: 14)
            }
        }
    }
}

// MARK: - Skeleton Stock Row

/// Pre-built skeleton for a stock list row.
struct JSkeletonStockRow: View {
    var body: some View {
        HStack(spacing: JSpacing.sm) {
            VStack(alignment: .leading, spacing: JSpacing.xxs) {
                JShimmer(width: 50, height: 16)
                JShimmer(width: 100, height: 12)
            }
            Spacer()
            JShimmer(width: 60, height: 28)
            VStack(alignment: .trailing, spacing: JSpacing.xxs) {
                JShimmer(width: 60, height: 16)
                JShimmer(width: 50, height: 12)
            }
        }
        .padding(.vertical, JSpacing.xs)
    }
}

// MARK: - Previews

#Preview("Full Screen Loading") {
    JLoadingView("Loading portfolio...")
}

#Preview("Inline Loading") {
    JInlineLoading("Refreshing...")
        .padding()
}

#Preview("Shimmer") {
    VStack(alignment: .leading, spacing: JSpacing.sm) {
        JShimmer(width: 200, height: 20)
        JShimmer(height: 14)
        JShimmer(width: 150, height: 14)
    }
    .padding()
}

#Preview("Skeleton Card") {
    VStack(spacing: JSpacing.md) {
        JSkeletonCard()
        JSkeletonCard()
    }
    .padding()
    .background(JColor.background)
}

#Preview("Skeleton Stock Rows") {
    VStack(spacing: 0) {
        ForEach(0..<5, id: \.self) { _ in
            JSkeletonStockRow()
            Divider()
        }
    }
    .padding(.horizontal)
}
