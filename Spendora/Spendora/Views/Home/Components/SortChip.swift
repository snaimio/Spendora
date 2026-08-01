//
//  SortChip.swift
//

import SwiftUI


// MARK: - SortChip

/**
 `SortChip` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for sortchip handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `SortChip` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct SortChip: View {

    // MARK: - Properties

    let title: String  // title property
    let isSelected: Bool  // isSelected property
    let action: () -> Void  // action property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.system(.caption, design: .rounded))
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.brandPrimary : Color(.secondarySystemBackground))
                )
                .foregroundColor(isSelected ? .white : .secondary)
        }
        .buttonStyle(.plain)
    }
}
