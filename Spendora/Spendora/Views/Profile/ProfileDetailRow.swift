//
//  ProfileDetailRow.swift
//

/**
 * Main/Core Functions & Purpose:
 * ProfileDetailRow reusable row component displaying account key-value details (e.g. Member Since, Storage Enclave).
 */

import SwiftUI


// MARK: - ProfileDetailRow

/**
 `ProfileDetailRow` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for profiledetailrow handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `ProfileDetailRow` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct ProfileDetailRow: View {

    // MARK: - Properties

    let icon: String  // icon property
    let title: String  // title property
    let value: String  // value property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.brandPrimary)
                .frame(width: 24)
            Text(title)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.textPrimary)
            Spacer()
            Text(value)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.textSecondary)
        }
        .padding(14)
    }
}
