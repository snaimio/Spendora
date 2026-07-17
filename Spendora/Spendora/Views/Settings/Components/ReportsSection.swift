//
//  ReportsSection.swift
//  Spendora
//

import SwiftUI

struct ReportsSection: View {
    let subscriptions: [Subscription]
    @Binding var showingYearlyReport: Bool
    @Binding var showingChallenges: Bool
    @Binding var showingSavingsScore: Bool
    @Binding var showingAIInsights: Bool
    @Binding var showingSpendingChart: Bool
    
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
