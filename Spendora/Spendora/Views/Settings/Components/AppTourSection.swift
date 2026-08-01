//
//  AppTourSection.swift
//

import SwiftUI


// MARK: - AppTourSection

/**
 `AppTourSection` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for apptoursection handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `AppTourSection` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct AppTourSection: View {

    // MARK: - Properties

    @Binding var showingOnboarding: Bool
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        Section("App") {
            PremiumSettingsRow(
                icon: "book.fill",
                title: "Show Onboarding Tour",
                subtitle: "Replay the welcome experience"
            ) {
                Button {
                    showingOnboarding = true
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
