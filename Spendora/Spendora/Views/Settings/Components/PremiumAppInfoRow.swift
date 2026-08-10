//
//  PremiumAppInfoRow.swift
//  Spendora
//

import SwiftUI

// MARK: - PremiumAppInfoRow (Obsidian Indigo Executive Branding Card)

struct PremiumAppInfoRow: View {

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                // Ambient Glow Container (52x52)
                RoundedRectangle(cornerRadius: AppStyles.Radius.medium, style: .continuous)
                    .fill(Color.brandPrimary.opacity(0.12))
                    .frame(width: 56, height: 56)

                Image("SpendoraLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.brandPrimary.opacity(0.4), lineWidth: 1.5)
                    )
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text("SPENDORA")
                        .font(.system(size: 17, weight: .bold, design: .default))
                        .tracking(1.0)
                        .foregroundColor(.textPrimary)
                    
                    Text("PRO")
                        .font(AppStyles.Typography.label)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.brandPrimary)
                        .clipShape(Capsule())
                }

                Text("Subscription & Expense Intelligence")
                    .font(AppStyles.Typography.caption)
                    .foregroundColor(.textSecondary)
                    .lineLimit(1)
                
                Text("Version \(getAppVersion())")
                    .font(AppStyles.Typography.label)
                    .foregroundColor(.textTertiary)
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 6)
    }

    private func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "2.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}
