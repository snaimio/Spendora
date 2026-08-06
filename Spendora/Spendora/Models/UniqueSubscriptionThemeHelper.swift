//
//  UniqueSubscriptionThemeHelper.swift
//

import SwiftUI

// MARK: - UniqueSubscriptionThemeHelper

/**
 `UniqueSubscriptionThemeHelper` ensures every single individual subscription card has a 100% unique, distinct color and icon representation based on its unique instance ID.
 */
struct UniqueSubscriptionThemeHelper {

    // MARK: - 30 Distinct Ultra-Vibrant Spectrum Palette
    static let vibrantPalette: [Color] = [
        Color(hex: "#6366F1"), // 1. Electric Indigo
        Color(hex: "#F43F5E"), // 2. Coral Rose
        Color(hex: "#10B981"), // 3. Emerald Mint
        Color(hex: "#F59E0B"), // 4. Golden Amber
        Color(hex: "#8B5CF6"), // 5. Electric Violet
        Color(hex: "#0EA5E9"), // 6. Sky Blue
        Color(hex: "#EC4899"), // 7. Hot Pink
        Color(hex: "#14B8A6"), // 8. Bright Teal
        Color(hex: "#A855F7"), // 9. Neon Purple
        Color(hex: "#F97316"), // 10. Sunset Orange
        Color(hex: "#06B6D4"), // 11. Cyan Blue
        Color(hex: "#84CC16"), // 12. Lime Green
        Color(hex: "#EF4444"), // 13. Crimson Red
        Color(hex: "#3B82F6"), // 14. Royal Blue
        Color(hex: "#D946EF"), // 15. Electric Magenta
        Color(hex: "#7C3AED"), // 16. Vibrant Grape
        Color(hex: "#00B4D8"), // 17. Tropical Turquoise
        Color(hex: "#EAB308"), // 18. Sun Yellow
        Color(hex: "#1D4ED8"), // 19. Deep Sapphire
        Color(hex: "#E11D48"), // 20. Bright Cherry
        Color(hex: "#059669"), // 21. Jade Green
        Color(hex: "#C084FC"), // 22. Bright Orchid
        Color(hex: "#D97706"), // 23. Deep Amber
        Color(hex: "#06D6A0"), // 24. Aqua Green
        Color(hex: "#FF6B6B"), // 25. Warm Coral
        Color(hex: "#00F5D4"), // 26. Electric Cyan
        Color(hex: "#7B2CBF"), // 27. Royal Purple
        Color(hex: "#FF5400"), // 28. Fire Orange
        Color(hex: "#3A86EF"), // 29. Deep Navy
        Color(hex: "#9D0208")  // 30. Berry Red
    ]

    // MARK: - Distinct SF Symbol Icons
    static let distinctIcons: [String] = [
        "sparkles", "star.fill", "bolt.fill", "flame.fill", "crown.fill",
        "shield.fill", "heart.fill", "gamecontroller.fill", "tv.fill", "music.note",
        "doc.text.fill", "cart.fill", "bag.fill", "globe", "key.fill", "cloud.fill"
    ]

    // MARK: - Color Resolver
    /// Guarantees a unique color for each individual subscription instance.
    static func resolveColor(for subscription: Subscription) -> Color {
        // 1. Explicit user custom color if set and customized
        if let hex = subscription.colorHex, !hex.isEmpty, hex != "#6C63FF" {
            return Color(hex: hex)
        }
        
        // 2. Compute unique index hash from subscription's unique UUID string
        let uuidString = subscription.id.uuidString
        let hash = abs(uuidString.hashValue)
        
        return vibrantPalette[hash % vibrantPalette.count]
    }

    // MARK: - Icon Resolver
    /// Resolves preset icon or computes distinct SF symbol.
    static func resolveIcon(for subscription: Subscription) -> String {
        let name = subscription.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 1. Matching Provider Preset Icon
        if let matchingPreset = SubscriptionPreset.all.first(where: {
            $0.name.localizedCaseInsensitiveCompare(name) == .orderedSame ||
            name.localizedCaseInsensitiveContains($0.name) ||
            $0.name.localizedCaseInsensitiveContains(name)
        }) {
            return matchingPreset.systemIcon
        }
        
        // 2. Category Icon if specific category mapped
        if let category = SubscriptionCategory(rawValue: subscription.category), category != .other {
            return category.icon
        }
        
        // 3. Unique icon derived from instance UUID
        let hash = abs(subscription.id.uuidString.hashValue)
        return distinctIcons[hash % distinctIcons.count]
    }
}
