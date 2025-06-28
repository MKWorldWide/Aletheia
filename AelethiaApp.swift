import SwiftUI

/// Main application entry point for Aletheia AI Companion
@main
struct AelethiaApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(.dark)
        }
    }
}

// MARK: - App State Management

/// Global application state manager
class AppState: ObservableObject {
    // MARK: - Published Properties
    
    @Published var isOnboarded: Bool = false
    @Published var currentUser: UserProfile?
    @Published var isInitialized: Bool = false
    
    // MARK: - Initialization
    
    init() {
        loadOnboardingState()
        loadUserProfile()
    }
    
    // MARK: - Private Methods
    
    /// Load onboarding completion state from UserDefaults
    private func loadOnboardingState() {
        isOnboarded = UserDefaults.standard.bool(forKey: "isOnboarded")
    }
    
    /// Load user profile from secure storage
    private func loadUserProfile() {
        // TODO: Implement secure profile loading using Keychain
        // This will be implemented in a future update
    }
} 