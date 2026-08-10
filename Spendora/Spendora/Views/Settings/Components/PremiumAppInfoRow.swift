//
//  PremiumAppInfoRow.swift
//  Spendora
//

import SwiftUI

// MARK: - PremiumAppInfoRow (Apple Native Brand Card)

struct PremiumAppInfoRow: View {

    var body: some View {
        HStack(spacing: 16) {
            // App Icon 52x52pt (12pt radius)
            Image("SpendoraLogo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 52, height: 52)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 8) {
                    Text("Spendora")
                        .font(.title2.weight(.bold))
                        .foregroundColor(Color(.label))
                    
                    Text("✦ CAPSTONE")
                        .font(.caption2.weight(.bold))
                        .foregroundColor(SpendoraTheme.accent)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(SpendoraTheme.accentTint)
                        .clipShape(Capsule())
                }

                Text("Smart Subscription & Expense Intelligence")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text("Version \(getAppVersion())")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer(minLength: 0)
        }
        .padding(SpendoraTheme.cardPadding)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous))
    }

    private func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}
