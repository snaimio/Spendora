//
//  SubscriptionDetailSection.swift
//

import SwiftUI


// MARK: - SubscriptionDetailSection

/**
 `SubscriptionDetailSection` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for subscriptiondetailsection handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `SubscriptionDetailSection` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct SubscriptionDetailSection: View {

    // MARK: - Properties

    let icon: String  // icon property
    let title: String  // title property
    let value: String  // value property
    let color: Color?  // color property
    
    init(icon: String, title: String, value: String, color: Color? = nil) {
        self.icon = icon
        self.title = title
        self.value = value
        self.color = color
    }
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(color ?? .brandPrimary)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
