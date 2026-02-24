//
//  LoginView.swift
//  Jyanik
//
//  Sign in screen with email/password, Apple Sign In, and forgot password
//

import AuthenticationServices
import SwiftUI

struct LoginView: View {
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
                            Text("Welcome Back")
                                .font(JFont.largeTitle)
                                .foregroundStyle(JColor.textPrimary)

                            Text("Sign in to continue trading")
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
                                "Password",
                                text: Bindable(vm).password,
                                placeholder: "Enter your password",
                                isSecure: true,
                                textContentType: .password,
                                autocapitalization: .never
                            )
                        }

                        // Forgot Password
                        HStack {
                            Spacer()
                            NavigationLink {
                                ForgotPasswordView()
                            } label: {
                                Text("Forgot Password?")
                                    .font(JFont.subheadlineMedium)
                                    .foregroundStyle(JColor.primary)
                            }
                        }

                        // Sign In Button
                        JButton("Sign In", style: .primary, size: .large, isLoading: vm.isLoading) {
                            Task {
                                await vm.login()
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
                        SignInWithAppleButton(.signIn) { request in
                            request.requestedScopes = [.fullName, .email]
                        } onCompletion: { _ in
                            Task {
                                await vm.signInWithApple()
                            }
                        }
                        .signInWithAppleButtonStyle(.white)
                        .frame(height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: JRadius.small))

                        // Register Link
                        NavigationLink {
                            RegisterView()
                        } label: {
                            HStack(spacing: JSpacing.xxs) {
                                Text("Don't have an account?")
                                    .font(JFont.callout)
                                    .foregroundStyle(JColor.textSecondary)

                                Text("Sign Up")
                                    .font(JFont.calloutMedium)
                                    .foregroundStyle(JColor.primary)
                            }
                        }
                        .padding(.top, JSpacing.xs)

                        // Dev Login (Debug builds only)
                        #if DEBUG
                        devLoginSection(vm)
                        #endif
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

// MARK: - Dev Login (Debug Only)

#if DEBUG
private extension LoginView {

    struct TestAccount {
        let label: String
        let email: String
        let tier: String
    }

    static var testAccounts: [TestAccount] {
        [
            TestAccount(label: "Alex Morgan (Premium)", email: "alex@traderpro.com", tier: "premium"),
            TestAccount(label: "Jamie Chen (Pro)", email: "jamie.chen@gmail.com", tier: "pro"),
            TestAccount(label: "David Okafor (Free)", email: "david.o@gmail.com", tier: "free"),
        ]
    }

    func devLoginSection(_ vm: AuthViewModel) -> some View {
        VStack(spacing: JSpacing.sm) {
            HStack(spacing: JSpacing.sm) {
                Rectangle()
                    .fill(JColor.border)
                    .frame(height: 1)

                Text("DEV LOGIN")
                    .font(JFont.caption)
                    .foregroundStyle(JColor.warning)

                Rectangle()
                    .fill(JColor.border)
                    .frame(height: 1)
            }

            Text("Password: TestUser123!")
                .font(JFont.caption)
                .foregroundStyle(JColor.textTertiary)
                .monospaced()

            ForEach(Self.testAccounts, id: \.email) { account in
                Button {
                    Task { @MainActor in
                        vm.email = account.email
                        vm.password = "TestUser123!"
                        await vm.login()
                    }
                } label: {
                    HStack {
                        Text(account.label)
                            .font(JFont.callout)
                        Spacer()
                        Text(account.tier)
                            .font(JFont.caption)
                            .foregroundStyle(JColor.textTertiary)
                    }
                    .padding(.horizontal, JSpacing.md)
                    .padding(.vertical, JSpacing.sm)
                    .background(JColor.surface)
                    .clipShape(RoundedRectangle(cornerRadius: JRadius.small))
                    .overlay(
                        RoundedRectangle(cornerRadius: JRadius.small)
                            .stroke(JColor.border, lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, JSpacing.sm)
    }
}
#endif

// MARK: - Previews

#Preview {
    let appState = AppState(keychainService: KeychainService(serviceName: "preview"))
    return NavigationStack {
        LoginView()
    }
    .environment(appState)
}
