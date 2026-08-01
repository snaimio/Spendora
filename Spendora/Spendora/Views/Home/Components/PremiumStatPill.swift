//
//  PremiumStatPill.swift
//

import SwiftUI


// MARK: - PremiumStatPill

/**
 `PremiumStatPill` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for premiumstatpill handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `PremiumStatPill` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct PremiumStatPill: View {

    // MARK: - Properties

    let icon: String  // icon property
    let label: String  // label property
    let value: String  // value property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.brandPrimary)
            
            Text(label)
                .font(.system(size: 10, design: .rounded))
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.system(size: 11, design: .rounded).monospacedDigit())
                .fontWeight(.semibold)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
        .fixedSize(horizontal: false, vertical: true)
    }
}
