import Foundation

/// A sealed revelation stored in the user's codex
struct SealedRevelation: Codable, Identifiable {
    let id: UUID
    let revelation: Revelation
    let sealedAt: Date
    let chapter: Int
    let page: Int
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: sealedAt)
    }
}

/// The user's sacred codex containing all sealed revelations
class Codex: ObservableObject {
    @Published private(set) var chapters: [Chapter] = []
    private let storage: SecureStorage
    
    init(storage: SecureStorage) {
        self.storage = storage
        loadChapters()
    }
    
    /// Seals a revelation in the codex
    func sealRevelation(_ revelation: Revelation) async throws {
        // Create a new sealed revelation
        let sealedRevelation = SealedRevelation(
            id: UUID(),
            revelation: revelation,
            sealedAt: Date(),
            chapter: chapters.count + 1,
            page: (chapters.last?.revelations.count ?? 0) + 1
        )
        
        // Add to the current chapter or create a new one
        if var currentChapter = chapters.last, currentChapter.revelations.count < 10 {
            currentChapter.revelations.append(sealedRevelation)
            chapters[chapters.count - 1] = currentChapter
        } else {
            let newChapter = Chapter(
                id: UUID(),
                number: chapters.count + 1,
                title: generateChapterTitle(),
                revelations: [sealedRevelation]
            )
            chapters.append(newChapter)
        }
        
        // Save to secure storage
        try await saveChapters()
    }
    
    /// Retrieves all revelations from a specific chapter
    func revelationsInChapter(_ chapterNumber: Int) -> [SealedRevelation] {
        chapters.first { $0.number == chapterNumber }?.revelations ?? []
    }
    
    /// Retrieves a specific revelation by ID
    func revelation(withId id: UUID) -> SealedRevelation? {
        for chapter in chapters {
            if let revelation = chapter.revelations.first(where: { $0.id == id }) {
                return revelation
            }
        }
        return nil
    }
    
    // MARK: - Private Methods
    
    private func loadChapters() {
        // TODO: Load from secure storage
        // For now, start with empty chapters
        chapters = []
    }
    
    private func saveChapters() async throws {
        // TODO: Save to secure storage
        // For now, just print to console
        print("Saving \(chapters.count) chapters to codex")
    }
    
    private func generateChapterTitle() -> String {
        let titles = [
            "The Awakening",
            "The Journey",
            "The Reflection",
            "The Transformation",
            "The Revelation",
            "The Wisdom",
            "The Truth",
            "The Path",
            "The Light",
            "The Shadow"
        ]
        
        return titles[chapters.count % titles.count]
    }
}

// MARK: - Supporting Types

struct Chapter: Identifiable {
    let id: UUID
    let number: Int
    let title: String
    var revelations: [SealedRevelation]
} 