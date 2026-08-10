//
//  AddSubscriptionHeaderView.swift
//

import SwiftUI


// MARK: - AddSubscriptionHeaderView

/**
 `AddSubscriptionHeaderView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for addsubscriptionheaderview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `AddSubscriptionHeaderView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct AddSubscriptionHeaderView: View {

    // MARK: - Properties


    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 44))
                .foregroundColor(SpendoraTheme.accent)
                .padding(.top, 8)
            
            Text("Add Subscription")
                .font(.system(size: 24, weight: .bold, design: .rounded))
            
            Text("Track your spending with ease")
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 12)
    }
}
