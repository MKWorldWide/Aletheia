import Foundation
import Combine

/// Quantum Documentation: ArchetypeEngine.swift
/// Feature Context: Manages awakening and tracking of spiritual archetypes.
/// Dependencies: Archetype, Codex, SecureStorage, Combine
/// Usage Example: let engine = ArchetypeEngine(codex: codex, storage: storage)
/// Performance: Observes codex changes; unlock logic based on user journey.
/// Security: Persists archetype state securely.
/// Changelog: [2024-06-10] Upgraded documentation to quantum-detailed standard.
/// Manages the awakening and tracking of spiritual archetypes
class ArchetypeEngine: ObservableObject {
    @Published private(set) var archetypes: [Archetype]
    @Published private(set) var newlyUnlockedArchetype: Archetype?
    
    private let codex: Codex
    private let storage: SecureStorage
    private var cancellables = Set<AnyCancellable>()
    
    init(codex: Codex, storage: SecureStorage) {
        self.codex = codex
        self.storage = storage
        self.archetypes = Archetype.predefined
        
        // Load saved archetypes
        loadArchetypes()
        
        // Observe codex changes
        codex.objectWillChange
            .sink { [weak self] _ in
                self?.checkForNewArchetypes()
            }
            .store(in: &cancellables)
    }
    
    /// Checks if any new archetypes should be unlocked based on the user's journey
    private func checkForNewArchetypes() {
        let revelations = codex.chapters.flatMap { $0.revelations }
        let emotionalWeight = calculateEmotionalWeight(from: revelations)
        let categories = Set(revelations.compactMap { $0.revelation.whisper?.category })
        
        for (index, archetype) in archetypes.enumerated() where !archetype.unlocked {
            if shouldUnlockArchetype(
                archetype,
                revelationsCount: revelations.count,
                emotionalWeight: emotionalWeight,
                categories: categories
            ) {
                unlockArchetype(at: index, with: revelations.last?.id)
            }
        }
    }
    
    /// Determines if an archetype should be unlocked based on conditions
    private func shouldUnlockArchetype(
        _ archetype: Archetype,
        revelationsCount: Int,
        emotionalWeight: Int,
        categories: Set<WhisperCategory>
    ) -> Bool {
        revelationsCount >= archetype.unlockCondition.requiredRevelations &&
        emotionalWeight >= archetype.unlockCondition.requiredEmotionalWeight &&
        archetype.unlockCondition.requiredCategories.isSubset(of: categories)
    }
    
    /// Unlocks an archetype and saves the state
    private func unlockArchetype(at index: Int, with revelationId: UUID?) {
        var updatedArchetype = archetypes[index]
        updatedArchetype.unlocked = true
        updatedArchetype.unlockedAt = Date()
        updatedArchetype.associatedRevelationId = revelationId
        
        archetypes[index] = updatedArchetype
        newlyUnlockedArchetype = updatedArchetype
        
        // Save updated archetypes
        saveArchetypes()
        
        // Clear the newly unlocked archetype after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.newlyUnlockedArchetype = nil
        }
    }
    
    /// Calculates the emotional weight of revelations
    private func calculateEmotionalWeight(from revelations: [SealedRevelation]) -> Int {
        // For now, use a simple scoring system based on revelation count and mood
        let baseWeight = revelations.count
        
        let moodMultiplier = revelations.reduce(1.0) { total, revelation in
            switch revelation.revelation.mood {
            case .calm:
                return total + 0.5
            case .haunting:
                return total + 1.0
            case .affirming:
                return total + 0.8
            case .cryptic:
                return total + 0.7
            }
        }
        
        return Int(Double(baseWeight) * moodMultiplier)
    }
    
    /// Generates a whisper aligned with a specific archetype
    func generateAlignedWhisper(for archetype: Archetype) -> Whisper {
        // For now, return a placeholder whisper
        // This will be expanded with AI-generated content later
        Whisper(
            id: UUID(),
            question: "How does the \(archetype.name.lowercased()) speak to your current journey?",
            category: .wisdom,
            createdAt: Date()
        )
    }
    
    // MARK: - Persistence
    
    private func loadArchetypes() {
        do {
            if let data = try storage.load(key: "archetypes") {
                archetypes = try JSONDecoder().decode([Archetype].self, from: data)
            }
        } catch {
            print("Failed to load archetypes: \(error)")
        }
    }
    
    private func saveArchetypes() {
        do {
            let data = try JSONEncoder().encode(archetypes)
            try storage.save(data, key: "archetypes")
        } catch {
            print("Failed to save archetypes: \(error)")
        }
    }
} 