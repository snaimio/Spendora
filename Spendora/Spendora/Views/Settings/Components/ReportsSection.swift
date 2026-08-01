//
//  ReportsSection.swift
//

import SwiftUI


// MARK: - ReportsSection

/**
 `ReportsSection` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for reportssection handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `ReportsSection` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct ReportsSection: View {

    // MARK: - Properties

    let subscriptions: [Subscription]  // subscriptions property
    @Binding var showingYearlyReport: Bool
    @Binding var showingChallenges: Bool
    @Binding var showingSavingsScore: Bool
    @Binding var showingAIInsights: Bool
    @Binding var showingSpendingChart: Bool
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        Section("Reports") {
            PremiumSettingsRow(
                icon: "calendar",
                title: "Yearly Report",
                subtitle: "View annual spending summary"
            ) {
                Button {
                    showingYearlyReport = true
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            PremiumSettingsRow(
                icon: "trophy",
                title: "Challenges",
                subtitle: "Complete achievements"
            ) {
                Button {
                    showingChallenges = true
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            PremiumSettingsRow(
                icon: "star.circle.fill",
                title: "Savings Score",
                subtitle: "Your financial wellness"
            ) {
                Button {
                    showingSavingsScore = true
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            PremiumSettingsRow(
                icon: "brain.head.profile",
                title: "AI Insights",
                subtitle: "Smart spending analysis"
            ) {
                Button {
                    showingAIInsights = true
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            PremiumSettingsRow(
                icon: "chart.bar.fill",
                title: "Spending Chart",
                subtitle: "Visual spending breakdown"
            ) {
                Button {
                    showingSpendingChart = true
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
