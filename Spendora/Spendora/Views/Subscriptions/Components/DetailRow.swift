//
//  DetailRow.swift
//

/**
 * Main/Core Functions & Purpose:
 * DetailRow reusable component displaying key-value rows with an SF Symbol icon.
 */

import SwiftUI


// MARK: - DetailRow

/**
 `DetailRow` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for detailrow handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `DetailRow` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct DetailRow: View {

    // MARK: - Properties

    let icon: String  // icon property
    let title: String  // title property
    let value: String  // value property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(.brandPrimary)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.textSecondary)
                Text(value)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(.textPrimary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
