import SwiftUI

// Quantum Documentation: ContentView.swift
// Feature Context: Main entry point and navigation for Aletheia's UI.
// Dependencies: AppState, OracleEngine, ArchetypeEngine, SecureStorage, SwiftUI
// Usage Example: ContentView().environmentObject(AppState())
// Performance: Uses SwiftUI state and environment for efficient updates.
// Security: No direct security implications.
// Changelog: [2024-06-10] Upgraded documentation to quantum-detailed standard.

struct ContentView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var oracleEngine = OracleEngine()
    
    var body: some View {
        Group {
            if !appState.isOnboarded {
                OnboardingView()
            } else if !appState.isInitialized {
                ProfileCreationView()
            } else {
                MainView()
                    .environmentObject(oracleEngine)
            }
        }
        .animation(.easeInOut, value: appState.isOnboarded)
        .animation(.easeInOut, value: appState.isInitialized)
    }
}

struct MainView: View {
    @StateObject private var oracleEngine: OracleEngine
    @StateObject private var archetypeEngine: ArchetypeEngine
    @State private var showWhispers = false
    @State private var showCodex = false
    @State private var showArchetypes = false
    @State private var showSoulMap = false
    @State private var showArchetypeNotification = false
    
    init() {
        let storage = SecureStorage()
        let codex = Codex(storage: storage)
        _oracleEngine = StateObject(wrappedValue: OracleEngine(storage: storage))
        _archetypeEngine = StateObject(wrappedValue: ArchetypeEngine(codex: codex, storage: storage))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color.black.edgesIgnoringSafeArea(.all)
                
                // Content
                VStack(spacing: 30) {
                    // Header
                    HStack {
                        Text("Aelethia")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        HStack(spacing: 20) {
                            Button(action: { showSoulMap = true }) {
                                Image(systemName: "map")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                            }
                            
                            Button(action: { showArchetypes = true }) {
                                Image(systemName: "sparkles")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                            }
                            
                            Button(action: { showCodex = true }) {
                                Image(systemName: "book.closed")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    
                    // Main content
                    ScrollView {
                        VStack(spacing: 20) {
                            // Whisper button
                            Button(action: { showWhispers = true }) {
                                HStack {
                                    Image(systemName: "sparkles")
                                        .font(.title2)
                                    
                                    Text("Whispers")
                                        .font(.headline)
                                }
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                            }
                            .padding(.horizontal)
                            
                            // Profile section
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Your Journey")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                
                                Text("Name: \(oracleEngine.userProfile.name)")
                                    .foregroundColor(.gray)
                                
                                Text("Purpose: \(oracleEngine.userProfile.purpose)")
                                    .foregroundColor(.gray)
                                
                                Text("Offering: \(oracleEngine.userProfile.offering)")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(15)
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showWhispers) {
            WhisperView(
                whisperEngine: WhisperEngine(userProfile: oracleEngine.userProfile),
                userProfile: oracleEngine.userProfile
            )
        }
        .sheet(isPresented: $showCodex) {
            CodexView(codex: Codex(storage: SecureStorage()))
        }
        .sheet(isPresented: $showArchetypes) {
            ArchetypeView(
                codex: Codex(storage: SecureStorage()),
                storage: SecureStorage()
            )
        }
        .sheet(isPresented: $showSoulMap) {
            SoulMapView(
                codex: Codex(storage: SecureStorage()),
                storage: SecureStorage()
            )
        }
        .overlay {
            if showArchetypeNotification {
                ArchetypeNotificationView(
                    archetype: archetypeEngine.newlyUnlockedArchetype
                )
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .onChange(of: archetypeEngine.newlyUnlockedArchetype) { archetype in
            if archetype != nil {
                withAnimation {
                    showArchetypeNotification = true
                }
                
                // Hide notification after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation {
                        showArchetypeNotification = false
                    }
                }
            }
        }
    }
}

struct ArchetypeNotificationView: View {
    let archetype: Archetype?
    
    var body: some View {
        if let archetype = archetype {
            VStack(spacing: 15) {
                Text(archetype.symbol)
                    .font(.system(size: 40))
                
                Text("A New Archetype Awakens")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(archetype.name)
                    .font(.title3)
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(15)
            .padding()
        }
    }
}

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var profile: UserProfile?
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background
                    .ignoresSafeArea()
                
                if let profile = profile {
                    ScrollView {
                        VStack(spacing: Theme.spacing * 2) {
                            ProfileField(title: "Name", value: profile.name)
                            ProfileField(title: "Purpose", value: profile.purpose)
                            ProfileField(title: "Offering", value: profile.offering)
                        }
                        .padding(Theme.padding)
                    }
                } else {
                    ProgressView()
                        .tint(Theme.gold)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Theme.gold)
                }
            }
        }
        .onAppear {
            loadProfile()
        }
    }
    
    private func loadProfile() {
        do {
            profile = try SecureStorage.loadProfile()
        } catch {
            // Handle error
        }
    }
}

struct ProfileField: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing / 2) {
            Text(title)
                .font(Theme.captionFont)
                .foregroundColor(Theme.gold)
            
            Text(value)
                .font(Theme.bodyFont)
                .foregroundColor(Theme.text)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Theme.surface)
        .cornerRadius(Theme.cornerRadius)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
} 