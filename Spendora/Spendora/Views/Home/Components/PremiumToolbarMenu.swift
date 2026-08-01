//
//  PremiumToolbarMenu.swift
//

import SwiftUI


// MARK: - PremiumToolbarMenu

/**
 `PremiumToolbarMenu` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for premiumtoolbarmenu handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `PremiumToolbarMenu` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct PremiumToolbarMenu: View {

    // MARK: - Properties

    let onAdd: () -> Void  // onAdd property
    let onYearlyReport: () -> Void  // onYearlyReport property
    let onChallenges: () -> Void  // onChallenges property
    let onSavingsScore: () -> Void  // onSavingsScore property
    let onAIInsights: () -> Void  // onAIInsights property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        Menu {
            Button {
                onAdd()
            } label: {
                Label("Add Subscription", systemImage: "plus")
            }
            
            Divider()
            
            Button {
                onYearlyReport()
            } label: {
                Label("Yearly Report", systemImage: "calendar")
            }
            
            Button {
                onChallenges()
            } label: {
                Label("Challenges", systemImage: "trophy")
            }
            
            Button {
                onSavingsScore()
            } label: {
                Label("Savings Score", systemImage: "star.circle.fill")
            }
            
            Button {
                onAIInsights()
            } label: {
                Label("AI Insights", systemImage: "brain.head.profile")
            }
        } label: {
            Image(systemName: "ellipsis.circle.fill")
                .font(.title2)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.brandPrimary, .brandSecondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
    }
}
