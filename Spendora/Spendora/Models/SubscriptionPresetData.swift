//
//  SubscriptionPresetData.swift
//  Spendora
//
//  Capstone 2026 - Mobile Application Development
//  Author: Sheikh Naim
//

/**
 * Main/Core Functions & Purpose:
 * Extension providing the static list of pre-configured subscription presets.
 */

import SwiftUI

extension SubscriptionPreset {
    static var all: [SubscriptionPreset] { allPresets }
    
    static let allPresets: [SubscriptionPreset] = [
        // MARK: - Streaming & Entertainment
        .init(
            name: "Netflix",
            icon: "netflix",
            color: Color(hex: "#E50914"),
            category: "Entertainment",
            cancellationUrl: "https://www.netflix.com/youraccount"
        ),
        .init(
            name: "Spotify",
            icon: "spotify",
            color: Color(hex: "#1DB954"),
            category: "Music",
            cancellationUrl: "https://www.spotify.com/account/overview/"
        ),
        .init(
            name: "Apple Music",
            icon: "apple.music",
            color: Color(hex: "#FA243C"),
            category: "Music",
            cancellationUrl: "https://apps.apple.com/account/subscriptions"
        ),
        .init(
            name: "Disney+",
            icon: "disney",
            color: Color(hex: "#113CCF"),
            category: "Entertainment",
            cancellationUrl: "https://www.disneyplus.com/account"
        ),
        .init(
            name: "Hulu",
            icon: "hulu",
            color: Color(hex: "#1CE783"),
            category: "Entertainment",
            cancellationUrl: "https://www.hulu.com/account"
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
            cancellationUrl: "https://www.max.com"
        ),
        
        // MARK: - AI Tools
        .init(
            name: "ChatGPT Plus",
            icon: "openai",
            color: Color(hex: "#10A37F"),
            category: "AI & Tools",
            cancellationUrl: "https://chatgpt.com"
        ),
        .init(
            name: "Claude Pro",
            icon: "anthropic",
            color: Color(hex: "#D97757"),
            category: "AI & Tools",
            cancellationUrl: "https://claude.ai"
        ),
        
        // MARK: - Productivity
        .init(
            name: "Microsoft 365",
            icon: "microsoft",
            color: Color(hex: "#D83B01"),
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
        
        // MARK: - Food & Gaming
        .init(
            name: "HelloFresh",
            icon: "hellofresh",
            color: Color(hex: "#43B02A"),
            category: "Food & Dining",
            cancellationUrl: "https://www.hellofresh.com/account/cancel"
        ),
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
        )
    ]
}
