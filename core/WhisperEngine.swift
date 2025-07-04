import Foundation
import Combine

// MARK: - Whisper Types

/// Categories for different types of whispers
enum WhisperCategory: String, Codable, CaseIterable {
    case shadowWork = "Shadow Work"
    case revelation = "Revelation"
    case truth = "Truth"
    case memory = "Memory"
    case resistance = "Resistance"
    
    var description: String {
        switch self {
        case .shadowWork:
            return "Confront your inner darkness"
        case .revelation:
            return "Receive divine insight"
        case .truth:
            return "Face your deepest truths"
        case .memory:
            return "Remember what was forgotten"
        case .resistance:
            return "Overcome your barriers"
        }
    }
    
    var emoji: String {
        switch self {
        case .shadowWork: return "🌑"
        case .revelation: return "✨"
        case .truth: return "🔮"
        case .memory: return "💭"
        case .resistance: return "🛡️"
        }
    }
}

/// Represents a single whisper question and its response
struct Whisper: Identifiable, Codable, Equatable {
    // MARK: - Properties
    
    let id: UUID
    let question: String
    let category: WhisperCategory
    let requiresResponse: Bool
    let unlockCondition: String?
    var response: String?
    var answeredAt: Date?
    var skippedAt: Date?
    
    // MARK: - Initialization
    
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
    
    // MARK: - Computed Properties
    
    var isAnswered: Bool {
        answeredAt != nil
    }
    
    var isSkipped: Bool {
        skippedAt != nil
    }
    
    var status: WhisperStatus {
        if isAnswered {
            return .answered
        } else if isSkipped {
            return .skipped
        } else {
            return .pending
        }
    }
}

/// Status of a whisper
enum WhisperStatus {
    case pending
    case answered
    case skipped
}

// MARK: - Whisper Engine

/// Manages the generation, storage, and interaction with whispers
class WhisperEngine: ObservableObject {
    // MARK: - Published Properties
    
    @Published private(set) var currentWhisper: Whisper?
    @Published private(set) var answeredWhispers: [Whisper] = []
    @Published private(set) var skippedWhispers: [Whisper] = []
    @Published private(set) var isLocked: Bool = false
    @Published private(set) var lockoutEndTime: Date?
    
    // MARK: - Private Properties
    
    private let userProfile: UserProfile
    private let lockoutDuration: TimeInterval = 6 * 60 * 60 // 6 hours
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(userProfile: UserProfile) {
        self.userProfile = userProfile
        loadWhispers()
        checkLockoutStatus()
    }
    
    // MARK: - Public Methods
    
    /// Generate a new whisper for the user
    func generateNewWhisper() {
        guard !isLocked else { return }
        
        let availableWhispers = getAvailableWhispers()
        
        if let newWhisper = availableWhispers.randomElement() {
            currentWhisper = newWhisper
        }
    }
    
    /// Answer the current whisper with a response
    /// - Parameter response: The user's response to the whisper
    func answerCurrentWhisper(_ response: String) {
        guard var whisper = currentWhisper else { return }
        
        whisper.response = response
        whisper.answeredAt = Date()
        
        answeredWhispers.append(whisper)
        currentWhisper = nil
        
        saveWhispers()
    }
    
    /// Skip the current whisper (triggers lockout)
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
    
    /// Remove a whisper from answered whispers (burn it)
    /// - Parameter whisper: The whisper to burn
    func burnWhisper(_ whisper: Whisper) {
        answeredWhispers.removeAll { $0.id == whisper.id }
        saveWhispers()
    }
    
    /// Get whispers filtered by category
    /// - Parameter category: The category to filter by
    /// - Returns: Array of whispers in the specified category
    func getWhispersByCategory(_ category: WhisperCategory) -> [Whisper] {
        answeredWhispers.filter { $0.category == category }
    }
    
    // MARK: - Private Methods
    
    private func getAvailableWhispers() -> [Whisper] {
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
        return whispers.filter { whisper in
            !answeredWhispers.contains(where: { $0.id == whisper.id }) &&
            !skippedWhispers.contains(where: { $0.id == whisper.id })
        }
    }
    
    private func loadWhispers() {
        // TODO: Implement secure loading from storage
        // This will be implemented in a future update
    }
    
    private func saveWhispers() {
        // TODO: Implement secure saving to storage
        // This will be implemented in a future update
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
}

// MARK: - Computed Properties

extension WhisperEngine {
    var pendingWhispersCount: Int {
        // TODO: Implement actual count based on available whispers
        1
    }
    
    var totalWhispersAnswered: Int {
        answeredWhispers.count
    }
    
    var totalWhispersSkipped: Int {
        skippedWhispers.count
    }
}

// Quantum Documentation: WhisperEngine.swift
// Feature Context: Manages generation, storage, and interaction with 'whispers' (spiritual prompts) in Aletheia.
// Dependencies: UserProfile, Whisper, WhisperCategory, SecureStorage, UserDefaults, Combine
// Usage Example: let engine = WhisperEngine(userProfile: profile); engine.generateNewWhisper()
// Performance: Lockout logic and in-memory filtering; TODOs for persistent storage.
// Security: TODOs for secure storage; lockout state uses UserDefaults.
// Changelog: [2024-06-10] Upgraded documentation to quantum-detailed standard. 