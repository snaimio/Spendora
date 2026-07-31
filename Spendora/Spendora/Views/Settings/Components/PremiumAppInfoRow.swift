import SwiftUI

struct PremiumAppInfoRow: View {
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                // Background Ambient Glow Ring
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [.brandPrimary.opacity(0.3), .brandSecondary.opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 66, height: 66)
                    .blur(radius: 4)

                Image("AppLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [.brandPrimary, .brandSecondary.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2.0
                            )
                    )
                    .shadow(color: Color.brandPrimary.opacity(0.35), radius: 8, x: 0, y: 4)
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text("SPENDORA")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .tracking(1.2)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.brandPrimary, .brandSecondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    HStack(spacing: 3) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 9))
                        Text("CAPSTONE")
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(
                        LinearGradient(
                            colors: [.brandPrimary, .brandSecondary],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(8)
                }

                Text("Smart Subscription & Expense Intelligence")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text("Version \(getAppVersion())")
                    .font(.system(size: 10, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary.opacity(0.8))
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 8)
    }
    
    private func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}
