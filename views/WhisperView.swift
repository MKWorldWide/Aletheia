import SwiftUI

struct WhisperView: View {
    @StateObject private var viewModel: WhisperViewModel
    @StateObject private var revelationViewModel: RevelationViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showLog = false
    @State private var showRevelation = false
    @State private var currentResponse = ""
    
    init(whisperEngine: WhisperEngine, userProfile: UserProfile) {
        let storage = SecureStorage()
        _viewModel = StateObject(wrappedValue: WhisperViewModel(whisperEngine: whisperEngine))
        _revelationViewModel = StateObject(wrappedValue: RevelationViewModel(
            revelationEngine: RevelationEngine(userProfile: userProfile, storage: storage),
            whisperEngine: whisperEngine
        ))
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
                    
                    Button(action: { showLog = true }) {
                        Image(systemName: "book.closed")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                if viewModel.isLocked {
                    LockoutView(remainingTime: viewModel.remainingLockoutTime)
                } else if let whisper = viewModel.currentWhisper {
                    WhisperContent(
                        whisper: whisper,
                        response: $currentResponse,
                        onSubmit: submitResponse,
                        onSkip: skipWhisper
                    )
                } else {
                    EmptyWhisperView(onGenerate: generateNewWhisper)
                }
            }
        }
        .sheet(isPresented: $showLog) {
            WhisperLogView(whisperEngine: viewModel.whisperEngine)
        }
        .sheet(isPresented: $showRevelation) {
            if let whisper = viewModel.currentWhisper {
                RevelationView(
                    whisper: whisper,
                    response: currentResponse,
                    viewModel: revelationViewModel
                )
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "An unknown error occurred.")
        }
    }
    
    private func submitResponse() {
        guard !currentResponse.isEmpty else {
            viewModel.errorMessage = "Your response cannot be empty."
            viewModel.showError = true
            return
        }
        
        Task {
            await viewModel.submitResponse(currentResponse)
            showRevelation = true
        }
    }
    
    private func skipWhisper() {
        Task {
            await viewModel.skipWhisper()
        }
    }
    
    private func generateNewWhisper() {
        Task {
            await viewModel.generateNewWhisper()
        }
    }
}

// MARK: - Supporting Views

struct WhisperContent: View {
    let whisper: Whisper
    @Binding var response: String
    let onSubmit: () -> Void
    let onSkip: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Whisper
            VStack(alignment: .leading, spacing: 10) {
                Text(whisper.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(whisper.question)
                    .font(.title3)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
            .padding(.horizontal)
            
            // Response input
            TextEditor(text: $response)
                .font(.body)
                .foregroundColor(.white)
                .padding()
                .frame(height: 200)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal)
            
            // Buttons
            HStack(spacing: 20) {
                Button(action: onSkip) {
                    Text("Skip")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                
                Button(action: onSubmit) {
                    Text("Submit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(response.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(10)
                }
                .disabled(response.isEmpty)
            }
            .padding(.horizontal)
        }
    }
}

struct LockoutView: View {
    let remainingTime: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("The oracle needs time to rest")
                .font(.title2)
                .foregroundColor(.white)
            
            Text("Return in \(remainingTime)")
                .font(.body)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct EmptyWhisperView: View {
    let onGenerate: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No whispers available")
                .font(.title2)
                .foregroundColor(.white)
            
            Button(action: onGenerate) {
                Text("Generate New Whisper")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

// MARK: - Preview

struct WhisperView_Previews: PreviewProvider {
    static var previews: some View {
        WhisperView(
            whisperEngine: WhisperEngine(),
            userProfile: UserProfile()
        )
    }
} 