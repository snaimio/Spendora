//
//  PremiumToolbarMenu.swift
//  Spendora
//

import SwiftUI

struct PremiumToolbarMenu: View {
    let onAdd: () -> Void
    let onYearlyReport: () -> Void
    let onChallenges: () -> Void
    let onSavingsScore: () -> Void
    let onAIInsights: () -> Void
    
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
