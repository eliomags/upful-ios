//
//  JButton.swift
//  Jyanik
//
//  Design system button with primary, secondary, text, and destructive styles
//

import SwiftUI

struct JButton: View {
    let title: String
    let style: Style
    let size: Size
    let isLoading: Bool
    let isDisabled: Bool
    let action: () -> Void

    enum Style {
        case primary
        case secondary
        case text
        case destructive
    }

    enum Size {
        case small
        case medium
        case large

        var verticalPadding: CGFloat {
            switch self {
            case .small: return JSpacing.xs
            case .medium: return JSpacing.sm
            case .large: return JSpacing.md
            }
        }

        var horizontalPadding: CGFloat {
            switch self {
            case .small: return JSpacing.sm
            case .medium: return JSpacing.md
            case .large: return JSpacing.lg
            }
        }

        var font: Font {
            switch self {
            case .small: return JFont.subheadlineMedium
            case .medium: return JFont.calloutMedium
            case .large: return JFont.headline
            }
        }
    }

    init(
        _ title: String,
        style: Style = .primary,
        size: Size = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            content
                .frame(maxWidth: .infinity)
                .padding(.vertical, size.verticalPadding)
                .padding(.horizontal, size.horizontalPadding)
                .font(size.font)
                .foregroundStyle(foregroundColor)
                .background(backgroundColor, in: RoundedRectangle(cornerRadius: JRadius.small))
                .overlay {
                    if style == .secondary {
                        RoundedRectangle(cornerRadius: JRadius.small)
                            .strokeBorder(borderColor, lineWidth: 1.5)
                    }
                }
        }
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.5 : 1.0)
    }

    @ViewBuilder
    private var content: some View {
        if isLoading {
            ProgressView()
                .tint(foregroundColor)
        } else {
            Text(title)
        }
    }

    // MARK: - Colors

    private var foregroundColor: Color {
        switch style {
        case .primary:
            return .white
        case .secondary:
            return JColor.primary
        case .text:
            return JColor.primary
        case .destructive:
            return .white
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .primary:
            return JColor.primary
        case .secondary:
            return .clear
        case .text:
            return .clear
        case .destructive:
            return JColor.error
        }
    }

    private var borderColor: Color {
        switch style {
        case .secondary:
            return JColor.primary
        default:
            return .clear
        }
    }
}

// MARK: - Icon Button Variant

struct JIconButton: View {
    let icon: String
    let style: JButton.Style
    let size: JButton.Size
    let action: () -> Void

    init(
        icon: String,
        style: JButton.Style = .text,
        size: JButton.Size = .medium,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.style = style
        self.size = size
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(size.font)
                .foregroundStyle(foregroundColor)
                .padding(size.verticalPadding)
                .background(backgroundColor, in: Circle())
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary: return .white
        case .secondary: return JColor.primary
        case .text: return JColor.primary
        case .destructive: return .white
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .primary: return JColor.primary
        case .secondary, .text: return .clear
        case .destructive: return JColor.error
        }
    }
}

// MARK: - Previews

#Preview("Primary Buttons") {
    VStack(spacing: JSpacing.md) {
        JButton("Get Started", style: .primary, size: .large) {}
        JButton("Continue", style: .primary, size: .medium) {}
        JButton("Next", style: .primary, size: .small) {}
    }
    .padding()
}

#Preview("Secondary Buttons") {
    VStack(spacing: JSpacing.md) {
        JButton("Sign In", style: .secondary, size: .large) {}
        JButton("Learn More", style: .secondary, size: .medium) {}
    }
    .padding()
}

#Preview("Other Styles") {
    VStack(spacing: JSpacing.md) {
        JButton("Skip", style: .text) {}
        JButton("Delete Account", style: .destructive) {}
        JButton("Loading...", style: .primary, isLoading: true) {}
        JButton("Disabled", style: .primary, isDisabled: true) {}
    }
    .padding()
}
