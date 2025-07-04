import SwiftUI

// Quantum Documentation: WhisperLogView.swift
// Feature Context: UI for browsing, filtering, and burning answered whispers in Aletheia.
// Dependencies: WhisperEngine, WhisperCategory, SwiftUI
// Usage Example: WhisperLogView(whisperEngine: ...)
// Performance: Uses LazyVStack and filtering for efficient rendering.
// Security: Burn confirmation to prevent accidental data loss.
// Changelog: [2024-06-10] Upgraded documentation to quantum-detailed standard.

struct WhisperLogView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCategory: WhisperCategory?
    @State private var showingBurnConfirmation = false
    @State private var whisperToBurn: Whisper?
    
    let whisperEngine: WhisperEngine
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background
                    .ignoresSafeArea()
                
                VStack(spacing: Theme.spacing) {
                    // Category Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Theme.spacing) {
                            CategoryButton(
                                title: "All",
                                isSelected: selectedCategory == nil,
                                action: { selectedCategory = nil }
                            )
                            
                            ForEach(WhisperCategory.allCases, id: \.self) { category in
                                CategoryButton(
                                    title: category.rawValue,
                                    isSelected: selectedCategory == category,
                                    action: { selectedCategory = category }
                                )
                            }
                        }
                        .padding(.horizontal, Theme.padding)
                    }
                    .padding(.vertical, Theme.spacing)
                    
                    // Whisper List
                    ScrollView {
                        LazyVStack(spacing: Theme.spacing) {
                            ForEach(filteredWhispers) { whisper in
                                WhisperLogEntry(
                                    whisper: whisper,
                                    onBurn: {
                                        whisperToBurn = whisper
                                        showingBurnConfirmation = true
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, Theme.padding)
                    }
                }
            }
            .navigationTitle("Whisper Log")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Theme.gold)
                }
            }
        }
        .alert("Burn Whisper", isPresented: $showingBurnConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Burn", role: .destructive) {
                if let whisper = whisperToBurn {
                    whisperEngine.burnWhisper(whisper)
                }
            }
        } message: {
            Text("This whisper will be erased from memory forever. This action cannot be undone.")
        }
    }
    
    private var filteredWhispers: [Whisper] {
        if let category = selectedCategory {
            return whisperEngine.getWhispersByCategory(category)
        } else {
            return whisperEngine.answeredWhispers
        }
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Theme.bodyFont)
                .foregroundColor(isSelected ? Theme.gold : Theme.text)
                .padding(.horizontal, Theme.padding)
                .padding(.vertical, Theme.spacing / 2)
                .background(isSelected ? Theme.surface : Theme.background)
                .cornerRadius(Theme.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.cornerRadius)
                        .stroke(isSelected ? Theme.gold : Theme.gold.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

struct WhisperLogEntry: View {
    let whisper: Whisper
    let onBurn: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing) {
            // Header
            HStack {
                Text(whisper.category.rawValue)
                    .font(Theme.captionFont)
                    .foregroundColor(Theme.gold)
                
                Spacer()
                
                if let date = whisper.answeredAt {
                    Text(formatDate(date))
                        .font(Theme.captionFont)
                        .foregroundColor(Theme.text.opacity(0.7))
                }
            }
            
            // Question
            Text(whisper.question)
                .font(Theme.bodyFont)
                .foregroundColor(Theme.text)
            
            // Response
            if let response = whisper.response {
                Text(response)
                    .font(Theme.bodyFont)
                    .foregroundColor(Theme.text.opacity(0.8))
                    .padding(.top, Theme.spacing / 2)
            }
            
            // Burn Button
            Button(action: onBurn) {
                HStack {
                    Image(systemName: "flame.fill")
                    Text("Burn")
                }
                .font(Theme.captionFont)
                .foregroundColor(.red.opacity(0.7))
            }
            .padding(.top, Theme.spacing / 2)
        }
        .padding()
        .background(Theme.surface)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

extension WhisperCategory: CaseIterable {
    static var allCases: [WhisperCategory] = [
        .shadowWork,
        .revelation,
        .truth,
        .memory,
        .resistance
    ]
}

#Preview {
    WhisperLogView(whisperEngine: WhisperEngine(userProfile: UserProfile(
        name: "Seeker",
        purpose: "Truth",
        offering: "Wisdom"
    )))
} 