//
//  PremiumAppInfoRow.swift
//  Spendora
//

import SwiftUI

// MARK: - PremiumAppInfoRow (Apple Native Brand Card)

struct PremiumAppInfoRow: View {

    var body: some View {
        HStack(spacing: 16) {
            // App Icon 56x56pt (13pt radius with white contrast backing)
            Image("SpendoraLogo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                )

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
