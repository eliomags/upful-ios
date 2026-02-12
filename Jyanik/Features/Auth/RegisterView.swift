//
//  RegisterView.swift
//  Jyanik
//
//  Account registration screen with email, username, password, strength indicator, and terms
//

import AuthenticationServices
import SwiftUI

struct RegisterView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: AuthViewModel?

    var body: some View {
        ZStack {
            JColor.background
                .ignoresSafeArea()

            if let vm = viewModel {
                ScrollView {
                    VStack(spacing: JSpacing.lg) {
                        // Header
                        VStack(spacing: JSpacing.xs) {
                            Text("Create Account")
                                .font(JFont.largeTitle)
                                .foregroundStyle(JColor.textPrimary)

                            Text("Start trading with $25K virtual cash")
                                .font(JFont.body)
                                .foregroundStyle(JColor.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, JSpacing.xl)

                        // Form Fields
                        VStack(spacing: JSpacing.md) {
                            JTextField(
                                "Email",
                                text: Bindable(vm).email,
                                placeholder: "you@example.com",
                                keyboardType: .emailAddress,
                                textContentType: .emailAddress,
                                autocapitalization: .never
                            )

                            JTextField(
                                "Username",
                                text: Bindable(vm).username,
                                placeholder: "Choose a username",
                                textContentType: .username,
                                autocapitalization: .never
                            )

                            VStack(spacing: JSpacing.xs) {
                                JTextField(
                                    "Password",
                                    text: Bindable(vm).password,
                                    placeholder: "Min. 8 characters",
                                    isSecure: true,
                                    textContentType: .newPassword,
                                    autocapitalization: .never
                                )

                                // Password Strength Indicator
                                if !vm.password.isEmpty {
                                    PasswordStrengthBar(strength: vm.passwordStrength)
                                }
                            }

                            JTextField(
                                "Confirm Password",
                                text: Bindable(vm).confirmPassword,
                                placeholder: "Re-enter your password",
                                isSecure: true,
                                textContentType: .newPassword,
                                autocapitalization: .never
                            )
                        }

                        // Terms Acceptance
                        Button {
                            vm.acceptedTerms.toggle()
                        } label: {
                            HStack(alignment: .top, spacing: JSpacing.sm) {
                                Image(systemName: vm.acceptedTerms ? "checkmark.square.fill" : "square")
                                    .font(.system(size: 22))
                                    .foregroundStyle(vm.acceptedTerms ? JColor.primary : JColor.textTertiary)

                                Text("I agree to the Terms of Service and Privacy Policy")
                                    .font(JFont.subheadline)
                                    .foregroundStyle(JColor.textSecondary)
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(.plain)

                        // Create Account Button
                        JButton(
                            "Create Account",
                            style: .primary,
                            size: .large,
                            isLoading: vm.isLoading,
                            isDisabled: !vm.acceptedTerms
                        ) {
                            Task {
                                await vm.register()
                            }
                        }

                        // Divider
                        HStack(spacing: JSpacing.sm) {
                            Rectangle()
                                .fill(JColor.border)
                                .frame(height: 1)

                            Text("or")
                                .font(JFont.subheadline)
                                .foregroundStyle(JColor.textTertiary)

                            Rectangle()
                                .fill(JColor.border)
                                .frame(height: 1)
                        }

                        // Apple Sign In
                        SignInWithAppleButton(.signUp) { request in
                            request.requestedScopes = [.fullName, .email]
                        } onCompletion: { _ in
                            Task {
                                await vm.signInWithApple()
                            }
                        }
                        .signInWithAppleButtonStyle(.white)
                        .frame(height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: JRadius.small))

                        // Login Link
                        NavigationLink {
                            LoginView()
                        } label: {
                            HStack(spacing: JSpacing.xxs) {
                                Text("Already have an account?")
                                    .font(JFont.callout)
                                    .foregroundStyle(JColor.textSecondary)

                                Text("Sign In")
                                    .font(JFont.calloutMedium)
                                    .foregroundStyle(JColor.primary)
                            }
                        }
                        .padding(.top, JSpacing.xs)
                        .padding(.bottom, JSpacing.xl)
                    }
                    .padding(.horizontal, JSpacing.lg)
                }
                .scrollDismissesKeyboard(.interactively)
                .alert("Error", isPresented: Bindable(vm).showError) {
                    Button("OK") {
                        vm.clearError()
                    }
                } message: {
                    Text(vm.errorMessage ?? "An unexpected error occurred.")
                }
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = AuthViewModel(appState: appState)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(JFont.headline)
                        .foregroundStyle(JColor.textPrimary)
                }
            }
        }
    }
}

// MARK: - Password Strength Bar

private struct PasswordStrengthBar: View {
    let strength: AuthViewModel.PasswordStrength

    var body: some View {
        HStack(spacing: JSpacing.xs) {
            HStack(spacing: JSpacing.xxs) {
                ForEach(0..<3, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(barColor(for: index))
                        .frame(height: 4)
                }
            }

            Text(strength.rawValue)
                .font(JFont.caption)
                .foregroundStyle(textColor)
        }
        .animation(.easeInOut(duration: 0.2), value: strength)
    }

    private func barColor(for index: Int) -> Color {
        let filledCount: Int
        let color: Color

        switch strength {
        case .weak:
            filledCount = 1
            color = JColor.error
        case .medium:
            filledCount = 2
            color = JColor.warning
        case .strong:
            filledCount = 3
            color = JColor.success
        }

        return index < filledCount ? color : JColor.border
    }

    private var textColor: Color {
        switch strength {
        case .weak: return JColor.error
        case .medium: return JColor.warning
        case .strong: return JColor.success
        }
    }
}

// MARK: - Previews

#Preview {
    let appState = AppState(keychainService: KeychainService(serviceName: "preview"))
    return NavigationStack {
        RegisterView()
    }
    .environment(appState)
}
