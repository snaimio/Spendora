/**
 * Main/Core Functions & Purpose:
 * DashboardBrandHeaderView header component displayed at top of main Home screen.
 * Displays Spendora logo with gradient ambient glow, PRO badge, tagline, and user profile avatar button.
 */

import SwiftUI

struct DashboardBrandHeaderView: View {
    @ObservedObject var profileManager = UserProfileManager.shared
    let onProfileTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                // Background Ambient Glow Ring
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [.brandPrimary.opacity(0.3), .brandSecondary.opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 46, height: 46)
                    .blur(radius: 3)
                
                Image("AppLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 42, height: 42)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [.brandPrimary, .brandSecondary],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(color: Color.brandPrimary.opacity(0.3), radius: 6, x: 0, y: 3)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text("Spendora")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.textPrimary)
                    
                    Text("PRO")
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            LinearGradient(
                                colors: [.brandPrimary, .brandSecondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(6)
                }
                
                Text("Subscription & Expense Intelligence")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            // User Profile Avatar Button
            Button(action: onProfileTap) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: profileManager.profile.avatarColorHex),
                                    Color(hex: profileManager.profile.avatarColorHex).opacity(0.7)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 38, height: 38)
                    
                    Text(profileManager.profile.initials)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .shadow(color: Color.black.opacity(0.12), radius: 5, x: 0, y: 2)
            }
        }
        .padding(.vertical, 4)
    }
}
