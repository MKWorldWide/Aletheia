import SwiftUI

// Quantum Documentation: SoulMapView.swift
// Feature Context: UI for visualizing archetype progress and spiritual journey in Aletheia.
// Dependencies: ArchetypeEngine, Codex, SecureStorage, SwiftUI
// Usage Example: SoulMapView(codex: ..., storage: ...)
// Performance: Uses TimelineView, Canvas, and animation for dynamic effects.
// Security: No direct security implications.
// Changelog: [2024-06-10] Upgraded documentation to quantum-detailed standard.

struct SoulMapView: View {
    @StateObject private var archetypeEngine: ArchetypeEngine
    @Environment(\.dismiss) private var dismiss
    @State private var selectedArchetype: Archetype?
    @State private var showWhisper = false
    @State private var animationProgress: CGFloat = 0
    @State private var glowIntensity: CGFloat = 0
    @State private var rotationAngle: Double = 0
    @State private var particleSystem = ParticleSystem()
    @State private var resonanceAnimations: [UUID: CGFloat] = [:]
    @State private var trailParticles: [TrailParticle] = []
    @State private var nodeGlowIntensities: [UUID: CGFloat] = [:]
    
    init(codex: Codex, storage: SecureStorage) {
        _archetypeEngine = StateObject(wrappedValue: ArchetypeEngine(codex: codex, storage: storage))
    }
    
    var body: some View {
        ZStack {
            // Background
            Color.black.edgesIgnoringSafeArea(.all)
            
            // Particle effects
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    particleSystem.update(date: timeline.date)
                    particleSystem.render(in: context, size: size)
                }
            }
            
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
                    
                    Text("Soul Map")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Placeholder for symmetry
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.clear)
                }
                .padding()
                
                // Soul Map
                GeometryReader { geometry in
                    ZStack {
                        // Background grid
                        SoulMapGrid()
                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                            .rotationEffect(.degrees(rotationAngle))
                        
                        // Glowing center
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 100, height: 100)
                            .blur(radius: 20)
                            .scaleEffect(1 + glowIntensity * 0.2)
                        
                        // Connection lines with trails
                        ForEach(archetypeEngine.archetypes.filter { $0.unlocked }) { archetype in
                            if let nextArchetype = nextArchetype(after: archetype) {
                                let from = positionForArchetype(archetype, in: geometry)
                                let to = positionForArchetype(nextArchetype, in: geometry)
                                
                                ConnectionLine(
                                    from: from,
                                    to: to,
                                    progress: animationProgress
                                )
                                .stroke(
                                    LinearGradient(
                                        colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    lineWidth: 2
                                )
                                
                                // Trail particles
                                ForEach(trailParticles.filter { $0.lineId == "\(archetype.id)-\(nextArchetype.id)" }) { particle in
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [.blue.opacity(0.5), .purple.opacity(0.5)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(width: particle.size, height: particle.size)
                                        .position(particle.position)
                                        .opacity(particle.opacity)
                                }
                            }
                        }
                        
                        // Archetype nodes
                        ForEach(archetypeEngine.archetypes.filter { $0.unlocked }) { archetype in
                            ArchetypeNode(
                                archetype: archetype,
                                position: positionForArchetype(archetype, in: geometry),
                                isSelected: selectedArchetype?.id == archetype.id,
                                glowIntensity: nodeGlowIntensities[archetype.id] ?? 0
                            )
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    selectedArchetype = archetype
                                    particleSystem.emit(at: positionForArchetype(archetype, in: geometry))
                                    
                                    // Trigger resonance animations
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        resonanceAnimations[archetype.id] = 1.0
                                        nodeGlowIntensities[archetype.id] = 1.0
                                    }
                                    
                                    // Reset animations after delay
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            resonanceAnimations[archetype.id] = 0.0
                                            nodeGlowIntensities[archetype.id] = 0.0
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .padding()
                
                // Selected Archetype Info
                if let archetype = selectedArchetype {
                    VStack(spacing: 15) {
                        Text(archetype.name)
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        Text(archetype.description)
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        // Enhanced Resonance indicators
                        HStack(spacing: 20) {
                            ResonanceIndicator(
                                value: archetype.resonance.wisdom,
                                label: "Wisdom",
                                animation: resonanceAnimations[archetype.id] ?? 0
                            )
                            ResonanceIndicator(
                                value: archetype.resonance.mystery,
                                label: "Mystery",
                                animation: resonanceAnimations[archetype.id] ?? 0
                            )
                            ResonanceIndicator(
                                value: archetype.resonance.power,
                                label: "Power",
                                animation: resonanceAnimations[archetype.id] ?? 0
                            )
                        }
                        .padding(.vertical)
                        
                        Button(action: { showWhisper = true }) {
                            Text("Whisper of Alignment")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
            }
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
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0)) {
                animationProgress = 1.0
            }
            
            // Start continuous animations
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                glowIntensity = 1.0
            }
            
            withAnimation(.linear(duration: 60).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
            
            // Start emitting trail particles
            startTrailParticleEmission()
        }
    }
    
    private func positionForArchetype(_ archetype: Archetype, in geometry: GeometryProxy) -> CGPoint {
        let unlockedArchetypes = archetypeEngine.archetypes.filter { $0.unlocked }
        guard let index = unlockedArchetypes.firstIndex(where: { $0.id == archetype.id }) else {
            return .zero
        }
        
        let totalArchetypes = CGFloat(unlockedArchetypes.count)
        let angle = (2 * .pi * CGFloat(index)) / totalArchetypes
        let radius = min(geometry.size.width, geometry.size.height) * 0.35
        
        let x = geometry.size.width / 2 + radius * cos(angle)
        let y = geometry.size.height / 2 + radius * sin(angle)
        
        return CGPoint(x: x, y: y)
    }
    
    private func nextArchetype(after archetype: Archetype) -> Archetype? {
        let unlockedArchetypes = archetypeEngine.archetypes.filter { $0.unlocked }
        guard let index = unlockedArchetypes.firstIndex(where: { $0.id == archetype.id }) else {
            return nil
        }
        
        let nextIndex = (index + 1) % unlockedArchetypes.count
        return unlockedArchetypes[nextIndex]
    }
    
    private func startTrailParticleEmission() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            for archetype in archetypeEngine.archetypes.filter({ $0.unlocked }) {
                if let nextArchetype = nextArchetype(after: archetype) {
                    let lineId = "\(archetype.id)-\(nextArchetype.id)"
                    let progress = Double.random(in: 0...1)
                    
                    trailParticles.append(TrailParticle(
                        lineId: lineId,
                        progress: progress,
                        size: CGFloat.random(in: 2...4)
                    ))
                }
            }
            
            // Remove old particles
            trailParticles = trailParticles.filter { $0.age < 1.0 }
            
            // Update existing particles
            for i in trailParticles.indices {
                trailParticles[i].update()
            }
        }
    }
}

// MARK: - Supporting Views

struct ResonanceIndicator: View {
    let value: Int
    let label: String
    let animation: CGFloat
    
    var body: some View {
        VStack(spacing: 5) {
            Text("\(value)")
                .font(.title3)
                .foregroundColor(.white)
                .scaleEffect(1 + animation * 0.2)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            LinearGradient(
                                colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1 + animation
                        )
                )
        )
    }
}

struct ParticleSystem {
    var particles: [Particle] = []
    
    mutating func update(date: Date) {
        particles = particles.filter { $0.isAlive }
        particles.forEach { $0.update(date: date) }
    }
    
    mutating func emit(at position: CGPoint) {
        for _ in 0..<20 {
            particles.append(Particle(position: position))
        }
    }
    
    func render(in context: GraphicsContext, size: CGSize) {
        for particle in particles {
            let rect = CGRect(
                x: particle.position.x - particle.size/2,
                y: particle.position.y - particle.size/2,
                width: particle.size,
                height: particle.size
            )
            
            context.opacity = particle.opacity
            context.fill(
                Circle().path(in: rect),
                with: .color(particle.color)
            )
        }
    }
}

class Particle {
    var position: CGPoint
    var velocity: CGPoint
    var size: CGFloat
    var opacity: Double
    var color: Color
    var createdAt: Date
    
    init(position: CGPoint) {
        self.position = position
        self.velocity = CGPoint(
            x: Double.random(in: -50...50),
            y: Double.random(in: -50...50)
        )
        self.size = CGFloat.random(in: 2...4)
        self.opacity = 1.0
        self.color = [.blue, .purple, .cyan].randomElement()!
        self.createdAt = Date()
    }
    
    var isAlive: Bool {
        Date().timeIntervalSince(createdAt) < 1.0
    }
    
    func update(date: Date) {
        let age = date.timeIntervalSince(createdAt)
        position.x += velocity.x * 0.016
        position.y += velocity.y * 0.016
        opacity = 1.0 - age
        size *= 0.99
    }
}

struct SoulMapGrid: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Draw concentric circles
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let maxRadius = min(rect.width, rect.height) * 0.4
        
        for radius in stride(from: maxRadius, through: maxRadius / 4, by: -maxRadius / 4) {
            path.addEllipse(in: CGRect(
                x: center.x - radius,
                y: center.y - radius,
                width: radius * 2,
                height: radius * 2
            ))
        }
        
        // Draw radial lines
        for angle in stride(from: 0, through: 2 * .pi, by: .pi / 4) {
            let endPoint = CGPoint(
                x: center.x + maxRadius * cos(angle),
                y: center.y + maxRadius * sin(angle)
            )
            path.move(to: center)
            path.addLine(to: endPoint)
        }
        
        return path
    }
}

struct ArchetypeNode: View {
    let archetype: Archetype
    let position: CGPoint
    let isSelected: Bool
    let glowIntensity: CGFloat
    
    var body: some View {
        ZStack {
            // Glow effect
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.blue.opacity(0.3), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 30
                    )
                )
                .frame(width: 60, height: 60)
                .scaleEffect(1 + glowIntensity * 0.5)
                .opacity(glowIntensity)
            
            // Node content
            VStack(spacing: 5) {
                Text(archetype.symbol)
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                
                Text(archetype.name)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .frame(width: 80)
            }
            .padding(10)
            .background(
                Circle()
                    .fill(isSelected ? Color.blue.opacity(0.3) : Color.gray.opacity(0.1))
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [.blue.opacity(0.5), .purple.opacity(0.5)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
            )
        }
        .position(position)
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(), value: isSelected)
    }
}

struct ConnectionLine: Shape {
    let from: CGPoint
    let to: CGPoint
    var progress: CGFloat
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: from)
        
        let controlPoint1 = CGPoint(
            x: from.x + (to.x - from.x) * 0.5,
            y: from.y
        )
        let controlPoint2 = CGPoint(
            x: from.x + (to.x - from.x) * 0.5,
            y: to.y
        )
        
        path.addCurve(
            to: CGPoint(
                x: from.x + (to.x - from.x) * progress,
                y: from.y + (to.y - from.y) * progress
            ),
            control1: controlPoint1,
            control2: controlPoint2
        )
        
        return path
    }
}

struct TrailParticle: Identifiable {
    let id = UUID()
    let lineId: String
    var progress: Double
    var size: CGFloat
    var opacity: Double = 1.0
    var age: Double = 0.0
    
    mutating func update() {
        age += 0.016
        opacity = 1.0 - age
        size *= 0.99
    }
}

// MARK: - Preview

struct SoulMapView_Previews: PreviewProvider {
    static var previews: some View {
        let codex = Codex(storage: SecureStorage())
        return SoulMapView(codex: codex, storage: SecureStorage())
    }
} 