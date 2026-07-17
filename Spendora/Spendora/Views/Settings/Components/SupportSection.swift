//
//  SupportSection.swift
//  Spendora
//

import SwiftUI

struct SupportSection: View {
    let shareApp: () -> Void
    
    var body: some View {
        Section("Support") {
            PremiumSettingsRow(
                icon: "square.and.arrow.up",
                title: "Share App",
                subtitle: "Share Spendora with friends"
            ) {
                Button {
                    shareApp()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            PremiumSettingsRow(
                icon: "envelope.fill",
                title: "Contact Support",
                subtitle: "Help & feedback"
            ) {
                Button {
                    if let url = URL(string: "mailto:support@spendora.com") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
