import SwiftUI

// Quantum Documentation: ArchetypeView.swift
// Feature Context: UI for displaying and interacting with spiritual archetypes in Aletheia.
// Dependencies: Codex, SecureStorage, Archetype, SwiftUI
// Usage Example: ArchetypeView(codex: ..., storage: ...)
// Performance: Uses SwiftUI sheets and dynamic lists for archetype display.
// Security: No direct security implications.
// Changelog: [2024-06-10] Upgraded documentation to quantum-detailed standard.

struct ArchetypeView: View {
    @StateObject private var archetypeEngine: ArchetypeEngine
    @Environment(\.dismiss) private var dismiss
    @State private var selectedArchetype: Archetype?
    @State private var showWhisper = false
    
    init(codex: Codex, storage: SecureStorage) {
        _archetypeEngine = StateObject(wrappedValue: ArchetypeEngine(codex: codex, storage: storage))
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
                    
                    Text("Awakened Archetypes")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Placeholder for symmetry
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.clear)
                }
                .padding()
                
                // Archetype Grid
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 20) {
                        ForEach(archetypeEngine.archetypes.filter { $0.unlocked }) { archetype in
                            ArchetypeCard(archetype: archetype)
                                .onTapGesture {
                                    selectedArchetype = archetype
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(item: $selectedArchetype) { archetype in
            ArchetypeDetailView(
                archetype: archetype,
                onGenerateWhisper: {
                    showWhisper = true
                }
            )
        }
        .sheet(isPresented: $showWhisper) {
            if let archetype = selectedArchetype {
                WhisperView(
                    whisperEngine: WhisperEngine(
                        userProfile: UserProfile(),
                        initialWhisper: archetypeEngine.generateAlignedWhisper(for: archetype)
                    ),
                    userProfile: UserProfile()
                )
            }
        }
    }
}

// MARK: - Supporting Views

struct ArchetypeCard: View {
    let archetype: Archetype
    
    var body: some View {
        VStack(spacing: 15) {
            // Symbol
            Text(archetype.symbol)
                .font(.system(size: 40))
                .foregroundColor(.white)
            
            // Name
            Text(archetype.name)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            // Resonance
            HStack(spacing: 15) {
                ResonanceIndicator(value: archetype.resonance.wisdom, icon: "brain")
                ResonanceIndicator(value: archetype.resonance.mystery, icon: "sparkles")
                ResonanceIndicator(value: archetype.resonance.power, icon: "bolt")
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
    }
}

struct ResonanceIndicator: View {
    let value: Int
    let icon: String
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text("\(value)")
                .font(.caption)
                .foregroundColor(.white)
        }
    }
}

struct ArchetypeDetailView: View {
    let archetype: Archetype
    let onGenerateWhisper: () -> Void
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
                    
                    // Symbol
                    Text(archetype.symbol)
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                    
                    // Name
                    Text(archetype.name)
                        .font(.title)
                        .foregroundColor(.white)
                    
                    // Description
                    Text(archetype.description)
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Resonance
                    VStack(spacing: 15) {
                        Text("Resonance")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 30) {
                            ResonanceDetail(value: archetype.resonance.wisdom, label: "Wisdom", icon: "brain")
                            ResonanceDetail(value: archetype.resonance.mystery, label: "Mystery", icon: "sparkles")
                            ResonanceDetail(value: archetype.resonance.power, label: "Power", icon: "bolt")
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    // Whisper Button
                    Button(action: onGenerateWhisper) {
                        Text("Whisper of Alignment")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct ResonanceDetail: View {
    let value: Int
    let label: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.gray)
            
            Text("\(value)")
                .font(.title2)
                .foregroundColor(.white)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Preview

struct ArchetypeView_Previews: PreviewProvider {
    static var previews: some View {
        let codex = Codex(storage: SecureStorage())
        return ArchetypeView(codex: codex, storage: SecureStorage())
    }
} 