//
//  ProfileHeaderCardView.swift
//

/**
 * Main/Core Functions & Purpose:
 * ProfileHeaderCardView displays the user's avatar circle, display name, email, and authentication provider status badge.
 */

import SwiftUI


// MARK: - ProfileHeaderCardView

/**
 `ProfileHeaderCardView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for profileheadercardview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `ProfileHeaderCardView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct ProfileHeaderCardView: View {

    // MARK: - Properties

    @ObservedObject var profileManager = UserProfileManager.shared
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        VStack(spacing: 12) {
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
                    .frame(width: 80, height: 80)
                    .shadow(color: Color(hex: profileManager.profile.avatarColorHex).opacity(0.3), radius: 10, x: 0, y: 4)
                
                Text(profileManager.profile.initials)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 4) {
                Text(profileManager.profile.displayName)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)
                
                Text(profileManager.profile.email)
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(.textSecondary)
            }
            
            HStack(spacing: 6) {
                Image(systemName: profileManager.profile.provider.icon)
                    .font(.caption2)
                Text(profileManager.profile.isGuest ? "Guest Mode" : "\(profileManager.profile.provider.displayName) Account")
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(profileManager.profile.provider.badgeColor.opacity(0.15))
            .foregroundColor(profileManager.profile.provider.badgeColor)
            .cornerRadius(20)
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(Color.cardBackground)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 2)
    }
}
