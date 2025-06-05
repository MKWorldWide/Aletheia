import Foundation
import Combine

// MARK: - Whisper Types
enum WhisperCategory: String, Codable {
    case shadowWork = "Shadow Work"
    case revelation = "Revelation"
    case truth = "Truth"
    case memory = "Memory"
    case resistance = "Resistance"
    
    var description: String {
        switch self {
        case .shadowWork: return "Confront your inner darkness"
        case .revelation: return "Receive divine insight"
        case .truth: return "Face your deepest truths"
        case .memory: return "Remember what was forgotten"
        case .resistance: return "Overcome your barriers"
        }
    }
}

struct Whisper: Identifiable, Codable {
    let id: UUID
    let question: String
    let category: WhisperCategory
    let requiresResponse: Bool
    let unlockCondition: String?
    var response: String?
    var answeredAt: Date?
    var skippedAt: Date?
    
    init(
        id: UUID = UUID(),
        question: String,
        category: WhisperCategory,
        requiresResponse: Bool = true,
        unlockCondition: String? = nil
    ) {
        self.id = id
        self.question = question
        self.category = category
        self.requiresResponse = requiresResponse
        self.unlockCondition = unlockCondition
    }
}

// MARK: - Whisper Engine
class WhisperEngine: ObservableObject {
    @Published private(set) var currentWhisper: Whisper?
    @Published private(set) var answeredWhispers: [Whisper] = []
    @Published private(set) var skippedWhispers: [Whisper] = []
    @Published private(set) var isLocked: Bool = false
    @Published private(set) var lockoutEndTime: Date?
    
    private let userProfile: UserProfile
    private let lockoutDuration: TimeInterval = 6 * 60 * 60 // 6 hours
    private var cancellables = Set<AnyCancellable>()
    
    init(userProfile: UserProfile) {
        self.userProfile = userProfile
        loadWhispers()
        checkLockoutStatus()
    }
    
    // MARK: - Whisper Management
    func generateNewWhisper() {
        guard !isLocked else { return }
        
        // TODO: Replace with AI-generated whispers
        let whispers = [
            Whisper(
                question: "What shadow within you seeks the light?",
                category: .shadowWork
            ),
            Whisper(
                question: "What truth have you been avoiding?",
                category: .truth
            ),
            Whisper(
                question: "What memory haunts your dreams?",
                category: .memory
            ),
            Whisper(
                question: "What resistance keeps you from your purpose?",
                category: .resistance
            ),
            Whisper(
                question: "What revelation awaits your awakening?",
                category: .revelation
            )
        ]
        
        // Filter whispers based on user's profile and state
        let availableWhispers = whispers.filter { whisper in
            // TODO: Implement more sophisticated filtering based on user's state
            !answeredWhispers.contains(where: { $0.id == whisper.id }) &&
            !skippedWhispers.contains(where: { $0.id == whisper.id })
        }
        
        if let newWhisper = availableWhispers.randomElement() {
            currentWhisper = newWhisper
        }
    }
    
    func answerCurrentWhisper(_ response: String) {
        guard var whisper = currentWhisper else { return }
        
        whisper.response = response
        whisper.answeredAt = Date()
        
        answeredWhispers.append(whisper)
        currentWhisper = nil
        
        saveWhispers()
    }
    
    func skipCurrentWhisper() {
        guard var whisper = currentWhisper else { return }
        
        whisper.skippedAt = Date()
        skippedWhispers.append(whisper)
        currentWhisper = nil
        
        // Implement lockout
        isLocked = true
        lockoutEndTime = Date().addingTimeInterval(lockoutDuration)
        
        saveWhispers()
        saveLockoutStatus()
    }
    
    func burnWhisper(_ whisper: Whisper) {
        answeredWhispers.removeAll { $0.id == whisper.id }
        saveWhispers()
    }
    
    // MARK: - Private Methods
    private func loadWhispers() {
        // TODO: Implement secure loading from storage
    }
    
    private func saveWhispers() {
        // TODO: Implement secure saving to storage
    }
    
    private func checkLockoutStatus() {
        guard let endTime = lockoutEndTime else {
            isLocked = false
            return
        }
        
        if Date() >= endTime {
            isLocked = false
            lockoutEndTime = nil
            saveLockoutStatus()
        } else {
            isLocked = true
        }
    }
    
    private func saveLockoutStatus() {
        UserDefaults.standard.set(lockoutEndTime, forKey: "whisperLockoutEndTime")
    }
    
    // MARK: - Utility Methods
    func getWhispersByCategory(_ category: WhisperCategory) -> [Whisper] {
        answeredWhispers.filter { $0.category == category }
    }
    
    var pendingWhispersCount: Int {
        // TODO: Implement actual count based on available whispers
        1
    }
} 