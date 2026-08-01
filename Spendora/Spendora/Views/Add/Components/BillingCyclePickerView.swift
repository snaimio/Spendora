//
//  BillingCyclePickerView.swift
//

import SwiftUI


// MARK: - BillingCyclePickerView

/**
 `BillingCyclePickerView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for billingcyclepickerview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `BillingCyclePickerView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct BillingCyclePickerView: View {

    // MARK: - Properties

    @Binding var isYearly: Bool
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        PremiumFormField(
            icon: "repeat.circle.fill",
            title: "Billing Cycle"
        ) {
            Picker("", selection: $isYearly) {
                Text("Monthly").tag(false)
                Text("Yearly").tag(true)
            }
            .pickerStyle(.segmented)
            .tint(.brandPrimary)
            .frame(maxWidth: 200)
        }
    }
}
