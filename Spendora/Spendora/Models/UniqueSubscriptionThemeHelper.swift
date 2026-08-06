//
//  UniqueSubscriptionThemeHelper.swift
//

import SwiftUI

// MARK: - UniqueSubscriptionThemeHelper

/**
 `UniqueSubscriptionThemeHelper` ensures every subscription card and icon has a vibrant, distinct, and unique color and SF Symbol representation.
 */
struct UniqueSubscriptionThemeHelper {

    // MARK: - Vibrant 16-Color Palette
    static let vibrantPalette: [Color] = [
        Color(hex: "#6366F1"), // Indigo
        Color(hex: "#EC4899"), // Hot Pink
        Color(hex: "#10B981"), // Emerald Green
        Color(hex: "#F59E0B"), // Amber Gold
        Color(hex: "#8B5CF6"), // Neon Violet
        Color(hex: "#0EA5E9"), // Sky Blue
        Color(hex: "#F43F5E"), // Coral Rose
        Color(hex: "#14B8A6"), // Teal
        Color(hex: "#D946EF"), // Magenta
        Color(hex: "#3B82F6"), // Royal Blue
        Color(hex: "#F97316"), // Sunset Orange
        Color(hex: "#84CC16"), // Lime Green
        Color(hex: "#A855F7"), // Purple
        Color(hex: "#06B6D4"), // Cyan
        Color(hex: "#EF4444"), // Crimson Red
        Color(hex: "#64748B")  // Slate Blue
    ]

    // MARK: - Distinct SF Symbol Icons
    static let distinctIcons: [String] = [
        "sparkles", "star.fill", "bolt.fill", "flame.fill", "crown.fill",
        "shield.fill", "heart.fill", "gamecontroller.fill", "tv.fill", "music.note",
        "doc.text.fill", "cart.fill", "bag.fill", "globe", "key.fill", "cloud.fill"
    ]

    // MARK: - Color Resolver
    static func resolveColor(for subscription: Subscription) -> Color {
        // 1. Explicit custom colorHex if specified by user
        if let hex = subscription.colorHex, !hex.isEmpty, hex != "#6C63FF" {
            return Color(hex: hex)
        }
        
        // 2. Matching Provider Preset Color
        let name = subscription.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        if let matchingPreset = SubscriptionPreset.all.first(where: {
            $0.name.localizedCaseInsensitiveCompare(name) == .orderedSame ||
            name.localizedCaseInsensitiveContains($0.name) ||
            $0.name.localizedCaseInsensitiveContains(name)
        }) {
            return matchingPreset.color
        }
        
        // 3. Deterministic Unique Color hash derived from subscription name
        let hash = abs(name.lowercased().hashValue)
        return vibrantPalette[hash % vibrantPalette.count]
    }

    // MARK: - Icon Resolver
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
        
        // 3. Deterministic Unique Icon hash derived from subscription name
        let hash = abs(name.lowercased().hashValue)
        return distinctIcons[hash % distinctIcons.count]
    }
}
