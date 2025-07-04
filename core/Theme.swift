import SwiftUI

/// Global theme configuration for the Aletheia app
// Quantum Documentation: Theme.swift
// Feature Context: Global theme configuration for Aletheia UI/UX.
// Dependencies: SwiftUI, Color, Font, Animation, View
// Usage Example: .background(Theme.background), .font(Theme.titleFont)
// Performance: Static properties for efficient access; minimal runtime overhead.
// Security: No direct security implications.
// Changelog: [2024-06-10] Upgraded documentation to quantum-detailed standard.
enum Theme {
    // MARK: - Colors
    
    /// Primary background color
    static let background = Color(hex: "0A0A0A")
    
    /// Surface color for cards and elevated elements
    static let surface = Color(hex: "1A1A1A")
    
    /// Primary accent color
    static let accent = Color(hex: "C0C0C0")
    
    /// Gold accent for special elements
    static let gold = Color(hex: "D4AF37")
    
    /// Primary text color
    static let text = Color(hex: "E0E0E0")
    
    /// Secondary text color
    static let textSecondary = Color(hex: "A0A0A0")
    
    /// Error color
    static let error = Color(hex: "FF6B6B")
    
    /// Success color
    static let success = Color(hex: "4ECDC4")
    
    // MARK: - Typography
    
    /// Title font for main headings
    static let titleFont = Font.custom("Baskerville", size: 32).weight(.medium)
    
    /// Body font for main text
    static let bodyFont = Font.custom("Baskerville", size: 18)
    
    /// Caption font for small text
    static let captionFont = Font.custom("Baskerville", size: 14)
    
    /// Large title font
    static let largeTitleFont = Font.custom("Baskerville", size: 40).weight(.bold)
    
    // MARK: - Animation
    
    /// Default animation duration
    static let defaultAnimation = Animation.easeInOut(duration: 0.3)
    
    /// Transition animation duration
    static let transitionAnimation = Animation.easeInOut(duration: 0.5)
    
    /// Quick animation for micro-interactions
    static let quickAnimation = Animation.easeInOut(duration: 0.15)
    
    // MARK: - Layout
    
    /// Standard corner radius
    static let cornerRadius: CGFloat = 12
    
    /// Large corner radius for cards
    static let largeCornerRadius: CGFloat = 20
    
    /// Standard padding
    static let padding: CGFloat = 20
    
    /// Small padding
    static let smallPadding: CGFloat = 12
    
    /// Standard spacing between elements
    static let spacing: CGFloat = 16
    
    /// Large spacing for sections
    static let largeSpacing: CGFloat = 32
}

// MARK: - Color Extension

extension Color {
    /// Initialize a color from a hex string
    /// - Parameter hex: Hex color string (e.g., "FF0000" or "#FF0000")
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - View Modifiers

extension View {
    /// Apply the standard card styling
    func cardStyle() -> some View {
        self
            .background(Theme.surface)
            .cornerRadius(Theme.cornerRadius)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    /// Apply the cosmic gradient background
    func cosmicBackground() -> some View {
        self.background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Theme.background,
                    Color(hex: "1A1A2E"),
                    Theme.background
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
} 