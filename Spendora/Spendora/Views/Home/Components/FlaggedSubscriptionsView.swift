//
//  FlaggedSubscriptionsView.swift
//

import SwiftUI


// MARK: - FlaggedSubscriptionsView

/**
 `FlaggedSubscriptionsView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for flaggedsubscriptionsview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `FlaggedSubscriptionsView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct FlaggedSubscriptionsView: View {

    // MARK: - Properties

    let subscriptions: [Subscription]  // subscriptions property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.brandAccent)
                
                Text("Consider Cancelling")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(subscriptions.count)")
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.brandAccent)
                    .cornerRadius(8)
            }
            
            ForEach(subscriptions.prefix(3)) { sub in
                HStack {
                    Circle()
                        .fill(Color(hex: sub.colorHex ?? "#6C63FF"))
                        .frame(width: 8, height: 8)
                    
                    Text(sub.displayName)
                        .font(.system(.subheadline, design: .rounded))
                    
                    Spacer()
                    
                    Text(CurrencyManager.shared.format(sub.monthlyCost) + "/mo")
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.brandSecondary)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(Color.brandSecondary.opacity(0.08))
                .cornerRadius(8)
            }
            
            if subscriptions.count > 3 {
                Text("+ \(subscriptions.count - 3) more")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 4)
    }
}
