//
//  LegalSection.swift
//  Spendora
//

import SwiftUI

struct LegalSection: View {
    @Binding var showingPrivacyPolicy: Bool
    
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
    
    private func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}
