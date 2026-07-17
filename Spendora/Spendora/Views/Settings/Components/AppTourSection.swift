//
//  AppTourSection.swift
//  Spendora
//

import SwiftUI

struct AppTourSection: View {
    @Binding var showingOnboarding: Bool
    
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
