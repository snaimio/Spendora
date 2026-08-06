//
//  Color+App.swift
//

import SwiftUI

// MARK: - Color Extension

/**
 Extension on `Color` providing Spendora's High-Contrast, Eye-Friendly 4-Palette Design System.
 Guarantees maximum text legibility and visual contrast in both Light and Dark modes.
 */
extension Color {
    
    // MARK: - 4 Core Harmonious Color Palettes
    
    // Palette 1: Royal Indigo & Cyan (Primary Brand & Navigation)
    static let brandPrimary = Color(hex: "#6366F1")      // Royal Indigo
    static let brandAccent = Color(hex: "#0EA5E9")       // Electric Cyan
    
    // Palette 2: Emerald Mint & Teal (Healthy Budgets & Lifetime Purchases)
    static let brandTertiary = Color(hex: "#10B981")     // Emerald Mint
    static let brandTeal = Color(hex: "#14B8A6")         // Bright Teal
    
    // Palette 3: Sunset Rose & Coral (Alerts, Overdue, Due Soon)
    static let brandRose = Color(hex: "#F43F5E")         // Sunset Rose
    static let brandAmber = Color(hex: "#F59E0B")        // Warm Amber
    
    // Palette 4: Electric Violet & Magenta (Category Badges & AI Features)
    static let brandPurple = Color(hex: "#8B5CF6")       // Electric Violet
    static let brandMagenta = Color(hex: "#D946EF")      // Bright Magenta
    static let brandSecondary = Color(hex: "#8B5CF6")    // Secondary Violet
    
    // MARK: - High-Contrast Gradient Meshes
    static let gradientHero = LinearGradient(
        colors: [Color(hex: "#6366F1"), Color(hex: "#8B5CF6")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientMint = LinearGradient(
        colors: [Color(hex: "#10B981"), Color(hex: "#14B8A6")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientSunset = LinearGradient(
        colors: [Color(hex: "#F43F5E"), Color(hex: "#F59E0B")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientPurple = LinearGradient(
        colors: [Color(hex: "#8B5CF6"), Color(hex: "#D946EF")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Adaptive High-Contrast Surfaces (Maximum Dark Mode Legibility)
    
    /// Main App Background: Pure OLED Charcoal (#0B0F17) in Dark Mode, Soft Slate (#F8FAFC) in Light Mode
    static let appBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.04, green: 0.06, blue: 0.09, alpha: 1.0)     // #0B0F17
            : UIColor(red: 0.97, green: 0.98, blue: 0.99, alpha: 1.0)     // #F8FAFC
    })
    
    /// Card Container Background: Elevated Glass Slate (#1E293B) in Dark Mode, Pure White in Light Mode
    static let cardBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.12, green: 0.16, blue: 0.23, alpha: 1.0)     // Elevated Slate #1E293B
            : UIColor.white
    })
    
    /// Primary Text: High-Contrast Pure White (#FFFFFF) in Dark Mode, Dark Charcoal (#0F172A) in Light Mode
    static let textPrimary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor.white
            : UIColor(red: 0.06, green: 0.09, blue: 0.16, alpha: 1.0)
    })
    
    /// Secondary Text: Bright Crisp Slate (#CBD5E1) in Dark Mode, Slate Gray (#475569) in Light Mode
    static let textSecondary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.80, green: 0.84, blue: 0.88, alpha: 1.0)     // Bright Crisp Slate #CBD5E1 (100% visible)
            : UIColor(red: 0.28, green: 0.33, blue: 0.41, alpha: 1.0)
    })
    
    /// Tertiary Text: Light Slate (#94A3B8) in Dark Mode, Medium Slate (#64748B) in Light Mode
    static let textTertiary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.58, green: 0.64, blue: 0.72, alpha: 1.0)     // #94A3B8
            : UIColor(red: 0.39, green: 0.45, blue: 0.55, alpha: 1.0)
    })

    // MARK: - Category Color Palette
    static let categoryEntertainment = Color(hex: "#F43F5E")   // Rose
    static let categoryProductivity = Color(hex: "#6366F1")    // Indigo
    static let categoryHealth = Color(hex: "#10B981")          // Mint
    static let categoryShopping = Color(hex: "#F59E0B")        // Amber
    static let categoryFood = Color(hex: "#EF4444")            // Red
    static let categoryEducation = Color(hex: "#8B5CF6")       // Violet
    static let categoryAiTools = Color(hex: "#0EA5E9")         // Cyan
    static let categoryUtilities = Color(hex: "#14B8A6")       // Teal
    static let categoryGaming = Color(hex: "#D946EF")          // Magenta
    static let categoryOther = Color(hex: "#64748B")           // Slate
    
    // MARK: - Hex Initializer
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (
                255,
                (int >> 8) * 17,
                (int >> 4 & 0xF) * 17,
                (int & 0xF) * 17
            )
        case 6:
            (a, r, g, b) = (
                255,
                int >> 16,
                int >> 8 & 0xFF,
                int & 0xFF
            )
        case 8:
            (a, r, g, b) = (
                int >> 24,
                int >> 16 & 0xFF,
                int >> 8 & 0xFF,
                int & 0xFF
            )
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
