//
//  JErrorView.swift
//  Jyanik
//
//  Error display views in compact and full-screen variants
//

import SwiftUI

// MARK: - Full Screen Error

struct JErrorView: View {
    let message: String
    let retryAction: (() -> Void)?

    init(_ message: String = "Something went wrong. Please try again.", retryAction: (() -> Void)? = nil) {
        self.message = message
        self.retryAction = retryAction
    }

    var body: some View {
        VStack(spacing: JSpacing.md) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(JColor.error)

            VStack(spacing: JSpacing.xs) {
                Text("Oops!")
                    .font(JFont.title3)
                    .foregroundStyle(JColor.textPrimary)

                Text(message)
                    .font(JFont.subheadline)
                    .foregroundStyle(JColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
            }

            if let retryAction {
                JButton("Try Again", style: .primary, size: .medium, action: retryAction)
                    .fixedSize(horizontal: true, vertical: false)
                    .padding(.top, JSpacing.xs)
            }
        }
        .padding(JSpacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Compact Error Banner

struct JErrorBanner: View {
    let message: String
    let retryAction: (() -> Void)?

    init(_ message: String, retryAction: (() -> Void)? = nil) {
        self.message = message
        self.retryAction = retryAction
    }

    var body: some View {
        HStack(spacing: JSpacing.sm) {
            Image(systemName: "exclamationmark.circle.fill")
                .font(.body)
                .foregroundStyle(JColor.error)

            Text(message)
                .font(JFont.subheadline)
                .foregroundStyle(JColor.textPrimary)
                .lineLimit(2)

            Spacer()

            if let retryAction {
                Button("Retry", action: retryAction)
                    .font(JFont.subheadlineMedium)
                    .foregroundStyle(JColor.primary)
            }
        }
        .padding(JSpacing.sm)
        .background(JColor.error.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: JRadius.small))
        .overlay {
            RoundedRectangle(cornerRadius: JRadius.small)
                .strokeBorder(JColor.error.opacity(0.3), lineWidth: 1)
        }
    }
}

// MARK: - Previews

#Preview("Full Screen Error") {
    JErrorView("We couldn't load your portfolio. Check your connection and try again.") {
        // retry
    }
}

#Preview("Full Screen Error - No Retry") {
    JErrorView("This competition has ended.")
}

#Preview("Error Banner") {
    VStack(spacing: JSpacing.md) {
        JErrorBanner("Failed to refresh prices.") {
            // retry
        }

        JErrorBanner("Network connection lost.")
    }
    .padding()
}
