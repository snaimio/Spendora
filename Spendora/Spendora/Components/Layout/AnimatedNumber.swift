//
//  AnimatedNumber.swift
//

import SwiftUI


// MARK: - AnimatedNumber

/**
 `AnimatedNumber` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for animatednumber handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `AnimatedNumber` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct AnimatedNumber: View {

    // MARK: - Properties

    let value: Double  // value property

    @State private var animatedValue: Double = 0


    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        Text(CurrencyManager.shared.format(animatedValue))
            .contentTransition(.numericText())
            .animation(
                .spring(response: 0.6, dampingFraction: 0.8),
                value: animatedValue
            )
            .onAppear {
                animatedValue = value
            }
            .onChange(of: value) { _, newValue in
                withAnimation {
                    animatedValue = newValue
                }
            }
    }
}
