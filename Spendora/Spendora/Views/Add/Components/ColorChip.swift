//
//  ColorChip.swift
//

import SwiftUI


// MARK: - ColorChip

/**
 `ColorChip` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for colorchip handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `ColorChip` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct ColorChip: View {

    // MARK: - Properties

    let color: Color  // color property
    let isSelected: Bool  // isSelected property
    let name: String  // name property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        VStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 44, height: 44)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: isSelected ? 3 : 0)
                        .shadow(color: .black.opacity(0.15), radius: 4)
                )
                .overlay(
                    Circle()
                        .stroke(color, lineWidth: isSelected ? 1 : 0)
                )
                .scaleEffect(isSelected ? 1.1 : 1.0)
            
            Text(name)
                .font(.system(.caption2, design: .rounded))
                .foregroundColor(isSelected ? .primary : .secondary)
        }
    }
}
