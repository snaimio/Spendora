//
//  Color+App.swift
//

import SwiftUI

// MARK: - Color Extension

/**
 Extension on `Color` providing Spendora's Classic Apple System Color Palette.
 Features Apple System Blue (#007AFF), System Indigo (#5856D6), Muted Emerald (#10B981), and Soft Coral (#F43F5E).
 Guaranteed 100% eye-pleasing, comfortable contrast for long sessions in Light & Dark modes.
 */
extension Color {
    
    // MARK: - Classic Apple System Palette (Soft & Eye-Pleasing)
    static let brandPrimary = Color(hex: "#007AFF")      // Apple System Blue (Classic, comfortable)
    static let brandSecondary = Color(hex: "#5856D6")    // Apple System Indigo
    static let brandAccent = Color(hex: "#5AC8FA")       // Apple Light Blue
    static let brandTertiary = Color(hex: "#34C759")     // Apple System Green (Muted)
    static let brandCoral = Color(hex: "#FF3B30")        // Apple System Red
    static let brandGold = Color(hex: "#FF9500")         // Apple System Orange
    static let brandAmber = Color(hex: "#FF9500")        // Apple Amber
    static let brandPurple = Color(hex: "#AF52DE")       // Apple System Purple
    static let brandRose = Color(hex: "#FF2D55")         // Apple System Pink
    
    // MARK: - Status Colors
    static let statusUrgentRed = Color(hex: "#FF3B30")   // Apple Red
    static let statusSoonAmber = Color(hex: "#FF9500")   // Apple Orange
    static let statusSafeGreen = Color(hex: "#34C759")   // Apple Green
    
    // MARK: - Gradient Meshes (Soft & Subtle)
    static let gradientHero = LinearGradient(
        colors: [Color(hex: "#007AFF"), Color(hex: "#5856D6")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientTeal = LinearGradient(
        colors: [Color(hex: "#34C759"), Color(hex: "#00C7BE")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientCoral = LinearGradient(
        colors: [Color(hex: "#FF3B30"), Color(hex: "#FF9500")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientGold = LinearGradient(
        colors: [Color(hex: "#FF9500"), Color(hex: "#FFCC00")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Adaptive Surfaces (High-Contrast, Zero Eye Strain)
    
    /// Main Canvas: Soft Slate Dark (#0D1117) in Dark Mode, Pure Light (#F2F2F7) in Light Mode
    static let appBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.07, green: 0.08, blue: 0.10, alpha: 1.0)     // #12151B
            : UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)     // #F2F2F7
    })
    
    /// Card Container Background: Crisp Charcoal Card (#1C1C1E) in Dark Mode, Pure White in Light Mode
    static let cardBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0)     // #1C1C1E (Apple Dark Card)
            : UIColor.white
    })
    
    /// Primary Text: High-Contrast White (#FFFFFF) in Dark Mode, Dark Slate (#1C1C1E) in Light Mode
    static let textPrimary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor.white
            : UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0)
    })
    
    /// Secondary Text: Bright Crisp Slate (#E5E7EB) in Dark Mode, Slate Gray (#6C6C70) in Light Mode
    static let textSecondary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.90, green: 0.91, blue: 0.93, alpha: 1.0)     // #E5E7EB (100% legible)
            : UIColor(red: 0.42, green: 0.42, blue: 0.44, alpha: 1.0)
    })
    
    /// Tertiary Text: Soft Slate (#9CA3AF) in Dark Mode, Light Gray (#8E8E93) in Light Mode
    static let textTertiary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1.0)     // #9CA3AF
            : UIColor(red: 0.55, green: 0.55, blue: 0.57, alpha: 1.0)
    })

    // MARK: - 10+ Category Colors (Apple HIG Recognized)
    static let categoryEntertainment = Color(hex: "#FF2D55")   // Pink
    static let categoryProductivity = Color(hex: "#007AFF")    // Blue
    static let categoryHealth = Color(hex: "#34C759")          // Green
    static let categoryShopping = Color(hex: "#FF9500")        // Orange
    static let categoryFood = Color(hex: "#FF3B30")            // Red
    static let categoryEducation = Color(hex: "#AF52DE")       // Purple
    static let categoryAiTools = Color(hex: "#5AC8FA")         // Light Blue
    static let categoryUtilities = Color(hex: "#00C7BE")       // Teal
    static let categoryGaming = Color(hex: "#5856D6")          // Indigo
    static let categoryServices = Color(hex: "#007AFF")        // Blue
    static let categoryOther = Color(hex: "#8E8E93")           // Gray
    
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
