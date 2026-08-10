//
//  PremiumAppInfoRow.swift
//  Spendora
//

import SwiftUI

// MARK: - PremiumAppInfoRow (Coral Fire Gradient Header Card)

struct PremiumAppInfoRow: View {

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 52, height: 52)

                Image("SpendoraLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white.opacity(0.4), lineWidth: 1.5))
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text("SPENDORA")
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .tracking(1.0)
                        .foregroundColor(.white)
                    
                    Text("PRO")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(SpendoraTheme.Colors.coral)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.white)
                        .clipShape(Capsule())
                }

                Text("Smart Subscription & Expense Intelligence")
                    .font(SpendoraTheme.Typography.caption)
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(1)
                
                Text("Version \(getAppVersion())")
                    .font(SpendoraTheme.Typography.micro)
                    .foregroundColor(.white.opacity(0.8))
            }

            Spacer(minLength: 0)
        }
        .padding(SpendoraTheme.Spacing.lg)
        .background(SpendoraTheme.Colors.coralGradient)
        .clipShape(RoundedRectangle(cornerRadius: SpendoraTheme.Radius.card, style: .continuous))
        .shadow(color: SpendoraTheme.Colors.coral.opacity(0.3), radius: 10, y: 4)
    }

    private func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "2.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}
