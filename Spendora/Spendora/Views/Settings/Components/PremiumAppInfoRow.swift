//
//  PremiumAppInfoRow.swift
//  Spendora
//

import SwiftUI

struct PremiumAppInfoRow: View {
    var body: some View {
        HStack(spacing: 14) {
            Image("AppLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 52, height: 52)
                .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [.brandPrimary.opacity(0.6), .brandSecondary.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .shadow(color: Color.brandPrimary.opacity(0.2), radius: 6, x: 0, y: 3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Spendora")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                
                Text("Version \(getAppVersion())")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Image(systemName: "sparkles")
                    .font(.system(size: 10))
                Text("PRO")
                    .font(.system(.caption2, design: .rounded))
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                LinearGradient(
                    colors: [.brandPrimary, .brandSecondary],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(8)
        }
        .padding(.vertical, 4)
    }
    
    private func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}
