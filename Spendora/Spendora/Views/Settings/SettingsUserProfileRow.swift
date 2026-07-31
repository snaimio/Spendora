//
//  SettingsUserProfileRow.swift
//  Spendora
//
//  Capstone 2026 - Mobile Application Development
//  Author: Sheikh Naim
//

/**
 * Main/Core Functions & Purpose:
 * SettingsUserProfileRow component displaying current user avatar, email, and authentication badge.
 */

import SwiftUI

struct SettingsUserProfileRow: View {
    @ObservedObject var profileManager = UserProfileManager.shared
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: profileManager.profile.avatarColorHex),
                                    Color(hex: profileManager.profile.avatarColorHex).opacity(0.6)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                    
                    Text(profileManager.profile.initials)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(profileManager.profile.displayName)
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.textPrimary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: profileManager.profile.provider.icon)
                            .font(.caption2)
                        Text(profileManager.profile.isGuest ? "Guest Mode (Local)" : profileManager.profile.email)
                            .font(.system(.caption, design: .rounded))
                    }
                    .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
