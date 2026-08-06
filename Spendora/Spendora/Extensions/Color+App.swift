//
//  Color+App.swift
//

import SwiftUI

// MARK: - Color Extension

/**
 Extension on `Color` providing Spendora's DIRECTION A: "GLASSMORPHISM + AURORA" Design System.
 Features frosted glass surfaces, aurora gradient meshes, high-contrast dark space & crisp light themes.
 */
extension Color {
    
    // MARK: - Aurora Brand Colors
    static let brandPrimary = Color(hex: "#6366F1")      // Royal Indigo
    static let brandSecondary = Color(hex: "#8B5CF6")    // Electric Violet
    static let brandTertiary = Color(hex: "#10B981")     // Emerald Mint
    static let brandAccent = Color(hex: "#0EA5E9")       // Neon Cyan
    static let brandRose = Color(hex: "#F43F5E")         // Coral Rose
    static let brandAmber = Color(hex: "#F59E0B")        // Warm Amber
    static let brandPurple = Color(hex: "#D946EF")       // Bright Magenta
    
    // MARK: - Status Colors
    static let statusSuccess = Color(hex: "#10B981")     // Emerald Green
    static let statusWarning = Color(hex: "#F59E0B")     // Warm Gold
    static let statusDanger = Color(hex: "#F43F5E")      // Coral Red
    
    // MARK: - Aurora Gradient Meshes
    static let gradientAurora = LinearGradient(
        colors: [Color(hex: "#6366F1"), Color(hex: "#8B5CF6"), Color(hex: "#0EA5E9")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientSunset = LinearGradient(
        colors: [Color(hex: "#F43F5E"), Color(hex: "#F59E0B")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientEmerald = LinearGradient(
        colors: [Color(hex: "#10B981"), Color(hex: "#14B8A6")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientNeonPurple = LinearGradient(
        colors: [Color(hex: "#8B5CF6"), Color(hex: "#D946EF")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Glassmorphism Surfaces (Space Charcoal & Crisp Light)
    static let appBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.04, green: 0.05, blue: 0.08, alpha: 1.0)     // Space Dark Navy (#0B0F15)
            : UIColor(red: 0.96, green: 0.97, blue: 0.99, alpha: 1.0)     // Crisp Soft Slate (#F5F7FA)
    })
    
    static let cardBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.11, green: 0.14, blue: 0.20, alpha: 1.0)     // Elevated Glass Slate (#1C2433)
            : UIColor.white
    })
    
    static let textPrimary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor.white
            : UIColor(red: 0.08, green: 0.11, blue: 0.18, alpha: 1.0)     // Dark Charcoal (#141C2E)
    })
    
    static let textSecondary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.80, green: 0.84, blue: 0.90, alpha: 1.0)     // Crisp Visible Slate (#CBD5E1)
            : UIColor(red: 0.30, green: 0.36, blue: 0.45, alpha: 1.0)     // Dark Slate (#475569)
    })
    
    static let textTertiary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.58, green: 0.64, blue: 0.72, alpha: 1.0)     // (#94A3B8)
            : UIColor(red: 0.45, green: 0.50, blue: 0.60, alpha: 1.0)
    })

    // MARK: - 10+ Category Colors
    static let categoryEntertainment = Color(hex: "#F43F5E")   // Coral Rose
    static let categoryProductivity = Color(hex: "#6366F1")    // Royal Indigo
    static let categoryHealth = Color(hex: "#10B981")          // Emerald Mint
    static let categoryShopping = Color(hex: "#F59E0B")        // Warm Amber
    static let categoryFood = Color(hex: "#EF4444")            // Red
    static let categoryEducation = Color(hex: "#8B5CF6")       // Electric Violet
    static let categoryAiTools = Color(hex: "#0EA5E9")         // Neon Cyan
    static let categoryUtilities = Color(hex: "#14B8A6")       // Bright Teal
    static let categoryGaming = Color(hex: "#D946EF")          // Bright Magenta
    static let categoryServices = Color(hex: "#3B82F6")        // Royal Blue
    static let categoryOther = Color(hex: "#64748B")           // Slate Gray
    
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
