//
//  ForgotPasswordView.swift
//  Jyanik
//
//  Forgot password screen: enter email to receive a reset link
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: AuthViewModel?

    var body: some View {
        ZStack {
            JColor.background
                .ignoresSafeArea()

            if let vm = viewModel {
                VStack(spacing: 0) {
                    if vm.isPasswordResetSent {
                        successContent(vm: vm)
                    } else {
                        formContent(vm: vm)
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: vm.isPasswordResetSent)
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

    // MARK: - Form State

    @MainActor
    private func formContent(vm: AuthViewModel) -> some View {
        VStack(spacing: JSpacing.lg) {
            Spacer()

            // Icon
            ZStack {
                Circle()
                    .fill(JColor.primary.opacity(0.15))
                    .frame(width: 88, height: 88)

                Image(systemName: "lock.rotation")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundStyle(JColor.primary)
            }

            // Header
            VStack(spacing: JSpacing.xs) {
                Text("Reset Password")
                    .font(JFont.title)
                    .foregroundStyle(JColor.textPrimary)

                Text("Enter the email address associated with your account and we'll send you a link to reset your password.")
                    .font(JFont.body)
                    .foregroundStyle(JColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }

            // Email Field
            JTextField(
                "Email",
                text: Bindable(vm).email,
                placeholder: "you@example.com",
                keyboardType: .emailAddress,
                textContentType: .emailAddress,
                autocapitalization: .never
            )
            .padding(.top, JSpacing.xs)

            // Send Button
            JButton("Send Reset Link", style: .primary, size: .large, isLoading: vm.isLoading) {
                Task {
                    await vm.forgotPassword()
                }
            }

            Spacer()

            // Back to Sign In
            Button {
                dismiss()
            } label: {
                HStack(spacing: JSpacing.xxs) {
                    Image(systemName: "arrow.left")
                        .font(JFont.subheadline)

                    Text("Back to Sign In")
                        .font(JFont.calloutMedium)
                }
                .foregroundStyle(JColor.primary)
            }
            .padding(.bottom, JSpacing.xxl)
        }
        .padding(.horizontal, JSpacing.lg)
    }

    // MARK: - Success State

    @MainActor
    private func successContent(vm: AuthViewModel) -> some View {
        VStack(spacing: JSpacing.lg) {
            Spacer()

            // Success Icon
            ZStack {
                Circle()
                    .fill(JColor.success.opacity(0.15))
                    .frame(width: 88, height: 88)

                Image(systemName: "envelope.badge.fill")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundStyle(JColor.success)
            }

            // Success Message
            VStack(spacing: JSpacing.xs) {
                Text("Check Your Email")
                    .font(JFont.title)
                    .foregroundStyle(JColor.textPrimary)

                Text("We've sent password reset instructions to your email address. Please check your inbox and follow the link to reset your password.")
                    .font(JFont.body)
                    .foregroundStyle(JColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }

            // Resend
            VStack(spacing: JSpacing.sm) {
                Text("Didn't receive the email?")
                    .font(JFont.subheadline)
                    .foregroundStyle(JColor.textTertiary)

                Button {
                    vm.isPasswordResetSent = false
                } label: {
                    Text("Try Again")
                        .font(JFont.calloutMedium)
                        .foregroundStyle(JColor.primary)
                }
            }
            .padding(.top, JSpacing.xs)

            Spacer()

            // Back to Sign In
            JButton("Back to Sign In", style: .secondary, size: .large) {
                dismiss()
            }
            .padding(.bottom, JSpacing.xxl)
        }
        .padding(.horizontal, JSpacing.lg)
    }
}

// MARK: - Previews

#Preview("Form") {
    let appState = AppState(keychainService: KeychainService(serviceName: "preview"))
    return NavigationStack {
        ForgotPasswordView()
    }
    .environment(appState)
}
