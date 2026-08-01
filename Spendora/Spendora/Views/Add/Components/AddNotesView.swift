//
//  AddNotesView.swift
//

import SwiftUI


// MARK: - AddNotesView

/**
 `AddNotesView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for addnotesview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `AddNotesView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct AddNotesView: View {

    // MARK: - Properties

    @Binding var notes: String
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notes (Optional)")
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
            
            TextField("Add notes...", text: $notes, axis: .vertical)
                .font(.system(.body, design: .rounded))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
                .padding(.horizontal, 16)
                .lineLimit(3...6)
        }
    }
}
