//
//  EditProfileView.swift
//  Jyanik
//
//  Edit profile screen with avatar, name, username, email, and bio fields
//

import SwiftUI

struct EditProfileView: View {

    // MARK: - Dependencies

    @State private var viewModel = SettingsViewModel()
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var showAvatarAlert = false
    @State private var showDiscardAlert = false

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: JSpacing.lg) {
                avatarSection
                formFields
                saveButton
            }
            .padding(.horizontal, JSpacing.md)
            .padding(.vertical, JSpacing.lg)
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .background(JColor.background)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    if hasUnsavedChanges {
                        showDiscardAlert = true
                    } else {
                        dismiss()
                    }
                }
                .foregroundStyle(JColor.textSecondary)
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert("Change Profile Photo", isPresented: $showAvatarAlert) {
            Button("OK") {}
        } message: {
            Text("Photo upload is coming soon. Stay tuned!")
        }
        .alert("Discard Changes?", isPresented: $showDiscardAlert) {
            Button("Keep Editing", role: .cancel) {}
            Button("Discard", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("You have unsaved changes that will be lost.")
        }
        .onChange(of: viewModel.profileSaved) { _, saved in
            if saved {
                // Update the user object in AppState if needed
                if let user = appState.currentUser {
                    user.displayName = viewModel.displayName
                    user.bio = viewModel.bio
                }
                dismiss()
            }
        }
        .onAppear {
            viewModel.loadProfile(from: appState.currentUser)
        }
    }

    // MARK: - Unsaved Changes Detection

    private var hasUnsavedChanges: Bool {
        let user = appState.currentUser
        let originalName = user?.displayName ?? user?.username ?? ""
        let originalBio = user?.bio ?? ""
        return viewModel.displayName != originalName || viewModel.bio != originalBio
    }
}

// MARK: - Avatar Section

private extension EditProfileView {

    var avatarSection: some View {
        VStack(spacing: JSpacing.sm) {
            Button {
                showAvatarAlert = true
            } label: {
                ZStack(alignment: .bottomTrailing) {
                    JAvatar(
                        urlString: appState.currentUser?.avatarUrl,
                        initials: userInitials,
                        size: .xl
                    )

                    // Camera overlay
                    ZStack {
                        Circle()
                            .fill(JColor.primary)
                            .frame(width: 28, height: 28)

                        Image(systemName: "camera.fill")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .offset(x: 2, y: 2)
                }
            }
            .buttonStyle(.plain)

            Text("Tap to change photo")
                .font(JFont.caption)
                .foregroundStyle(JColor.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, JSpacing.xs)
    }

    var userInitials: String {
        let name = viewModel.displayName.isEmpty
            ? (appState.currentUser?.username ?? "")
            : viewModel.displayName
        let components = name.split(separator: " ")
        if components.count >= 2 {
            return String(components[0].prefix(1)) + String(components[1].prefix(1))
        }
        return String(name.prefix(2))
    }
}

// MARK: - Form Fields

private extension EditProfileView {

    var formFields: some View {
        VStack(spacing: JSpacing.md) {
            // Display Name
            JTextField(
                "Display Name",
                text: $viewModel.displayName,
                placeholder: "Enter your display name",
                errorMessage: viewModel.displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    ? "Display name is required"
                    : nil,
                autocapitalization: .words
            )

            // Username (read-only)
            VStack(alignment: .leading, spacing: JSpacing.xxs) {
                Text("Username")
                    .font(JFont.subheadlineMedium)
                    .foregroundStyle(JColor.textSecondary)

                HStack(spacing: JSpacing.xs) {
                    Text("@")
                        .font(JFont.body)
                        .foregroundStyle(JColor.textTertiary)

                    Text(appState.currentUser?.username ?? "")
                        .font(JFont.body)
                        .foregroundStyle(JColor.textTertiary)

                    Spacer()

                    Image(systemName: "lock.fill")
                        .font(.caption)
                        .foregroundStyle(JColor.textTertiary)
                }
                .padding(.horizontal, JSpacing.sm)
                .padding(.vertical, JSpacing.sm)
                .background(JColor.surfaceSecondary)
                .clipShape(RoundedRectangle(cornerRadius: JRadius.medium))
                .overlay {
                    RoundedRectangle(cornerRadius: JRadius.medium)
                        .strokeBorder(JColor.border, lineWidth: 1)
                }
            }

            // Email (read-only)
            VStack(alignment: .leading, spacing: JSpacing.xxs) {
                Text("Email")
                    .font(JFont.subheadlineMedium)
                    .foregroundStyle(JColor.textSecondary)

                HStack(spacing: JSpacing.xs) {
                    Text(appState.currentUser?.email ?? "")
                        .font(JFont.body)
                        .foregroundStyle(JColor.textTertiary)

                    Spacer()

                    Image(systemName: "lock.fill")
                        .font(.caption)
                        .foregroundStyle(JColor.textTertiary)
                }
                .padding(.horizontal, JSpacing.sm)
                .padding(.vertical, JSpacing.sm)
                .background(JColor.surfaceSecondary)
                .clipShape(RoundedRectangle(cornerRadius: JRadius.medium))
                .overlay {
                    RoundedRectangle(cornerRadius: JRadius.medium)
                        .strokeBorder(JColor.border, lineWidth: 1)
                }
            }

            // Bio
            VStack(alignment: .leading, spacing: JSpacing.xxs) {
                HStack {
                    Text("Bio")
                        .font(JFont.subheadlineMedium)
                        .foregroundStyle(JColor.textSecondary)

                    Spacer()

                    Text("\(viewModel.bioCharactersRemaining) remaining")
                        .font(JFont.caption)
                        .foregroundStyle(
                            viewModel.isBioOverLimit ? JColor.error : JColor.textTertiary
                        )
                }

                TextEditor(text: $viewModel.bio)
                    .font(JFont.body)
                    .foregroundStyle(JColor.textPrimary)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 100, maxHeight: 150)
                    .padding(JSpacing.sm)
                    .background(JColor.surface)
                    .clipShape(RoundedRectangle(cornerRadius: JRadius.medium))
                    .overlay {
                        RoundedRectangle(cornerRadius: JRadius.medium)
                            .strokeBorder(
                                viewModel.isBioOverLimit ? JColor.error : JColor.border,
                                lineWidth: 1
                            )
                    }

                if viewModel.isBioOverLimit {
                    Text("Bio must be \(viewModel.maxBioLength) characters or fewer")
                        .font(JFont.caption)
                        .foregroundStyle(JColor.error)
                }
            }
        }
    }
}

// MARK: - Save Button

private extension EditProfileView {

    var saveButton: some View {
        VStack(spacing: JSpacing.sm) {
            JButton(
                "Save Changes",
                style: .primary,
                size: .large,
                isLoading: viewModel.isProfileSaving,
                isDisabled: !viewModel.isProfileValid || !hasUnsavedChanges
            ) {
                Task {
                    await viewModel.updateProfile()
                }
            }

            if let error = viewModel.profileSaveError {
                Text(error)
                    .font(JFont.caption)
                    .foregroundStyle(JColor.error)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top, JSpacing.sm)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        EditProfileView()
    }
    .environment(AppState(keychainService: KeychainService(serviceName: "preview")))
}
