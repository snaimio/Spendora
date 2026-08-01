//
//  PrivacyGuaranteeCardView.swift
//

/**
 * Main/Core Functions & Purpose:
 * PrivacyGuaranteeCardView renders the 100% On-Device Privacy shield card on the Profile screen.
 */

import SwiftUI


// MARK: - PrivacyGuaranteeCardView

/**
 `PrivacyGuaranteeCardView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for privacyguaranteecardview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `PrivacyGuaranteeCardView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct PrivacyGuaranteeCardView: View {

    // MARK: - Properties


    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color(hex: "#4ECDC4").opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: "lock.shield.fill")
                    .font(.title3)
                    .foregroundColor(Color(hex: "#4ECDC4"))
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text("100% On-Device Privacy")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)
                
                Text("Your profile and subscription records stay strictly on your local iPhone. No external cloud servers.")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(.textSecondary)
                    .lineSpacing(2)
            }
        }
        .padding(14)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
    }
}
