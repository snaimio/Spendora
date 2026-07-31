//
//  UserProfile.swift
//  Spendora
//

import Foundation
import SwiftUI

enum AuthProvider: String, Codable, CaseIterable {
    case guest = "Guest"
    case email = "Email"
    case apple = "Apple"
    case google = "Google"

    var displayName: String { rawValue }

    var icon: String {
        switch self {
        case .guest: return "person.crop.circle"
        case .email: return "envelope.fill"
        case .apple: return "apple.logo"
        case .google: return "g.circle.fill"
        }
    }

    var badgeColor: Color {
        switch self {
        case .guest: return .secondary
        case .email: return Color(hex: "#4ECDC4")
        case .apple: return .primary
        case .google: return Color(hex: "#4285F4")
        }
    }
}

struct UserProfile: Codable, Equatable {
    var displayName: String
    var email: String
    var provider: AuthProvider
    var isGuest: Bool
    var joinedDate: Date
    var avatarColorHex: String

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
