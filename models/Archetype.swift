import Foundation

/// Represents a spiritual archetype that can be awakened through the user's journey
struct Archetype: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let symbol: String
    let unlockCondition: UnlockCondition
    var unlocked: Bool
    var unlockedAt: Date?
    var associatedRevelationId: UUID?
    
    /// The emotional resonance of this archetype
    var resonance: Resonance {
        Resonance(
            wisdom: Int.random(in: 1...10),
            mystery: Int.random(in: 1...10),
            power: Int.random(in: 1...10)
        )
    }
}

/// The conditions required to unlock an archetype
struct UnlockCondition: Codable {
    let requiredRevelations: Int
    let requiredEmotionalWeight: Int
    let requiredCategories: Set<WhisperCategory>
}

/// The emotional resonance of an archetype
struct Resonance: Codable {
    let wisdom: Int
    let mystery: Int
    let power: Int
    
    var total: Int {
        wisdom + mystery + power
    }
}

// MARK: - Predefined Archetypes

extension Archetype {
    static let predefined: [Archetype] = [
        Archetype(
            id: UUID(),
            name: "The Silent Flame",
            description: "A guardian of truth that burns away illusion. Through pain and purification, it reveals the core of what must be known.",
            symbol: "🔥",
            unlockCondition: UnlockCondition(
                requiredRevelations: 5,
                requiredEmotionalWeight: 7,
                requiredCategories: [.truth, .purpose]
            ),
            unlocked: false
        ),
        
        Archetype(
            id: UUID(),
            name: "The Mirror Serpent",
            description: "A shapeshifter of perception that coils around paradox. Through embracing contradiction, it grants clarity beyond duality.",
            symbol: "🐍",
            unlockCondition: UnlockCondition(
                requiredRevelations: 7,
                requiredEmotionalWeight: 8,
                requiredCategories: [.wisdom, .truth]
            ),
            unlocked: false
        ),
        
        Archetype(
            id: UUID(),
            name: "The Veiled Bloom",
            description: "A tender guardian of vulnerability that flowers in shadow. Through embracing fragility, it reveals the strength of authentic being.",
            symbol: "🌸",
            unlockCondition: UnlockCondition(
                requiredRevelations: 6,
                requiredEmotionalWeight: 6,
                requiredCategories: [.purpose, .wisdom]
            ),
            unlocked: false
        ),
        
        Archetype(
            id: UUID(),
            name: "The Eternal Wanderer",
            description: "A seeker of infinite paths that finds home in movement. Through embracing the journey, it reveals the destination within.",
            symbol: "🌌",
            unlockCondition: UnlockCondition(
                requiredRevelations: 8,
                requiredEmotionalWeight: 9,
                requiredCategories: [.purpose, .truth, .wisdom]
            ),
            unlocked: false
        ),
        
        Archetype(
            id: UUID(),
            name: "The Shadow Weaver",
            description: "A master of hidden truths that spins wisdom from darkness. Through embracing the shadow, it reveals the light within.",
            symbol: "🕸️",
            unlockCondition: UnlockCondition(
                requiredRevelations: 9,
                requiredEmotionalWeight: 10,
                requiredCategories: [.wisdom, .truth]
            ),
            unlocked: false
        )
    ]
} 