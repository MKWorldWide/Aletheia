import SwiftUI

struct ProfileCreationView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = ProfileCreationViewModel()
    
    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Theme.spacing * 2) {
                    Text("Initiation")
                        .font(Theme.titleFont)
                        .foregroundColor(Theme.gold)
                        .padding(.top, Theme.padding * 2)
                    
                    VStack(spacing: Theme.spacing) {
                        ProfileTextField(
                            text: $viewModel.name,
                            placeholder: "What name shall I remember you by?",
                            icon: "person.fill"
                        )
                        
                        ProfileTextField(
                            text: $viewModel.purpose,
                            placeholder: "What do you seek?",
                            icon: "eye.fill"
                        )
                        
                        ProfileTextField(
                            text: $viewModel.offering,
                            placeholder: "What are you prepared to give?",
                            icon: "hand.raised.fill"
                        )
                    }
                    .padding(.horizontal, Theme.padding)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(Theme.gold)
                    } else {
                        Button(action: {
                            Task {
                                await viewModel.createProfile()
                                if viewModel.error == nil {
                                    withAnimation {
                                        appState.isInitialized = true
                                    }
                                }
                            }
                        }) {
                            Text("Complete Initiation")
                                .font(Theme.bodyFont)
                                .foregroundColor(Theme.gold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Theme.surface)
                                .cornerRadius(Theme.cornerRadius)
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                        .stroke(Theme.gold, lineWidth: 1)
                                )
                        }
                        .disabled(!viewModel.isValid)
                        .opacity(viewModel.isValid ? 1 : 0.5)
                        .padding(.horizontal, Theme.padding)
                    }
                    
                    if let error = viewModel.error {
                        Text(error)
                            .font(Theme.captionFont)
                            .foregroundColor(.red)
                            .padding(.horizontal, Theme.padding)
                    }
                }
            }
        }
    }
}

struct ProfileTextField: View {
    @Binding var text: String
    let placeholder: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Theme.gold)
                .frame(width: 30)
            
            TextField(placeholder, text: $text)
                .font(Theme.bodyFont)
                .foregroundColor(Theme.text)
        }
        .padding()
        .background(Theme.surface)
        .cornerRadius(Theme.cornerRadius)
    }
}

class ProfileCreationViewModel: ObservableObject {
    @Published var name = ""
    @Published var purpose = ""
    @Published var offering = ""
    @Published var isLoading = false
    @Published var error: String?
    
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !purpose.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !offering.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    @MainActor
    func createProfile() async {
        isLoading = true
        error = nil
        
        do {
            let profile = UserProfile(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                purpose: purpose.trimmingCharacters(in: .whitespacesAndNewlines),
                offering: offering.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            
            try SecureStorage.saveProfile(profile)
            UserDefaults.standard.set(true, forKey: "isOnboarded")
        } catch {
            self.error = "Failed to save profile. Please try again."
        }
        
        isLoading = false
    }
}

#Preview {
    ProfileCreationView()
        .environmentObject(AppState())
} 