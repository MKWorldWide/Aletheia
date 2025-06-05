import Foundation
import Combine

class WhisperViewModel: ObservableObject {
    @Published var response: String = ""
    @Published var isRevealing: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    private let whisperEngine: WhisperEngine
    private var cancellables = Set<AnyCancellable>()
    
    init(whisperEngine: WhisperEngine) {
        self.whisperEngine = whisperEngine
        setupBindings()
    }
    
    private func setupBindings() {
        whisperEngine.$isLocked
            .sink { [weak self] isLocked in
                if isLocked {
                    self?.showLockoutError()
                }
            }
            .store(in: &cancellables)
    }
    
    var currentWhisper: Whisper? {
        whisperEngine.currentWhisper
    }
    
    var isLocked: Bool {
        whisperEngine.isLocked
    }
    
    var lockoutTimeRemaining: TimeInterval? {
        guard let endTime = whisperEngine.lockoutEndTime else { return nil }
        return max(0, endTime.timeIntervalSince(Date()))
    }
    
    func submitResponse() {
        guard !response.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showError(message: "Your response cannot be empty")
            return
        }
        
        whisperEngine.answerCurrentWhisper(response)
        response = ""
    }
    
    func skipWhisper() {
        whisperEngine.skipCurrentWhisper()
    }
    
    func generateNewWhisper() {
        whisperEngine.generateNewWhisper()
    }
    
    func burnWhisper(_ whisper: Whisper) {
        whisperEngine.burnWhisper(whisper)
    }
    
    private func showLockoutError() {
        if let remaining = lockoutTimeRemaining {
            let hours = Int(remaining / 3600)
            let minutes = Int((remaining.truncatingRemainder(dividingBy: 3600)) / 60)
            showError(message: "Aelethia will remain silent for \(hours) hours and \(minutes) minutes")
        }
    }
    
    private func showError(message: String) {
        errorMessage = message
        showError = true
    }
    
    // MARK: - Formatting
    func formatLockoutTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval / 3600)
        let minutes = Int((timeInterval.truncatingRemainder(dividingBy: 3600)) / 60)
        return "\(hours)h \(minutes)m"
    }
} 