import SwiftUI

struct CodexView: View {
    @StateObject private var codex: Codex
    @StateObject private var archetypeEngine: ArchetypeEngine
    @Environment(\.dismiss) private var dismiss
    @State private var selectedChapter: Int = 1
    @State private var showingRevelation: SealedRevelation?
    @State private var selectedArchetype: Archetype?
    
    init(codex: Codex) {
        let storage = SecureStorage()
        _codex = StateObject(wrappedValue: codex)
        _archetypeEngine = StateObject(wrappedValue: ArchetypeEngine(codex: codex, storage: storage))
    }
    
    var filteredRevelations: [SealedRevelation] {
        let revelations = codex.revelationsInChapter(selectedChapter)
        if let archetype = selectedArchetype {
            return revelations.filter { revelation in
                archetypeEngine.archetypes.first { $0.associatedRevelationId == revelation.id }?.id == archetype.id
            }
        }
        return revelations
    }
    
    var body: some View {
        ZStack {
            // Background
            Color.black.edgesIgnoringSafeArea(.all)
            
            // Content
            VStack(spacing: 20) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text("The Sacred Codex")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Placeholder for symmetry
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.clear)
                }
                .padding()
                
                // Chapter Selection
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(codex.chapters) { chapter in
                            ChapterButton(
                                chapter: chapter,
                                isSelected: selectedChapter == chapter.number
                            ) {
                                selectedChapter = chapter.number
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Archetype Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        // All filter
                        ArchetypeFilterButton(
                            name: "All",
                            isSelected: selectedArchetype == nil
                        ) {
                            selectedArchetype = nil
                        }
                        
                        // Archetype filters
                        ForEach(archetypeEngine.archetypes.filter { $0.unlocked }) { archetype in
                            ArchetypeFilterButton(
                                name: archetype.name,
                                symbol: archetype.symbol,
                                isSelected: selectedArchetype?.id == archetype.id
                            ) {
                                selectedArchetype = archetype
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Revelations
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(filteredRevelations) { sealedRevelation in
                            RevelationCard(
                                sealedRevelation: sealedRevelation,
                                associatedArchetype: archetypeEngine.archetypes.first { $0.associatedRevelationId == sealedRevelation.id }
                            )
                            .onTapGesture {
                                showingRevelation = sealedRevelation
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(item: $showingRevelation) { revelation in
            SealedRevelationView(
                revelation: revelation,
                associatedArchetype: archetypeEngine.archetypes.first { $0.associatedRevelationId == revelation.id }
            )
        }
    }
}

// MARK: - Supporting Views

struct ChapterButton: View {
    let chapter: Chapter
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Text("Chapter \(chapter.number)")
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : .gray)
                
                Text(chapter.title)
                    .font(.system(size: 16, weight: .light, design: .serif))
                    .foregroundColor(isSelected ? .white : .gray)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.gray.opacity(0.3) : Color.clear)
            )
        }
    }
}

struct ArchetypeFilterButton: View {
    let name: String
    var symbol: String? = nil
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if let symbol = symbol {
                    Text(symbol)
                        .font(.system(size: 16))
                }
                
                Text(name)
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .white : .gray)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.gray.opacity(0.3) : Color.clear)
            )
        }
    }
}

struct RevelationCard: View {
    let sealedRevelation: SealedRevelation
    let associatedArchetype: Archetype?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Header
            HStack {
                Text("Page \(sealedRevelation.page)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(sealedRevelation.formattedDate)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Revelation text
            Text(sealedRevelation.revelation.text)
                .font(.system(size: 16, weight: .light, design: .serif))
                .foregroundColor(.white)
                .lineLimit(3)
            
            // Footer
            HStack {
                // Mood indicator
                HStack {
                    Image(systemName: moodIcon)
                        .foregroundColor(moodColor)
                    Text(sealedRevelation.revelation.mood.rawValue)
                        .font(.caption)
                        .foregroundColor(moodColor)
                }
                
                Spacer()
                
                // Archetype tag
                if let archetype = associatedArchetype {
                    HStack(spacing: 5) {
                        Text(archetype.symbol)
                            .font(.system(size: 14))
                        Text(archetype.name)
                            .font(.caption)
                    }
                    .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
    }
    
    private var moodColor: Color {
        switch sealedRevelation.revelation.mood {
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
    
    private var moodIcon: String {
        switch sealedRevelation.revelation.mood {
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

struct SealedRevelationView: View {
    let revelation: SealedRevelation
    let associatedArchetype: Archetype?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background
            Color.black.edgesIgnoringSafeArea(.all)
            
            // Content
            ScrollView {
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
                    
                    // Revelation content
                    VStack(spacing: 20) {
                        // Page info
                        Text("Chapter \(revelation.chapter) • Page \(revelation.page)")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        // Date
                        Text(revelation.formattedDate)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        // Archetype (if present)
                        if let archetype = associatedArchetype {
                            HStack(spacing: 10) {
                                Text(archetype.symbol)
                                    .font(.system(size: 24))
                                Text(archetype.name)
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .padding(.vertical)
                        }
                        
                        // Sigil (if present)
                        if let sigil = revelation.revelation.sigil {
                            Text(sigil)
                                .font(.system(size: 24, weight: .light, design: .serif))
                                .foregroundColor(.white)
                                .padding(.vertical)
                        }
                        
                        // Revelation text
                        Text(revelation.revelation.text)
                            .font(.system(size: 20, weight: .light, design: .serif))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
            }
        }
    }
}

// MARK: - Preview

struct CodexView_Previews: PreviewProvider {
    static var previews: some View {
        let codex = Codex(storage: SecureStorage())
        return CodexView(codex: codex)
    }
} 