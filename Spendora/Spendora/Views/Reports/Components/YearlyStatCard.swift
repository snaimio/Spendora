//
//  YearlyStatCard.swift
//

import SwiftUI


// MARK: - YearlyStatCard

/**
 `YearlyStatCard` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for yearlystatcard handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `YearlyStatCard` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct YearlyStatCard: View {

    // MARK: - Properties

    let title: String  // title property
    let value: String  // value property
    let icon: String  // icon property
    let color: Color  // color property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.headline)
                    .fontWeight(.bold)
            }
            Spacer()
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 5)
    }
}
