//
//  Color+App.swift
//

import SwiftUI

// MARK: - Color Extension

/**
 Extension on `Color` providing Spendora's High-Contrast, Eye-Friendly Color System.
 Features Deep Indigo (#4F46E5) & Royal Blue (#2563EB) for an eye-pleasing, WCAG AAA compliant visual hierarchy in both Light and Dark modes.
 */
extension Color {
    
    // MARK: - Eye-Friendly Brand Palette
    static let brandPrimary = Color(hex: "#4F46E5")      // Deep Indigo (Soft on the eyes)
    static let brandSecondary = Color(hex: "#2563EB")    // Royal Blue
    static let brandAccent = Color(hex: "#38BDF8")       // Sky Blue
    static let brandTertiary = Color(hex: "#10B981")     // Emerald Mint
    static let brandCoral = Color(hex: "#F43F5E")        // Coral Rose
    static let brandGold = Color(hex: "#F59E0B")         // Warm Gold
    static let brandAmber = Color(hex: "#F59E0B")        // Warm Amber
    static let brandPurple = Color(hex: "#8B5CF6")       // Electric Violet
    static let brandRose = Color(hex: "#E11D48")         // Crimson Rose
    
    // MARK: - Status Colors
    static let statusUrgentRed = Color(hex: "#F43F5E")   // Urgent Red
    static let statusSoonAmber = Color(hex: "#F59E0B")   // Soon Amber
    static let statusSafeGreen = Color(hex: "#10B981")   // Safe Green
    
    // MARK: - Gradient Meshes
    static let gradientHero = LinearGradient(
        colors: [Color(hex: "#4F46E5"), Color(hex: "#2563EB"), Color(hex: "#38BDF8")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientTeal = LinearGradient(
        colors: [Color(hex: "#10B981"), Color(hex: "#14B8A6")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientCoral = LinearGradient(
        colors: [Color(hex: "#F43F5E"), Color(hex: "#F59E0B")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientGold = LinearGradient(
        colors: [Color(hex: "#F59E0B"), Color(hex: "#D97706")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Adaptive Surfaces (Maximum 100% Dark Mode & Light Mode Legibility)
    
    /// Main App Canvas: Deep Slate (#0B0F17) in Dark Mode, Soft Slate (#F8FAFC) in Light Mode
    static let appBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.04, green: 0.06, blue: 0.09, alpha: 1.0)     // #0B0F17
            : UIColor(red: 0.97, green: 0.98, blue: 0.99, alpha: 1.0)     // #F8FAFC
    })
    
    /// Card Container Background: Elevated Slate Glass (#1E293B) in Dark Mode, Pure White in Light Mode
    static let cardBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.12, green: 0.16, blue: 0.23, alpha: 1.0)     // #1E293B
            : UIColor.white
    })
    
    /// Primary Text: Pure Crisp White (#FFFFFF) in Dark Mode, Dark Slate (#0F172A) in Light Mode
    static let textPrimary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor.white
            : UIColor(red: 0.06, green: 0.09, blue: 0.16, alpha: 1.0)
    })
    
    /// Secondary Text: High-Contrast Slate (#E2E8F0) in Dark Mode, Dark Gray (#475569) in Light Mode
    static let textSecondary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.88, green: 0.91, blue: 0.94, alpha: 1.0)     // #E2E8F0 (100% visible in Dark Mode)
            : UIColor(red: 0.28, green: 0.33, blue: 0.41, alpha: 1.0)
    })
    
    /// Tertiary Text: Light Slate (#94A3B8) in Dark Mode, Slate Gray (#64748B) in Light Mode
    static let textTertiary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.58, green: 0.64, blue: 0.72, alpha: 1.0)     // #94A3B8
            : UIColor(red: 0.39, green: 0.45, blue: 0.55, alpha: 1.0)
    })

    // MARK: - 10+ Category Colors
    static let categoryEntertainment = Color(hex: "#F43F5E")   // Rose
    static let categoryProductivity = Color(hex: "#4F46E5")    // Indigo
    static let categoryHealth = Color(hex: "#10B981")          // Mint
    static let categoryShopping = Color(hex: "#F59E0B")        // Gold
    static let categoryFood = Color(hex: "#EF4444")            // Red
    static let categoryEducation = Color(hex: "#8B5CF6")       // Violet
    static let categoryAiTools = Color(hex: "#0EA5E9")         // Sky Blue
    static let categoryUtilities = Color(hex: "#14B8A6")       // Teal
    static let categoryGaming = Color(hex: "#D946EF")          // Magenta
    static let categoryServices = Color(hex: "#2563EB")        // Royal Blue
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
