import Foundation
import SwiftUI
import Combine

class RevelationViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var isGenerating = false
    @Published var currentRevelation: Revelation?
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var typingProgress: Double = 0
    @Published var orbGlowIntensity: Double = 0
    
    // MARK: - Private Properties
    
    private let revelationEngine: RevelationEngine
    private let whisperEngine: WhisperEngine
    private var cancellables = Set<AnyCancellable>()
    private let typingSpeed: Double = 0.05 // seconds per character
    private let glowPulseDuration: Double = 2.0 // seconds
    
    // MARK: - Initialization
    
    init(revelationEngine: RevelationEngine, whisperEngine: WhisperEngine) {
        self.revelationEngine = revelationEngine
        self.whisperEngine = whisperEngine
        setupBindings()
    }
    
    // MARK: - Public Methods
    
    /// Generates a revelation for the current whisper and response
    func generateRevelation(whisper: Whisper, response: String) async {
        guard !isGenerating else { return }
        
        await MainActor.run {
            isGenerating = true
            currentRevelation = nil
            errorMessage = nil
            showError = false
            typingProgress = 0
            orbGlowIntensity = 0
        }
        
        do {
            // Start the glow animation
            await startGlowAnimation()
            
            // Generate the revelation
            let revelation = try await revelationEngine.generateRevelation(
                whisper: whisper,
                response: response
            )
            
            // Simulate typing animation
            await simulateTypingAnimation(revelation.text)
            
            // Update the UI with the revelation
            await MainActor.run {
                currentRevelation = revelation
                isGenerating = false
            }
        } catch {
            await MainActor.run {
                errorMessage = "The oracle's vision is clouded. Please try again."
                showError = true
                isGenerating = false
            }
        }
    }
    
    /// Seals the current revelation in the user's codex
    func sealRevelation() async {
        guard let revelation = currentRevelation else { return }
        
        do {
            // TODO: Implement codex storage
            // For now, just print to console
            print("Sealing revelation: \(revelation.text)")
            
            await MainActor.run {
                // Add a subtle animation or feedback
                withAnimation(.easeInOut(duration: 0.5)) {
                    orbGlowIntensity = 1.0
                }
            }
            
            // Reset the glow after a delay
            try await Task.sleep(nanoseconds: 1_000_000_000)
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.5)) {
                    orbGlowIntensity = 0
                }
            }
        } catch {
            await MainActor.run {
                errorMessage = "The seal could not be placed. Please try again."
                showError = true
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        // Add any necessary bindings to the whisper engine
        // For example, we might want to react to whisper state changes
    }
    
    private func startGlowAnimation() async {
        // Create a pulsing glow effect
        for _ in 0..<3 {
            await MainActor.run {
                withAnimation(.easeInOut(duration: glowPulseDuration)) {
                    orbGlowIntensity = 1.0
                }
            }
            try? await Task.sleep(nanoseconds: UInt64(glowPulseDuration * 1_000_000_000))
            await MainActor.run {
                withAnimation(.easeInOut(duration: glowPulseDuration)) {
                    orbGlowIntensity = 0
                }
            }
            try? await Task.sleep(nanoseconds: UInt64(glowPulseDuration * 0.5 * 1_000_000_000))
        }
    }
    
    private func simulateTypingAnimation(_ text: String) async {
        let totalCharacters = text.count
        var currentCharacters = 0
        
        while currentCharacters < totalCharacters {
            currentCharacters += 1
            await MainActor.run {
                typingProgress = Double(currentCharacters) / Double(totalCharacters)
            }
            try? await Task.sleep(nanoseconds: UInt64(typingSpeed * 1_000_000_000))
        }
    }
}

// MARK: - Supporting Extensions

extension RevelationViewModel {
    /// Returns the color for the current revelation's mood
    var moodColor: Color {
        guard let revelation = currentRevelation else { return .gray }
        
        switch revelation.mood {
        case .calm:
            return .blue
        case .haunting:
            return .purple
        case .affirming:
            return .green
        case .cryptic:
            return .orange
        }
    }
    
    /// Returns the icon for the current revelation's mood
    var moodIcon: String {
        guard let revelation = currentRevelation else { return "questionmark.circle" }
        
        switch revelation.mood {
        case .calm:
            return "moon.stars"
        case .haunting:
            return "cloud.moon"
        case .affirming:
            return "sun.max"
        case .cryptic:
            return "sparkles"
        }
    }
} 