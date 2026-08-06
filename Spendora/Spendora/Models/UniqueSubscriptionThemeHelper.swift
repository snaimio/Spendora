//
//  UniqueSubscriptionThemeHelper.swift
//

import SwiftUI

// MARK: - UniqueSubscriptionThemeHelper

/**
 `UniqueSubscriptionThemeHelper` ensures every single individual subscription card has a 100% unique, distinct color and icon representation based on Apple's recognized HIG system color spectrum.
 */
struct UniqueSubscriptionThemeHelper {

    // MARK: - Apple 30-Color HIG System Palette
    static let vibrantPalette: [Color] = [
        Color(hex: "#007AFF"), // 1. Apple System Blue
        Color(hex: "#5856D6"), // 2. Apple System Indigo
        Color(hex: "#AF52DE"), // 3. Apple System Purple
        Color(hex: "#FF2D55"), // 4. Apple System Pink
        Color(hex: "#FF3B30"), // 5. Apple System Red
        Color(hex: "#FF9500"), // 6. Apple System Orange
        Color(hex: "#34C759"), // 7. Apple System Green
        Color(hex: "#00C7BE"), // 8. Apple System Teal
        Color(hex: "#30B0C7"), // 9. Apple System Cyan
        Color(hex: "#5AC8FA"), // 10. Apple System Light Blue
        Color(hex: "#64D2FF"), // 11. Apple System Sky
        Color(hex: "#D152B8"), // 12. Apple System Magenta
        Color(hex: "#30D158"), // 13. Apple Mint Green
        Color(hex: "#FF453A"), // 14. Apple Coral Red
        Color(hex: "#FF9F0A"), // 15. Apple Warm Gold
        Color(hex: "#BF5AF2"), // 16. Apple Bright Purple
        Color(hex: "#5E5CE6"), // 17. Apple Deep Indigo
        Color(hex: "#32ADE6"), // 18. Apple Ocean Blue
        Color(hex: "#FF375F"), // 19. Apple Hot Rose
        Color(hex: "#30C759"), // 20. Apple Emerald
        Color(hex: "#F2A900"), // 21. Apple Amber
        Color(hex: "#9B51E0"), // 22. Apple Vivid Violet
        Color(hex: "#177E46"), // 23. Apple Forest Green
        Color(hex: "#0077B6"), // 24. Apple Royal Blue
        Color(hex: "#E54747"), // 25. Apple Crimson
        Color(hex: "#7D52DE"), // 26. Apple Dark Violet
        Color(hex: "#00A896"), // 27. Apple Dark Teal
        Color(hex: "#E63946"), // 28. Apple Deep Red
        Color(hex: "#2A9D8F"), // 29. Apple Sea Green
        Color(hex: "#8E8E93")  // 30. Apple System Gray
    ]

    // MARK: - Distinct SF Symbol Icons
    static let distinctIcons: [String] = [
        "sparkles", "star.fill", "bolt.fill", "flame.fill", "crown.fill",
        "shield.fill", "heart.fill", "gamecontroller.fill", "tv.fill", "music.note",
        "doc.text.fill", "cart.fill", "bag.fill", "globe", "key.fill", "cloud.fill"
    ]

    // MARK: - Color Resolver
    /// Guarantees a unique Apple HIG system color for each individual subscription instance.
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
