//
//  AddSubscriptionSaveButton.swift
//

import SwiftUI


// MARK: - AddSubscriptionSaveButton

/**
 `AddSubscriptionSaveButton` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for addsubscriptionsavebutton handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `AddSubscriptionSaveButton` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct AddSubscriptionSaveButton: View {

    // MARK: - Properties

    let isValid: Bool  // isValid property
    let isSaving: Bool  // isSaving property
    let action: () -> Void  // action property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                if isSaving {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Add Subscription")
                        .font(.system(.headline, design: .rounded))
                    Image(systemName: "arrow.right.circle.fill")
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: isValid ? [Color(hex: "#6366F1"), Color(hex: "#8B5CF6")] : [.gray.opacity(0.4), .gray.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(18)
            .shadow(color: isValid ? Color(hex: "#6366F1").opacity(0.35) : .clear, radius: 14, x: 0, y: 6)
        }
        .disabled(!isValid || isSaving)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}
