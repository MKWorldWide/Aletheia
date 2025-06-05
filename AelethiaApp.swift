import SwiftUI

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

// MARK: - App State
class AppState: ObservableObject {
    @Published var isOnboarded: Bool = false
    @Published var currentUser: UserProfile?
    @Published var isInitialized: Bool = false
    
    init() {
        // Check if user has completed onboarding
        self.isOnboarded = UserDefaults.standard.bool(forKey: "isOnboarded")
        loadUserProfile()
    }
    
    private func loadUserProfile() {
        // TODO: Implement secure profile loading
    }
} 