//
//  SettingsUserProfileRow.swift
//

/**
 * Main/Core Functions & Purpose:
 * SettingsUserProfileRow component displaying current user avatar, email, and authentication badge.
 */

import SwiftUI


// MARK: - SettingsUserProfileRow

/**
 `SettingsUserProfileRow` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for settingsuserprofilerow handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `SettingsUserProfileRow` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct SettingsUserProfileRow: View {

    // MARK: - Properties

    @ObservedObject var profileManager = UserProfileManager.shared
    let onTap: () -> Void  // onTap property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
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
