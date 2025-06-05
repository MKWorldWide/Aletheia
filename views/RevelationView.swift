import SwiftUI

struct RevelationView: View {
    @StateObject private var viewModel: RevelationViewModel
    @Environment(\.dismiss) private var dismiss
    
    let whisper: Whisper
    let response: String
    
    init(whisper: Whisper, response: String, viewModel: RevelationViewModel) {
        self.whisper = whisper
        self.response = response
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            // Background
            Color.black.edgesIgnoringSafeArea(.all)
            
            // Content
            VStack(spacing: 30) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding()
                
                // Whisper and Response
                VStack(alignment: .leading, spacing: 20) {
                    Text(whisper.question)
                        .font(.title3)
                        .foregroundColor(.gray)
                    
                    Text(response)
                        .font(.body)
                        .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal)
                
                Spacer()
                
                // Orb Animation
                ZStack {
                    // Glowing orb
                    Circle()
                        .fill(viewModel.moodColor)
                        .frame(width: 200, height: 200)
                        .blur(radius: 20)
                        .opacity(viewModel.orbGlowIntensity * 0.3)
                    
                    // Orb
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    viewModel.moodColor,
                                    viewModel.moodColor.opacity(0.5)
                                ]),
                                center: .center,
                                startRadius: 0,
                                endRadius: 100
                            )
                        )
                        .frame(width: 200, height: 200)
                        .overlay(
                            Circle()
                                .stroke(viewModel.moodColor, lineWidth: 2)
                                .blur(radius: 5)
                        )
                        .opacity(viewModel.orbGlowIntensity)
                    
                    // Sigil (if present)
                    if let sigil = viewModel.currentRevelation?.sigil {
                        Text(sigil)
                            .font(.system(size: 24, weight: .light, design: .serif))
                            .foregroundColor(.white)
                            .opacity(viewModel.orbGlowIntensity)
                    }
                }
                
                Spacer()
                
                // Revelation Text
                if let revelation = viewModel.currentRevelation {
                    VStack(spacing: 15) {
                        // Mood indicator
                        HStack {
                            Image(systemName: viewModel.moodIcon)
                                .foregroundColor(viewModel.moodColor)
                            Text(revelation.mood.rawValue)
                                .font(.caption)
                                .foregroundColor(viewModel.moodColor)
                        }
                        
                        // Revelation text
                        Text(revelation.text)
                            .font(.system(size: 20, weight: .light, design: .serif))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .opacity(viewModel.typingProgress)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    // Seal button
                    Button(action: {
                        Task {
                            await viewModel.sealRevelation()
                        }
                    }) {
                        Text("Seal This Revelation")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(viewModel.moodColor)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                } else if viewModel.isGenerating {
                    // Loading indicator
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "An unknown error occurred.")
        }
        .task {
            await viewModel.generateRevelation(whisper: whisper, response: response)
        }
    }
}

// MARK: - Preview

struct RevelationView_Previews: PreviewProvider {
    static var previews: some View {
        let whisper = Whisper(
            id: UUID(),
            question: "What truth do you seek in the shadows?",
            category: .shadow
        )
        
        let response = "I seek to understand the darkness within, to embrace it not as an enemy but as a teacher."
        
        let viewModel = RevelationViewModel(
            revelationEngine: RevelationEngine(
                userProfile: UserProfile(),
                storage: SecureStorage()
            ),
            whisperEngine: WhisperEngine()
        )
        
        return RevelationView(
            whisper: whisper,
            response: response,
            viewModel: viewModel
        )
    }
} 