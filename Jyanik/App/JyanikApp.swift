//
//  JyanikApp.swift
//  Jyanik
//
//  Main entry point for the Jyanik trading competition app
//

import SwiftUI
import SwiftData

@main
struct JyanikApp: App {
    @State private var appState: AppState

    private let keychainService: KeychainService

    init() {
        let keychain = KeychainService.shared
        self.keychainService = keychain
        self._appState = State(initialValue: AppState(keychainService: keychain))
    }

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            Portfolio.self,
            Position.self,
            SavedStock.self,
            SavedScreener.self,
            CachedNotification.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .modelContainer(sharedModelContainer)
        }
    }
}
