//
//  SubscriptionPresetData.swift
//

import SwiftUI

// MARK: - SubscriptionPreset Extension

extension SubscriptionPreset {
    static var all: [SubscriptionPreset] { allPresets }
    
    static let allPresets: [SubscriptionPreset] = [
        // MARK: - 🎬 Video & Streaming (10)
        .init(
            name: "Netflix",
            icon: "netflix",
            color: Color(hex: "#E50914"),
            category: "Entertainment",
            cancellationUrl: "https://www.netflix.com/youraccount",
            colorHex: "#E50914"
        ),
        .init(
            name: "Disney+",
            icon: "disney",
            color: Color(hex: "#113CCF"),
            category: "Entertainment",
            cancellationUrl: "https://www.disneyplus.com/account",
            colorHex: "#113CCF"
        ),
        .init(
            name: "Hulu",
            icon: "hulu",
            color: Color(hex: "#1CE783"),
            category: "Entertainment",
            cancellationUrl: "https://www.hulu.com/account",
            colorHex: "#1CE783"
        ),
        .init(
            name: "YouTube Premium",
            icon: "youtube",
            color: Color(hex: "#FF0000"),
            category: "Entertainment",
            cancellationUrl: "https://www.youtube.com/paid_memberships",
            colorHex: "#FF0000"
        ),
        .init(
            name: "Max (HBO)",
            icon: "hbo",
            color: Color(hex: "#5822B4"),
            category: "Entertainment",
            cancellationUrl: "https://www.max.com",
            colorHex: "#5822B4"
        ),
        .init(
            name: "Amazon Prime Video",
            icon: "amazon",
            color: Color(hex: "#00A8E1"),
            category: "Entertainment",
            cancellationUrl: "https://www.amazon.com/gp/video/settings",
            colorHex: "#00A8E1"
        ),
        .init(
            name: "Apple TV+",
            icon: "apple.tv",
            color: Color(hex: "#000000"),
            category: "Entertainment",
            cancellationUrl: "https://tv.apple.com",
            colorHex: "#000000"
        ),
        .init(
            name: "Paramount+",
            icon: "paramount",
            color: Color(hex: "#0064FF"),
            category: "Entertainment",
            cancellationUrl: "https://www.paramountplus.com/account",
            colorHex: "#0064FF"
        ),
        .init(
            name: "Peacock",
            icon: "peacock",
            color: Color(hex: "#00A651"),
            category: "Entertainment",
            cancellationUrl: "https://www.peacocktv.com/account",
            colorHex: "#00A651"
        ),
        .init(
            name: "Crunchyroll",
            icon: "crunchyroll",
            color: Color(hex: "#F47521"),
            category: "Entertainment",
            cancellationUrl: "https://www.crunchyroll.com/account",
            colorHex: "#F47521"
        ),
        
        // MARK: - 🎵 Music & Podcasts (5)
        .init(
            name: "Spotify",
            icon: "spotify",
            color: Color(hex: "#1DB954"),
            category: "Music",
            cancellationUrl: "https://www.spotify.com/account/overview/",
            colorHex: "#1DB954"
        ),
        .init(
            name: "Apple Music",
            icon: "apple.music",
            color: Color(hex: "#FA243C"),
            category: "Music",
            cancellationUrl: "https://apps.apple.com/account/subscriptions",
            colorHex: "#FA243C"
        ),
        .init(
            name: "YouTube Music",
            icon: "music.note",
            color: Color(hex: "#FF0000"),
            category: "Music",
            cancellationUrl: "https://music.youtube.com",
            colorHex: "#FF0000"
        ),
        .init(
            name: "Tidal",
            icon: "waveform",
            color: Color(hex: "#000000"),
            category: "Music",
            cancellationUrl: "https://my.tidal.com",
            colorHex: "#000000"
        ),
        .init(
            name: "Amazon Music",
            icon: "music.note.list",
            color: Color(hex: "#25D1DA"),
            category: "Music",
            cancellationUrl: "https://www.amazon.com/music/settings",
            colorHex: "#25D1DA"
        ),
        
        // MARK: - 🤖 AI & Developer Tools (5)
        .init(
            name: "ChatGPT Plus",
            icon: "openai",
            color: Color(hex: "#10A37F"),
            category: "AI & Tools",
            cancellationUrl: "https://chatgpt.com",
            colorHex: "#10A37F"
        ),
        .init(
            name: "Claude Pro",
            icon: "anthropic",
            color: Color(hex: "#D97757"),
            category: "AI & Tools",
            cancellationUrl: "https://claude.ai",
            colorHex: "#D97757"
        ),
        .init(
            name: "Midjourney",
            icon: "sparkles",
            color: Color(hex: "#2F3136"),
            category: "AI & Tools",
            cancellationUrl: "https://www.midjourney.com/account",
            colorHex: "#2F3136"
        ),
        .init(
            name: "GitHub Copilot",
            icon: "chevron.left.forwardslash.chevron.right",
            color: Color(hex: "#24292E"),
            category: "AI & Tools",
            cancellationUrl: "https://github.com/settings/copilot",
            colorHex: "#24292E"
        ),
        .init(
            name: "Perplexity Pro",
            icon: "magnifyingglass.circle.fill",
            color: Color(hex: "#20B2AA"),
            category: "AI & Tools",
            cancellationUrl: "https://www.perplexity.ai/settings/account",
            colorHex: "#20B2AA"
        ),
        
        // MARK: - 💼 Productivity & Cloud (8)
        .init(
            name: "Microsoft 365",
            icon: "microsoft",
            color: Color(hex: "#D83B01"),
            category: "Productivity",
            cancellationUrl: "https://account.microsoft.com/services",
            colorHex: "#D83B01"
        ),
        .init(
            name: "Google One / Workspace",
            icon: "google",
            color: Color(hex: "#4285F4"),
            category: "Productivity",
            cancellationUrl: "https://one.google.com",
            colorHex: "#4285F4"
        ),
        .init(
            name: "iCloud+",
            icon: "cloud.fill",
            color: Color(hex: "#3699FF"),
            category: "Productivity",
            cancellationUrl: "https://support.apple.com/HT207594",
            colorHex: "#3699FF"
        ),
        .init(
            name: "Dropbox",
            icon: "dropbox",
            color: Color(hex: "#0061FF"),
            category: "Productivity",
            cancellationUrl: "https://www.dropbox.com/account/plan",
            colorHex: "#0061FF"
        ),
        .init(
            name: "Notion",
            icon: "notion",
            color: Color(hex: "#000000"),
            category: "Productivity",
            cancellationUrl: "https://www.notion.so/settings/plans",
            colorHex: "#000000"
        ),
        .init(
            name: "Canva Pro",
            icon: "paintpalette.fill",
            color: Color(hex: "#00C4CC"),
            category: "Productivity",
            cancellationUrl: "https://www.canva.com/settings/billing",
            colorHex: "#00C4CC"
        ),
        .init(
            name: "Adobe Creative Cloud",
            icon: "adobe",
            color: Color(hex: "#FF0000"),
            category: "Productivity",
            cancellationUrl: "https://account.adobe.com/plans",
            colorHex: "#FF0000"
        ),
        .init(
            name: "Figma Professional",
            icon: "square.split.2x2.fill",
            color: Color(hex: "#F24E1E"),
            category: "Productivity",
            cancellationUrl: "https://www.figma.com/settings",
            colorHex: "#F24E1E"
        ),
        
        // MARK: - 🎮 Gaming (3)
        .init(
            name: "Xbox Game Pass",
            icon: "gamecontroller.fill",
            color: Color(hex: "#107C41"),
            category: "Entertainment",
            cancellationUrl: "https://account.microsoft.com/services",
            colorHex: "#107C41"
        ),
        .init(
            name: "PlayStation Plus",
            icon: "playstation",
            color: Color(hex: "#0070D1"),
            category: "Entertainment",
            cancellationUrl: "https://www.playstation.com/account",
            colorHex: "#0070D1"
        ),
        .init(
            name: "Nintendo Switch Online",
            icon: "gamecontroller",
            color: Color(hex: "#E60012"),
            category: "Entertainment",
            cancellationUrl: "https://ec.nintendo.com/membership",
            colorHex: "#E60012"
        ),
        
        // MARK: - 🏋️ Health & Wellness (5)
        .init(
            name: "Apple Fitness+",
            icon: "heart.fill",
            color: Color(hex: "#A3E635"),
            category: "Health & Fitness",
            cancellationUrl: "https://apps.apple.com/account/subscriptions",
            colorHex: "#A3E635"
        ),
        .init(
            name: "Strava Subscription",
            icon: "figure.run",
            color: Color(hex: "#FC4C02"),
            category: "Health & Fitness",
            cancellationUrl: "https://www.strava.com/settings/billing",
            colorHex: "#FC4C02"
        ),
        .init(
            name: "Fitbit Premium",
            icon: "fitbit",
            color: Color(hex: "#00B0B9"),
            category: "Health & Fitness",
            cancellationUrl: "https://www.fitbit.com/settings/subscription",
            colorHex: "#00B0B9"
        ),
        .init(
            name: "MyFitnessPal",
            icon: "fitness",
            color: Color(hex: "#CC3345"),
            category: "Health & Fitness",
            cancellationUrl: "https://www.myfitnesspal.com/account/subscription",
            colorHex: "#CC3345"
        ),
        .init(
            name: "Headspace / Calm",
            icon: "brain.head.profile",
            color: Color(hex: "#F47E36"),
            category: "Health & Fitness",
            cancellationUrl: "https://www.headspace.com/subscription/manage",
            colorHex: "#F47E36"
        ),
        
        // MARK: - 🛒 Food & Shopping (4)
        .init(
            name: "Amazon Prime",
            icon: "amazon",
            color: Color(hex: "#FF9900"),
            category: "Shopping",
            cancellationUrl: "https://www.amazon.com/gp/css/account/manageprime",
            colorHex: "#FF9900"
        ),
        .init(
            name: "DoorDash DashPass",
            icon: "bag.fill",
            color: Color(hex: "#FF3008"),
            category: "Food & Dining",
            cancellationUrl: "https://www.doordash.com/dashpass",
            colorHex: "#FF3008"
        ),
        .init(
            name: "Uber One",
            icon: "car.fill",
            color: Color(hex: "#000000"),
            category: "Services",
            cancellationUrl: "https://www.uber.com/uber-one",
            colorHex: "#000000"
        ),
        .init(
            name: "HelloFresh",
            icon: "hellofresh",
            color: Color(hex: "#43B02A"),
            category: "Food & Dining",
            cancellationUrl: "https://www.hellofresh.com/account/cancel",
            colorHex: "#43B02A"
        )
    ]
}
