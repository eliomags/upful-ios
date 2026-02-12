//
//  JTextField.swift
//  Jyanik
//
//  Styled text field with label, placeholder, validation, and secure mode
//

import SwiftUI

struct JTextField: View {
    let label: String
    @Binding var text: String
    var placeholder: String
    var isSecure: Bool
    var errorMessage: String?
    var keyboardType: UIKeyboardType
    var textContentType: UITextContentType?
    var autocapitalization: TextInputAutocapitalization

    @FocusState private var isFocused: Bool
    @State private var isSecureVisible: Bool = false

    init(
        _ label: String,
        text: Binding<String>,
        placeholder: String = "",
        isSecure: Bool = false,
        errorMessage: String? = nil,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        autocapitalization: TextInputAutocapitalization = .sentences
    ) {
        self.label = label
        self._text = text
        self.placeholder = placeholder
        self.isSecure = isSecure
        self.errorMessage = errorMessage
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.autocapitalization = autocapitalization
    }

    var body: some View {
        VStack(alignment: .leading, spacing: JSpacing.xxs) {
            // Label
            Text(label)
                .font(JFont.subheadlineMedium)
                .foregroundStyle(JColor.textSecondary)

            // Input field
            HStack(spacing: JSpacing.xs) {
                inputField
                    .font(JFont.body)
                    .foregroundStyle(JColor.textPrimary)
                    .keyboardType(keyboardType)
                    .textContentType(textContentType)
                    .textInputAutocapitalization(autocapitalization)
                    .focused($isFocused)

                if isSecure {
                    Button {
                        isSecureVisible.toggle()
                    } label: {
                        Image(systemName: isSecureVisible ? "eye.slash.fill" : "eye.fill")
                            .font(.subheadline)
                            .foregroundStyle(JColor.textTertiary)
                    }
                }
            }
            .padding(.horizontal, JSpacing.sm)
            .padding(.vertical, JSpacing.sm)
            .background(JColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: JRadius.medium))
            .overlay {
                RoundedRectangle(cornerRadius: JRadius.medium)
                    .strokeBorder(borderColor, lineWidth: isFocused ? 2 : 1)
            }

            // Error message
            if let errorMessage, !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(JFont.caption)
                    .foregroundStyle(JColor.error)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
        .animation(.easeInOut(duration: 0.2), value: errorMessage)
    }

    @ViewBuilder
    private var inputField: some View {
        if isSecure && !isSecureVisible {
            SecureField(placeholder, text: $text)
        } else {
            TextField(placeholder, text: $text)
        }
    }

    private var borderColor: Color {
        if errorMessage != nil && !(errorMessage?.isEmpty ?? true) {
            return JColor.error
        }
        return isFocused ? JColor.primary : JColor.border
    }
}

// MARK: - Preview

#Preview("Text Fields") {
    struct PreviewWrapper: View {
        @State var email = ""
        @State var password = ""
        @State var username = "jyanik_user"

        var body: some View {
            VStack(spacing: JSpacing.lg) {
                JTextField(
                    "Email",
                    text: $email,
                    placeholder: "you@example.com",
                    keyboardType: .emailAddress,
                    textContentType: .emailAddress,
                    autocapitalization: .never
                )

                JTextField(
                    "Password",
                    text: $password,
                    placeholder: "Enter password",
                    isSecure: true,
                    textContentType: .password,
                    autocapitalization: .never
                )

                JTextField(
                    "Username",
                    text: $username,
                    placeholder: "Choose a username",
                    errorMessage: "Username is already taken",
                    autocapitalization: .never
                )
            }
            .padding()
            .background(JColor.background)
        }
    }
    return PreviewWrapper()
}
