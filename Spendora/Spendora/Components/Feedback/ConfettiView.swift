//
//  ConfettiView.swift
//

import SwiftUI


// MARK: - ConfettiView

/**
 `ConfettiView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for confettiview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `ConfettiView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct ConfettiView: View {

    // MARK: - Properties

    @State private var animate = false
    let onComplete: () -> Void  // onComplete property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        ZStack {
            // Premium gradient background for confetti celebration
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color(.systemBackground).opacity(0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ForEach(0..<120, id: \.self) { i in
                ConfettiPiece(
                    index: i,
                    animate: animate
                )
            }
        }
        .onAppear {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
            withAnimation(.easeOut(duration: 2.0)) {
                animate = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.5)) {
                    onComplete()
                }
            }
        }
    }
}
