//
//  LegalSection.swift
//

import SwiftUI


// MARK: - LegalSection

/**
 `LegalSection` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for legalsection handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `LegalSection` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct LegalSection: View {

    // MARK: - Properties

    @Binding var showingPrivacyPolicy: Bool
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        Section("Legal") {
            PremiumSettingsRow(
                icon: "lock.doc.fill",
                title: "Privacy Policy",
                subtitle: "How we protect your data"
            ) {
                Button {
                    showingPrivacyPolicy = true
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            PremiumSettingsRow(
                icon: "info.circle.fill",
                title: "Version",
                subtitle: getAppVersion()
            ) {
                EmptyView()
            }
        }
    }
    

    /**
     Executes `getAppVersion` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    private func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}
