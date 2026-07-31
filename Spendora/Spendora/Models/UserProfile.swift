//
//  UserProfile.swift
//  Spendora
//
//  Capstone 2026 - Mobile Application Development
//  Author: Sheikh Naim
//

import Foundation
import SwiftUI

/// Represents the authentication provider used for local profile personalization.
/// Since Spendora is 100% offline and privacy-focused, authentication states are saved locally.
enum AuthProvider: String, Codable, CaseIterable {
    case guest = "Guest"
    case email = "Email"
    case apple = "Apple"
    case google = "Google"

    var displayName: String { rawValue }

    /// SF Symbol or brand icon associated with each authentication option
    var icon: String {
        switch self {
        case .guest: return "person.crop.circle"
        case .email: return "envelope.fill"
        case .apple: return "apple.logo"
        case .google: return "g.circle.fill"
        }
    }

    /// Color coding for the status badge rendered on the Profile header
    var badgeColor: Color {
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
struct UserProfile: Codable, Equatable {
    var displayName: String
    var email: String
    var provider: AuthProvider
    var isGuest: Bool
    var joinedDate: Date
    var avatarColorHex: String

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
    var initials: String {
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
