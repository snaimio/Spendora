//
//  SettingsUserProfileRow.swift
//  Spendora
//

import SwiftUI

// MARK: - SettingsUserProfileRow (Apple Native Profile Row)

struct SettingsUserProfileRow: View {

    // MARK: - Properties

    @ObservedObject var profileManager = UserProfileManager.shared
    let onTap: () -> Void

    // MARK: - Body

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Avatar circle 40x40pt with emerald tint background & emerald text
                ZStack {
                    Circle()
                        .fill(SpendoraTheme.accentTint)
                        .frame(width: 40, height: 40)
                    
                    Text(profileManager.profile.initials)
                        .font(.headline.weight(.semibold))
                        .foregroundColor(SpendoraTheme.accentText)
                }
                
                // Name & Account Status
                VStack(alignment: .leading, spacing: 2) {
                    Text(profileManager.profile.displayName)
                        .font(.headline)
                        .foregroundColor(Color(.label))
                    
                    HStack(spacing: 4) {
                        Image(systemName: profileManager.profile.isGuest ? "mappin.circle.fill" : profileManager.profile.provider.icon)
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                        
                        Text(profileManager.profile.isGuest ? "Guest Mode (Local)" : profileManager.profile.email)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(Color(.tertiaryLabel))
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
