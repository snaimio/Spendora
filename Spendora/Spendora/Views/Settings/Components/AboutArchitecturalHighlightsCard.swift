//
//  AboutArchitecturalHighlightsCard.swift
//

/**
 * Main/Core Functions & Purpose:
 * AboutArchitecturalHighlightsCard component displaying technical capstone architecture highlights (SwiftData, Swift Charts, UNUserNotificationCenter, PDF/CSV Export).
 */

import SwiftUI


// MARK: - AboutArchitecturalHighlightsCard

/**
 `AboutArchitecturalHighlightsCard` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for aboutarchitecturalhighlightscard handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `AboutArchitecturalHighlightsCard` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct AboutArchitecturalHighlightsCard: View {

    // MARK: - Properties


    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Core Architecture Highlights", systemImage: "cpu.fill")
                .font(.system(.headline, design: .rounded))
                .foregroundColor(.brandSecondary)
            
            Divider()
            
            VStack(spacing: 12) {
                FeatureHighlightRow(
                    icon: "externaldrive.fill",
                    title: "On-Device SwiftData Persistence",
                    subtitle: "Encrypted, private local storage without external server dependencies."
                )
                
                FeatureHighlightRow(
                    icon: "chart.line.uptrend.xyaxis.circle.fill",
                    title: "Swift Charts & Financial Analytics",
                    subtitle: "Dynamic expenditure breakdowns, yearly trends & savings score engine."
                )
                
                FeatureHighlightRow(
                    icon: "bell.badge.fill",
                    title: "Smart Notification Scheduler",
                    subtitle: "Automated UNUserNotificationCenter billing date alerts & reminders."
                )
                
                FeatureHighlightRow(
                    icon: "doc.text.fill",
                    title: "CSV & PDF Export Pipeline",
                    subtitle: "Native document generation engine for clean tax & budget exports."
                )
                
                FeatureHighlightRow(
                    icon: "square.grid.2x2.fill",
                    title: "WidgetKit Integration",
                    subtitle: "Live app group data sync powering interactive iOS Home Screen widgets."
                )
            }
        }
        .padding(18)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(20)
        .padding(.horizontal)
    }
}
