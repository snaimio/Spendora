//
//  AddColorSelectionView.swift
//

import SwiftUI


// MARK: - AddColorSelectionView

/**
 `AddColorSelectionView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for addcolorselectionview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `AddColorSelectionView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct AddColorSelectionView: View {

    // MARK: - Properties

    let colorOptions: [(name: String, hex: String)]  // colorOptions property
    @Binding var selectedColorHex: String
    let generator: UIImpactFeedbackGenerator  // generator property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose a Color")
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(colorOptions, id: \.hex) { color in
                        ColorChip(
                            color: Color(hex: color.hex),
                            isSelected: selectedColorHex == color.hex,
                            name: color.name
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                selectedColorHex = color.hex
                                generator.impactOccurred()
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}
