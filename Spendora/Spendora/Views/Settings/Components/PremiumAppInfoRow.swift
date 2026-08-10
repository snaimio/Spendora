//
//  PremiumAppInfoRow.swift
//  Spendora
//

import SwiftUI

// MARK: - PremiumAppInfoRow (Golden UX Spendora Brand Header Card)

struct PremiumAppInfoRow: View {

    var body: some View {
        HStack(spacing: 16) {
            // App icon 52x52pt 16pt radius white border 2pt
            Image("SpendoraLogo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 52, height: 52)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white, lineWidth: 2)
                )
                .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 3)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    // "SPENDORA" 22pt bold white letter-spaced
                    Text("SPENDORA")
                        .font(.system(size: 22, weight: .bold, design: .default))
                        .tracking(1.2)
                        .foregroundColor(.white)
                    
                    // "✦ CAPSTONE" coral-on-white reversed pill
                    Text("✦ CAPSTONE")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(SpendoraTheme.Colors.coral)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Color.white)
                        .clipShape(Capsule())
                }

                // "Smart Subscription & Expense Intelligence" 13pt white 80% opacity
                Text("Smart Subscription & Expense Intelligence")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Color.white.opacity(0.80))
                    .lineLimit(1)
                
                // Version "1.0 (1)" 12pt white 60% opacity
                Text("Version \(getAppVersion())")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color.white.opacity(0.60))
            }

            Spacer(minLength: 0)
        }
        .padding(SpendoraTheme.Spacing.lg)
        .background(
            SpendoraTheme.Colors.coralGradient
        )
        .clipShape(RoundedRectangle(cornerRadius: SpendoraTheme.Radius.card, style: .continuous))
        .shadow(color: SpendoraTheme.Colors.coral.opacity(0.25), radius: 14, x: 0, y: 6)
    }

    private func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}
