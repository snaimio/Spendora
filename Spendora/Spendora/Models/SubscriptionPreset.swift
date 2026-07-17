//
//  SubscriptionPreset.swift
//  Spendora
//

import Foundation
import SwiftUI

struct SubscriptionPreset: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let category: String
    let cancellationUrl: String?

    var systemIcon: String {
        switch icon {
        case "netflix": return "tv.fill"
        case "spotify": return "music.note"
        case "apple.music": return "music.note.list"
        case "disney": return "star.fill"
        case "hulu": return "play.circle.fill"
        case "youtube": return "play.rectangle.fill"
        case "hbo": return "film.fill"
        case "prime": return "shippingbox.fill"
        case "microsoft": return "building.columns.fill"
        case "google": return "globe"
        case "dropbox": return "folder.fill"
        case "notion": return "rectangle.inset.checked"
        case "fitbit": return "heart.circle.fill"
        case "fitness": return "figure.walk"
        case "amazon": return "cart.fill"
        case "hellofresh": return "leaf.fill"
        case "adobe": return "pencil.circle.fill"
        case "playstation": return "gamecontroller.fill"
        case "xbox": return "gamecontroller.fill"
        default: return "creditcard.fill"
        }
    }
}

extension SubscriptionPreset {

    static let all: [SubscriptionPreset] = [

        // MARK: - Entertainment

        .init(
            name: "Netflix",
            icon: "netflix",
            color: Color(hex: "#E50914"),
            category: "Entertainment",
            cancellationUrl: "https://www.netflix.com/cancelplan"
        ),

        .init(
            name: "Spotify",
            icon: "spotify",
            color: Color(hex: "#1DB954"),
            category: "Entertainment",
            cancellationUrl: "https://www.spotify.com/account/cancel/"
        ),

        .init(
            name: "Apple Music",
            icon: "apple.music",
            color: Color(hex: "#FC3C44"),
            category: "Entertainment",
            cancellationUrl: "https://appleid.apple.com/account/manage"
        ),

        .init(
            name: "Disney+",
            icon: "disney",
            color: Color(hex: "#113CCF"),
            category: "Entertainment",
            cancellationUrl: "https://www.disneyplus.com/subscription"
        ),

        .init(
            name: "Hulu",
            icon: "hulu",
            color: Color(hex: "#1CE783"),
            category: "Entertainment",
            cancellationUrl: "https://help.hulu.com/account/cancel"
        ),

        .init(
            name: "YouTube Premium",
            icon: "youtube",
            color: Color(hex: "#FF0000"),
            category: "Entertainment",
            cancellationUrl: "https://www.youtube.com/paid_memberships"
        ),

        .init(
            name: "HBO Max",
            icon: "hbo",
            color: Color(hex: "#5822B4"),
            category: "Entertainment",
            cancellationUrl: "https://www.max.com/account"
        ),

        .init(
            name: "Prime Video",
            icon: "prime",
            color: Color(hex: "#00A8E1"),
            category: "Entertainment",
            cancellationUrl: "https://www.amazon.com/gp/css/account/manageprime"
        ),

        // MARK: - Productivity

        .init(
            name: "Microsoft 365",
            icon: "microsoft",
            color: Color(hex: "#F25022"),
            category: "Productivity",
            cancellationUrl: "https://account.microsoft.com/services"
        ),

        .init(
            name: "Google Workspace",
            icon: "google",
            color: Color(hex: "#4285F4"),
            category: "Productivity",
            cancellationUrl: "https://admin.google.com"
        ),

        .init(
            name: "Dropbox",
            icon: "dropbox",
            color: Color(hex: "#0061FF"),
            category: "Productivity",
            cancellationUrl: "https://www.dropbox.com/account/plan"
        ),

        .init(
            name: "Notion",
            icon: "notion",
            color: Color(hex: "#000000"),
            category: "Productivity",
            cancellationUrl: "https://www.notion.so/settings/plans"
        ),

        // MARK: - Health & Fitness

        .init(
            name: "Fitbit Premium",
            icon: "fitbit",
            color: Color(hex: "#00B0B9"),
            category: "Health & Fitness",
            cancellationUrl: "https://www.fitbit.com/settings/subscription"
        ),

        .init(
            name: "MyFitnessPal",
            icon: "fitness",
            color: Color(hex: "#CC3345"),
            category: "Health & Fitness",
            cancellationUrl: "https://www.myfitnesspal.com/account/subscription"
        ),

        // MARK: - Shopping

        .init(
            name: "Amazon Prime",
            icon: "amazon",
            color: Color(hex: "#FF9900"),
            category: "Shopping",
            cancellationUrl: "https://www.amazon.com/gp/css/account/manageprime"
        ),

        // MARK: - Food & Dining

        .init(
            name: "HelloFresh",
            icon: "hellofresh",
            color: Color(hex: "#43B02A"),
            category: "Food & Dining",
            cancellationUrl: "https://www.hellofresh.com/account/cancel"
        ),

        // MARK: - Other

        .init(
            name: "Adobe Creative Cloud",
            icon: "adobe",
            color: Color(hex: "#FF0000"),
            category: "Other",
            cancellationUrl: "https://account.adobe.com/plans"
        ),

        .init(
            name: "PlayStation Plus",
            icon: "playstation",
            color: Color(hex: "#0070D1"),
            category: "Other",
            cancellationUrl: "https://www.playstation.com/account"
        ),

        .init(
            name: "Xbox Game Pass",
            icon: "xbox",
            color: Color(hex: "#107C10"),
            category: "Other",
            cancellationUrl: "https://account.microsoft.com/services"
        )
    ]
}
