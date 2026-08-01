//
//  AnimatedGradientBackground.swift
//

import SwiftUI


// MARK: - AnimatedGradientBackground

/**
 `AnimatedGradientBackground` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for animatedgradientbackground handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `AnimatedGradientBackground` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct AnimatedGradientBackground: View {

    // MARK: - Properties

    @State private var animate = false
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        ZStack {
            // Primary animated gradient
            LinearGradient(
                colors: [
                    Color.brandPrimary.opacity(animate ? 0.12 : 0.05),
                    Color.brandSecondary.opacity(animate ? 0.05 : 0.12),
                    Color.brandAccent.opacity(animate ? 0.03 : 0.06)
                ],
                startPoint: animate ? .topLeading : .bottomTrailing,
                endPoint: animate ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .animation(
                .easeInOut(duration: 6)
                    .repeatForever(autoreverses: true),
                value: animate
            )
            
            // Secondary subtle pattern overlay
            RadialGradient(
                colors: [
                    Color.brandPrimary.opacity(0.03),
                    Color.clear
                ],
                center: animate ? .topTrailing : .bottomLeading,
                startRadius: 0,
                endRadius: 400
            )
            .ignoresSafeArea()
            .animation(
                .easeInOut(duration: 8)
                    .repeatForever(autoreverses: true),
                value: animate
            )
        }
        .onAppear {
            animate = true
        }
    }
}
