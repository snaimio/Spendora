//
//  CostInputField.swift
//

import SwiftUI


// MARK: - CostInputField

/**
 `CostInputField` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for costinputfield handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `CostInputField` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct CostInputField: View {

    // MARK: - Properties

    @Binding var cost: String
    let isYearly: Bool  // isYearly property
    let currencySymbol: String  // currencySymbol property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        PremiumFormField(
            icon: "dollarsign.circle.fill",
            title: isYearly ? "Yearly Cost" : "Monthly Cost"
        ) {
            HStack {
                Text(currencySymbol)
                    .foregroundColor(.secondary)
                    .font(.system(.body, design: .rounded))
                TextField("0.00", text: $cost)
                    .keyboardType(.decimalPad)
                    .font(.system(.body, design: .rounded))
            }
        }
    }
}
