//
//  SubscriptionPresetData.swift
//

import SwiftUI

// MARK: - SubscriptionPreset Extension

extension SubscriptionPreset {
    static var all: [SubscriptionPreset] { allPresets }
    
    static let allPresets: [SubscriptionPreset] = [
        // MARK: - 🤖 AI & Developer Tools (15)
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
            name: "Gemini Advanced",
            icon: "gemini",
            color: Color(hex: "#1A73E8"),
            category: "AI & Tools",
            cancellationUrl: "https://gemini.google.com",
            colorHex: "#1A73E8"
        ),
        .init(
            name: "Cursor Pro",
            icon: "cursor",
            color: Color(hex: "#8B5CF6"),
            category: "AI & Tools",
            cancellationUrl: "https://cursor.sh",
            colorHex: "#8B5CF6"
        ),
        .init(
            name: "GitHub Copilot",
            icon: "copilot",
            color: Color(hex: "#24292E"),
            category: "AI & Tools",
            cancellationUrl: "https://github.com/settings/copilot",
            colorHex: "#24292E"
        ),
        .init(
            name: "Midjourney",
            icon: "sparkles",
            color: Color(hex: "#FF007F"),
            category: "AI & Tools",
            cancellationUrl: "https://www.midjourney.com/account",
            colorHex: "#FF007F"
        ),
        .init(
            name: "Perplexity Pro",
            icon: "ai",
            color: Color(hex: "#20B2AA"),
            category: "AI & Tools",
            cancellationUrl: "https://www.perplexity.ai/settings/account",
            colorHex: "#20B2AA"
        ),
        .init(
            name: "ElevenLabs Pro",
            icon: "sparkles",
            color: Color(hex: "#6366F1"),
            category: "AI & Tools",
            cancellationUrl: "https://elevenlabs.io",
            colorHex: "#6366F1"
        ),
        .init(
            name: "RunwayML Pro",
            icon: "sparkles",
            color: Color(hex: "#EC4899"),
            category: "AI & Tools",
            cancellationUrl: "https://runwayml.com",
            colorHex: "#EC4899"
        ),
        .init(
            name: "Poe Subscription",
            icon: "ai",
            color: Color(hex: "#7C3AED"),
            category: "AI & Tools",
            cancellationUrl: "https://poe.com",
            colorHex: "#7C3AED"
        ),
        .init(
            name: "Jasper AI",
            icon: "sparkles",
            color: Color(hex: "#F43F5E"),
            category: "AI & Tools",
            cancellationUrl: "https://www.jasper.ai",
            colorHex: "#F43F5E"
        ),
        .init(
            name: "v0 Pro (Vercel)",
            icon: "code",
            color: Color(hex: "#000000"),
            category: "AI & Tools",
            cancellationUrl: "https://v0.dev",
            colorHex: "#000000"
        ),
        .init(
            name: "DeepL Pro",
            icon: "ai",
            color: Color(hex: "#0F2B46"),
            category: "AI & Tools",
            cancellationUrl: "https://www.deepl.com",
            colorHex: "#0F2B46"
        ),
        .init(
            name: "JetBrains All Products",
            icon: "code",
            color: Color(hex: "#F97316"),
            category: "AI & Tools",
            cancellationUrl: "https://account.jetbrains.com",
            colorHex: "#F97316"
        ),
        .init(
            name: "Vercel Pro",
            icon: "code",
            color: Color(hex: "#000000"),
            category: "AI & Tools",
            cancellationUrl: "https://vercel.com/dashboard",
            colorHex: "#000000"
        ),

        // MARK: - 🎬 Video & Streaming (15)
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
            color: Color(hex: "#1F2937"),
            category: "Entertainment",
            cancellationUrl: "https://tv.apple.com",
            colorHex: "#1F2937"
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
        .init(
            name: "Starz",
            icon: "netflix",
            color: Color(hex: "#000000"),
            category: "Entertainment",
            cancellationUrl: "https://www.starz.com",
            colorHex: "#000000"
        ),
        .init(
            name: "Showtime",
            icon: "hbo",
            color: Color(hex: "#D90429"),
            category: "Entertainment",
            cancellationUrl: "https://www.showtime.com",
            colorHex: "#D90429"
        ),
        .init(
            name: "Discovery+",
            icon: "hulu",
            color: Color(hex: "#FF6C00"),
            category: "Entertainment",
            cancellationUrl: "https://www.discoveryplus.com",
            colorHex: "#FF6C00"
        ),
        .init(
            name: "MUBI",
            icon: "netflix",
            color: Color(hex: "#0F172A"),
            category: "Entertainment",
            cancellationUrl: "https://mubi.com",
            colorHex: "#0F172A"
        ),
        .init(
            name: "Twitch Turbo",
            icon: "youtube",
            color: Color(hex: "#9146FF"),
            category: "Entertainment",
            cancellationUrl: "https://www.twitch.tv/subscriptions",
            colorHex: "#9146FF"
        ),

        // MARK: - 🎵 Music & Audio (10)
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
            icon: "youtube",
            color: Color(hex: "#FF0000"),
            category: "Music",
            cancellationUrl: "https://music.youtube.com",
            colorHex: "#FF0000"
        ),
        .init(
            name: "Tidal",
            icon: "spotify",
            color: Color(hex: "#06B6D4"),
            category: "Music",
            cancellationUrl: "https://my.tidal.com",
            colorHex: "#06B6D4"
        ),
        .init(
            name: "Amazon Music",
            icon: "amazon",
            color: Color(hex: "#25D1DA"),
            category: "Music",
            cancellationUrl: "https://www.amazon.com/music/settings",
            colorHex: "#25D1DA"
        ),
        .init(
            name: "Audible",
            icon: "amazon",
            color: Color(hex: "#F97316"),
            category: "Music",
            cancellationUrl: "https://www.audible.com/account/overview",
            colorHex: "#F97316"
        ),
        .init(
            name: "SoundCloud Go+",
            icon: "spotify",
            color: Color(hex: "#FF5500"),
            category: "Music",
            cancellationUrl: "https://soundcloud.com/you/subscriptions",
            colorHex: "#FF5500"
        ),
        .init(
            name: "Deezer Premium",
            icon: "spotify",
            color: Color(hex: "#A855F7"),
            category: "Music",
            cancellationUrl: "https://www.deezer.com/account/subscription",
            colorHex: "#A855F7"
        ),
        .init(
            name: "Pandora Plus",
            icon: "spotify",
            color: Color(hex: "#0284C7"),
            category: "Music",
            cancellationUrl: "https://www.pandora.com/account",
            colorHex: "#0284C7"
        ),
        .init(
            name: "SiriusXM",
            icon: "spotify",
            color: Color(hex: "#0F172A"),
            category: "Music",
            cancellationUrl: "https://www.siriusxm.com",
            colorHex: "#0F172A"
        ),

        // MARK: - 💼 Productivity & Cloud (20)
        .init(
            name: "Microsoft 365",
            icon: "microsoft",
            color: Color(hex: "#EA580C"),
            category: "Productivity",
            cancellationUrl: "https://account.microsoft.com/services",
            colorHex: "#EA580C"
        ),
        .init(
            name: "Google One",
            icon: "google",
            color: Color(hex: "#3B82F6"),
            category: "Productivity",
            cancellationUrl: "https://one.google.com",
            colorHex: "#3B82F6"
        ),
        .init(
            name: "iCloud+",
            icon: "cloud",
            color: Color(hex: "#0EA5E9"),
            category: "Productivity",
            cancellationUrl: "https://support.apple.com/HT207594",
            colorHex: "#0EA5E9"
        ),
        .init(
            name: "Dropbox",
            icon: "dropbox",
            color: Color(hex: "#2563EB"),
            category: "Productivity",
            cancellationUrl: "https://www.dropbox.com/account/plan",
            colorHex: "#2563EB"
        ),
        .init(
            name: "Notion Plus",
            icon: "notion",
            color: Color(hex: "#18181B"),
            category: "Productivity",
            cancellationUrl: "https://www.notion.so/settings/plans",
            colorHex: "#18181B"
        ),
        .init(
            name: "Canva Pro",
            icon: "adobe",
            color: Color(hex: "#06B6D4"),
            category: "Productivity",
            cancellationUrl: "https://www.canva.com/settings/billing",
            colorHex: "#06B6D4"
        ),
        .init(
            name: "Adobe Creative Cloud",
            icon: "adobe",
            color: Color(hex: "#EF4444"),
            category: "Productivity",
            cancellationUrl: "https://account.adobe.com/plans",
            colorHex: "#EF4444"
        ),
        .init(
            name: "Figma Professional",
            icon: "adobe",
            color: Color(hex: "#F97316"),
            category: "Productivity",
            cancellationUrl: "https://www.figma.com/settings",
            colorHex: "#F97316"
        ),
        .init(
            name: "Grammarly Premium",
            icon: "notion",
            color: Color(hex: "#10B981"),
            category: "Productivity",
            cancellationUrl: "https://account.grammarly.com",
            colorHex: "#10B981"
        ),
        .init(
            name: "Evernote",
            icon: "notion",
            color: Color(hex: "#22C55E"),
            category: "Productivity",
            cancellationUrl: "https://www.evernote.com/Billing.action",
            colorHex: "#22C55E"
        ),
        .init(
            name: "1Password",
            icon: "lock",
            color: Color(hex: "#0284C7"),
            category: "Productivity",
            cancellationUrl: "https://my.1password.com",
            colorHex: "#0284C7"
        ),
        .init(
            name: "Bitwarden Premium",
            icon: "lock",
            color: Color(hex: "#1D4ED8"),
            category: "Productivity",
            cancellationUrl: "https://vault.bitwarden.com",
            colorHex: "#1D4ED8"
        ),
        .init(
            name: "LastPass",
            icon: "lock",
            color: Color(hex: "#DC2626"),
            category: "Productivity",
            cancellationUrl: "https://lastpass.com",
            colorHex: "#DC2626"
        ),
        .init(
            name: "Slack Pro",
            icon: "google",
            color: Color(hex: "#8B5CF6"),
            category: "Productivity",
            cancellationUrl: "https://slack.com/account/settings",
            colorHex: "#8B5CF6"
        ),
        .init(
            name: "Zoom Pro",
            icon: "google",
            color: Color(hex: "#2563EB"),
            category: "Productivity",
            cancellationUrl: "https://zoom.us/account",
            colorHex: "#2563EB"
        ),
        .init(
            name: "Todoist Pro",
            icon: "notion",
            color: Color(hex: "#E11D48"),
            category: "Productivity",
            cancellationUrl: "https://todoist.com/app/settings/subscription",
            colorHex: "#E11D48"
        ),
        .init(
            name: "Linear Standard",
            icon: "code",
            color: Color(hex: "#6366F1"),
            category: "Productivity",
            cancellationUrl: "https://linear.app",
            colorHex: "#6366F1"
        ),
        .init(
            name: "CleanMyMac X",
            icon: "adobe",
            color: Color(hex: "#EC4899"),
            category: "Productivity",
            cancellationUrl: "https://macpaw.com/account",
            colorHex: "#EC4899"
        ),
        .init(
            name: "Setapp",
            icon: "microsoft",
            color: Color(hex: "#4F46E5"),
            category: "Productivity",
            cancellationUrl: "https://setapp.com/account",
            colorHex: "#4F46E5"
        ),
        .init(
            name: "NordVPN",
            icon: "lock",
            color: Color(hex: "#3B82F6"),
            category: "Productivity",
            cancellationUrl: "https://my.nordaccount.com",
            colorHex: "#3B82F6"
        ),

        // MARK: - 🎮 Gaming & Esports (10)
        .init(
            name: "Xbox Game Pass",
            icon: "xbox",
            color: Color(hex: "#16A34A"),
            category: "Entertainment",
            cancellationUrl: "https://account.microsoft.com/services",
            colorHex: "#16A34A"
        ),
        .init(
            name: "PlayStation Plus",
            icon: "playstation",
            color: Color(hex: "#1D4ED8"),
            category: "Entertainment",
            cancellationUrl: "https://www.playstation.com/account",
            colorHex: "#1D4ED8"
        ),
        .init(
            name: "Nintendo Switch Online",
            icon: "nintendo",
            color: Color(hex: "#DC2626"),
            category: "Entertainment",
            cancellationUrl: "https://ec.nintendo.com/membership",
            colorHex: "#DC2626"
        ),
        .init(
            name: "GeForce NOW",
            icon: "gaming",
            color: Color(hex: "#65A30D"),
            category: "Entertainment",
            cancellationUrl: "https://www.nvidia.com/account",
            colorHex: "#65A30D"
        ),
        .init(
            name: "EA Play",
            icon: "gaming",
            color: Color(hex: "#EA580C"),
            category: "Entertainment",
            cancellationUrl: "https://myaccount.ea.com",
            colorHex: "#EA580C"
        ),
        .init(
            name: "Ubisoft+",
            icon: "gaming",
            color: Color(hex: "#2563EB"),
            category: "Entertainment",
            cancellationUrl: "https://store.ubisoft.com/ubisoftplus",
            colorHex: "#2563EB"
        ),
        .init(
            name: "World of Warcraft",
            icon: "gaming",
            color: Color(hex: "#D97706"),
            category: "Entertainment",
            cancellationUrl: "https://account.battle.net",
            colorHex: "#D97706"
        ),
        .init(
            name: "Final Fantasy XIV",
            icon: "gaming",
            color: Color(hex: "#7C3AED"),
            category: "Entertainment",
            cancellationUrl: "https://sqex.to/MogStation",
            colorHex: "#7C3AED"
        ),
        .init(
            name: "Discord Nitro",
            icon: "gaming",
            color: Color(hex: "#6366F1"),
            category: "Entertainment",
            cancellationUrl: "https://discord.com/app",
            colorHex: "#6366F1"
        ),
        .init(
            name: "Roblox Premium",
            icon: "gaming",
            color: Color(hex: "#09090B"),
            category: "Entertainment",
            cancellationUrl: "https://www.roblox.com/my/account",
            colorHex: "#09090B"
        ),

        // MARK: - 🏋️ Health, Wellness & Education (15)
        .init(
            name: "Apple Fitness+",
            icon: "fitness",
            color: Color(hex: "#84CC16"),
            category: "Health & Fitness",
            cancellationUrl: "https://apps.apple.com/account/subscriptions",
            colorHex: "#84CC16"
        ),
        .init(
            name: "Strava Subscription",
            icon: "fitness",
            color: Color(hex: "#EA580C"),
            category: "Health & Fitness",
            cancellationUrl: "https://www.strava.com/settings/billing",
            colorHex: "#EA580C"
        ),
        .init(
            name: "Fitbit Premium",
            icon: "fitbit",
            color: Color(hex: "#06B6D4"),
            category: "Health & Fitness",
            cancellationUrl: "https://www.fitbit.com/settings/subscription",
            colorHex: "#06B6D4"
        ),
        .init(
            name: "MyFitnessPal",
            icon: "fitness",
            color: Color(hex: "#E11D48"),
            category: "Health & Fitness",
            cancellationUrl: "https://www.myfitnesspal.com/account/subscription",
            colorHex: "#E11D48"
        ),
        .init(
            name: "Headspace",
            icon: "fitness",
            color: Color(hex: "#F97316"),
            category: "Health & Fitness",
            cancellationUrl: "https://www.headspace.com/subscription/manage",
            colorHex: "#F97316"
        ),
        .init(
            name: "Calm",
            icon: "fitness",
            color: Color(hex: "#3B82F6"),
            category: "Health & Fitness",
            cancellationUrl: "https://www.calm.com/profile",
            colorHex: "#3B82F6"
        ),
        .init(
            name: "Duolingo Super",
            icon: "learn",
            color: Color(hex: "#22C55E"),
            category: "Education",
            cancellationUrl: "https://www.duolingo.com/settings/plus",
            colorHex: "#22C55E"
        ),
        .init(
            name: "MasterClass",
            icon: "learn",
            color: Color(hex: "#09090B"),
            category: "Education",
            cancellationUrl: "https://www.masterclass.com/account",
            colorHex: "#09090B"
        ),
        .init(
            name: "Skillshare",
            icon: "learn",
            color: Color(hex: "#10B981"),
            category: "Education",
            cancellationUrl: "https://www.skillshare.com/settings/payments",
            colorHex: "#10B981"
        ),
        .init(
            name: "Coursera Plus",
            icon: "learn",
            color: Color(hex: "#2563EB"),
            category: "Education",
            cancellationUrl: "https://www.coursera.org/account-settings",
            colorHex: "#2563EB"
        ),
        .init(
            name: "Udemy Pro",
            icon: "learn",
            color: Color(hex: "#9333EA"),
            category: "Education",
            cancellationUrl: "https://www.udemy.com/user/edit-subscription",
            colorHex: "#9333EA"
        ),
        .init(
            name: "LinkedIn Premium",
            icon: "google",
            color: Color(hex: "#0284C7"),
            category: "Education",
            cancellationUrl: "https://www.linkedin.com/premium/manage",
            colorHex: "#0284C7"
        ),
        .init(
            name: "Whoop Membership",
            icon: "fitness",
            color: Color(hex: "#18181B"),
            category: "Health & Fitness",
            cancellationUrl: "https://app.whoop.com/membership",
            colorHex: "#18181B"
        ),
        .init(
            name: "Oura Ring",
            icon: "fitness",
            color: Color(hex: "#3F3F46"),
            category: "Health & Fitness",
            cancellationUrl: "https://ouraring.com/my-account",
            colorHex: "#3F3F46"
        ),
        .init(
            name: "Peloton App",
            icon: "fitness",
            color: Color(hex: "#EF4444"),
            category: "Health & Fitness",
            cancellationUrl: "https://members.onepeloton.com/preferences/subscriptions",
            colorHex: "#EF4444"
        ),

        // MARK: - 🛒 Food, Shopping & News (15)
        .init(
            name: "Amazon Prime",
            icon: "amazon",
            color: Color(hex: "#F59E0B"),
            category: "Shopping",
            cancellationUrl: "https://www.amazon.com/gp/css/account/manageprime",
            colorHex: "#F59E0B"
        ),
        .init(
            name: "DoorDash DashPass",
            icon: "bag",
            color: Color(hex: "#EF4444"),
            category: "Food & Dining",
            cancellationUrl: "https://www.doordash.com/dashpass",
            colorHex: "#EF4444"
        ),
        .init(
            name: "Uber One",
            icon: "car",
            color: Color(hex: "#18181B"),
            category: "Services",
            cancellationUrl: "https://www.uber.com/uber-one",
            colorHex: "#18181B"
        ),
        .init(
            name: "Instacart+",
            icon: "bag",
            color: Color(hex: "#10B981"),
            category: "Food & Dining",
            cancellationUrl: "https://www.instacart.com/store/account/instacart-plus",
            colorHex: "#10B981"
        ),
        .init(
            name: "Grubhub+",
            icon: "bag",
            color: Color(hex: "#DC2626"),
            category: "Food & Dining",
            cancellationUrl: "https://www.grubhub.com/account/grubhub-plus",
            colorHex: "#DC2626"
        ),
        .init(
            name: "HelloFresh",
            icon: "hellofresh",
            color: Color(hex: "#22C55E"),
            category: "Food & Dining",
            cancellationUrl: "https://www.hellofresh.com/account/cancel",
            colorHex: "#22C55E"
        ),
        .init(
            name: "Walmart+",
            icon: "amazon",
            color: Color(hex: "#0284C7"),
            category: "Shopping",
            cancellationUrl: "https://www.walmart.com/plus",
            colorHex: "#0284C7"
        ),
        .init(
            name: "The New York Times",
            icon: "news",
            color: Color(hex: "#18181B"),
            category: "News",
            cancellationUrl: "https://www.nytimes.com/subscription/cancel",
            colorHex: "#18181B"
        ),
        .init(
            name: "Wall Street Journal",
            icon: "news",
            color: Color(hex: "#0F172A"),
            category: "News",
            cancellationUrl: "https://customercenter.wsj.com",
            colorHex: "#0F172A"
        ),
        .init(
            name: "Bloomberg All Access",
            icon: "news",
            color: Color(hex: "#3B82F6"),
            category: "News",
            cancellationUrl: "https://www.bloomberg.com/account",
            colorHex: "#3B82F6"
        ),
        .init(
            name: "The Economist",
            icon: "news",
            color: Color(hex: "#DC2626"),
            category: "News",
            cancellationUrl: "https://www.economist.com/my-account",
            colorHex: "#DC2626"
        ),
        .init(
            name: "Medium Membership",
            icon: "news",
            color: Color(hex: "#18181B"),
            category: "News",
            cancellationUrl: "https://medium.com/me/settings/membership",
            colorHex: "#18181B"
        ),
        .init(
            name: "Substack",
            icon: "news",
            color: Color(hex: "#F97316"),
            category: "News",
            cancellationUrl: "https://substack.com/settings",
            colorHex: "#F97316"
        ),
        .init(
            name: "Patreon",
            icon: "bag",
            color: Color(hex: "#F43F5E"),
            category: "Services",
            cancellationUrl: "https://www.patreon.com/settings/memberships",
            colorHex: "#F43F5E"
        ),
        .init(
            name: "Proton Unlimited",
            icon: "lock",
            color: Color(hex: "#8B5CF6"),
            category: "Productivity",
            cancellationUrl: "https://account.proton.me",
            colorHex: "#8B5CF6"
        )
    ]
}
