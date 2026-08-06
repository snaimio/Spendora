//
//  Color+App.swift
//

import SwiftUI

// MARK: - Color Extension

/**
 Extension on `Color` providing Spendora's Clean Modern Fintech Design System.
 Features Deep Navy (#0F172A), Royal Blue (#2563EB), Mint Green (#10B981), and Coral Rose (#F43F5E).
 */
extension Color {
    
    // MARK: - Clean Modern Fintech Brand Palette
    static let brandPrimary = Color(hex: "#0F172A")      // Deep Navy
    static let brandSecondary = Color(hex: "#2563EB")    // Royal Blue
    static let brandTertiary = Color(hex: "#10B981")     // Mint Green
    static let brandAccent = Color(hex: "#38BDF8")       // Electric Sky Blue
    static let brandRose = Color(hex: "#F43F5E")         // Coral Rose
    static let brandAmber = Color(hex: "#F59E0B")        // Amber Gold
    static let brandPurple = Color(hex: "#7C3AED")       // Deep Purple
    
    // MARK: - Fintech Gradient Meshes
    static let gradientHero = LinearGradient(
        colors: [Color(hex: "#0F172A"), Color(hex: "#1E293B"), Color(hex: "#2563EB")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientRoyal = LinearGradient(
        colors: [Color(hex: "#2563EB"), Color(hex: "#38BDF8")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientMint = LinearGradient(
        colors: [Color(hex: "#10B981"), Color(hex: "#059669")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientCoral = LinearGradient(
        colors: [Color(hex: "#F43F5E"), Color(hex: "#FB923C")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientPurple = LinearGradient(
        colors: [Color(hex: "#7C3AED"), Color(hex: "#C084FC")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientGlassCard = LinearGradient(
        colors: [Color.white.opacity(0.18), Color.white.opacity(0.06)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Adaptive Surfaces (Pure White/Slate Mist & OLED Dark Navy)
    static let appBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.05, green: 0.07, blue: 0.09, alpha: 1.0)     // Dark Charcoal Navy (#0D1117)
            : UIColor(red: 0.97, green: 0.98, blue: 0.99, alpha: 1.0)     // Light Slate White (#F8FAFC)
    })
    
    static let cardBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.1, green: 0.12, blue: 0.16, alpha: 1.0)      // Slate Glass Card (#1A202C)
            : UIColor.white
    })
    
    static let textPrimary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor.white
            : UIColor(red: 0.12, green: 0.16, blue: 0.23, alpha: 1.0)     // Dark Slate (#1E293B)
    })
    
    static let textSecondary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.58, green: 0.64, blue: 0.72, alpha: 1.0)     // Slate Gray (#94A3B8)
            : UIColor(red: 0.39, green: 0.45, blue: 0.55, alpha: 1.0)     // Dark Slate Secondary (#64748B)
    })
    
    static let textTertiary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.38, green: 0.44, blue: 0.52, alpha: 1.0)
            : UIColor(red: 0.58, green: 0.64, blue: 0.72, alpha: 1.0)
    })
    
    // MARK: - Category Colors
    static let categoryEntertainment = Color(hex: "#F43F5E")   // Coral Rose
    static let categoryProductivity = Color(hex: "#2563EB")    // Royal Blue
    static let categoryHealth = Color(hex: "#10B981")          // Mint Green
    static let categoryShopping = Color(hex: "#F59E0B")        // Amber Gold
    static let categoryFood = Color(hex: "#EF4444")            // Red
    static let categoryEducation = Color(hex: "#7C3AED")       // Deep Purple
    static let categoryAiTools = Color(hex: "#0EA5E9")         // Sky Blue
    static let categoryUtilities = Color(hex: "#64748B")       // Slate Gray
    static let categoryGaming = Color(hex: "#8B5CF6")          // Violet
    static let categoryOther = Color(hex: "#475569")           // Dark Slate
    
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
