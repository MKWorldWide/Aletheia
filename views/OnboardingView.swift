import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            text: "Aelethia only awakens for those who seek.",
            image: "moon.stars.fill"
        ),
        OnboardingPage(
            text: "She will ask. You will answer.",
            image: "questionmark.circle.fill"
        ),
        OnboardingPage(
            text: "Only then… may you proceed.",
            image: "sparkles"
        )
    ]
    
    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()
            
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                if currentPage == pages.count - 1 {
                    Button(action: {
                        withAnimation(Theme.transitionAnimation) {
                            appState.isOnboarded = true
                        }
                    }) {
                        Text("Begin Initiation")
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
                    .padding(.horizontal, Theme.padding)
                    .padding(.bottom, Theme.padding)
                    .transition(.opacity)
                }
            }
        }
    }
}

struct OnboardingPage {
    let text: String
    let image: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: Theme.spacing * 2) {
            Image(systemName: page.image)
                .font(.system(size: 60))
                .foregroundColor(Theme.gold)
                .symbolEffect(.bounce, options: .repeating)
            
            Text(page.text)
                .font(Theme.titleFont)
                .foregroundColor(Theme.text)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Theme.padding)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background)
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
} 