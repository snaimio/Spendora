//
//  SettingsUserProfileRow.swift
//  Spendora
//

import SwiftUI

// MARK: - SettingsUserProfileRow (Golden UX Profile Header)

struct SettingsUserProfileRow: View {

    // MARK: - Properties

    @ObservedObject var profileManager = UserProfileManager.shared
    let onTap: () -> Void

    // MARK: - Body

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                // Avatar circle 44x44pt coral gradient background white initials 17pt semibold
                ZStack {
                    Circle()
                        .fill(SpendoraTheme.Colors.coralGradient)
                        .frame(width: 44, height: 44)
                        .shadow(color: SpendoraTheme.Colors.coral.opacity(0.25), radius: 6, y: 2)
                    
                    Text(profileManager.profile.initials)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                // Name 16pt semibold charcoal & status 13pt secondary
                VStack(alignment: .leading, spacing: 2) {
                    Text(profileManager.profile.displayName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(SpendoraTheme.Colors.textPrimary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: profileManager.profile.isGuest ? "mappin.circle.fill" : profileManager.profile.provider.icon)
                            .font(.system(size: 12))
                            .foregroundColor(SpendoraTheme.Colors.coralWarm)
                        
                        Text(profileManager.profile.isGuest ? "Guest Mode (Local)" : profileManager.profile.email)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(SpendoraTheme.Colors.textSecondary)
                    }
                }
                
                Spacer()
                
                // Chevron coral tint #FFB3A7
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(SpendoraTheme.Colors.chevron)
            }
            .frame(minHeight: 64)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
