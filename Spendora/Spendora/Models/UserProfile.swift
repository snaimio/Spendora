//
//  UserProfile.swift
//

import Foundation
import SwiftUI

/// Represents the authentication provider used for local profile personalization.
/// Since Spendora is 100% offline and privacy-focused, authentication states are saved locally.
enum AuthProvider: String, Codable, CaseIterable {

    // MARK: - Properties

    case guest = "Guest"
    case email = "Email"
    case apple = "Apple"
    case google = "Google"

    var displayName: String { rawValue }  // displayName property

    /// SF Symbol or brand icon associated with each authentication option
    var icon: String {  // icon property
        switch self {
        case .guest: return "person.crop.circle"
        case .email: return "envelope.fill"
        case .apple: return "apple.logo"
        case .google: return "g.circle.fill"
        }
    }

    /// Color coding for the status badge rendered on the Profile header
    var badgeColor: Color {  // badgeColor property
        switch self {
        case .guest: return .secondary
        case .email: return Color(hex: "#4ECDC4")
        case .apple: return .primary
        case .google: return Color(hex: "#4285F4")
        }
    }
}

/**
 UserProfile data model containing the active user's identity details.
 Implements Codable so profile settings persist seamlessly in local UserDefaults.
*/

// MARK: - UserProfile

/**
 `UserProfile` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for userprofile handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `UserProfile` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct UserProfile: Codable, Equatable {

    // MARK: - Properties

    var displayName: String  // displayName property
    var email: String  // email property
    var provider: AuthProvider  // provider property
    var isGuest: Bool  // isGuest property
    var joinedDate: Date  // joinedDate property
    var avatarColorHex: String  // avatarColorHex property

    /// Default guest profile initialized when the app is installed or when the user signs out
    static var defaultGuest: UserProfile {
        UserProfile(
            displayName: "Guest User",
            email: "guest@spendora.local",
            provider: .guest,
            isGuest: true,
            joinedDate: Date(),
            avatarColorHex: "#FF6B6B"
        )
    }

    /// Computes up to two initials from the display name to render inside the avatar gradient circle
    var initials: String {  // initials property
        if isGuest { return "GU" }
        let components = displayName.components(separatedBy: " ").filter { !$0.isEmpty }
        if components.count >= 2 {
            let first = components[0].prefix(1)
            let last = components[1].prefix(1)
            return "\(first)\(last)".uppercased()
        } else if let first = components.first?.prefix(2) {
            return String(first).uppercased()
        }
        return "SP"
    }
}
