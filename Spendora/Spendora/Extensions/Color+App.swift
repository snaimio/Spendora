//
//  Color+App.swift
//

import SwiftUI

// MARK: - Color Extension

/**
 Extension on `Color` providing a vibrant, industry-standard modern design system for Spendora.
 Fits both Crisp Light Mode and OLED Midnight Dark Mode.
 */
extension Color {
    
    // MARK: - Vibrant Brand Colors (Indigo, Violet & Emerald Palette)
    static let brandPrimary = Color(hex: "#6366F1")      // Vibrant Indigo
    static let brandSecondary = Color(hex: "#8B5CF6")    // Electric Violet
    static let brandTertiary = Color(hex: "#10B981")     // Emerald Mint
    static let brandAccent = Color(hex: "#0EA5E9")       // Electric Sky Blue
    static let brandRose = Color(hex: "#F43F5E")         // Coral Rose
    static let brandAmber = Color(hex: "#F59E0B")        // Electric Amber
    static let brandPurple = Color(hex: "#A855F7")       // Neon Purple
    
    // MARK: - Rich Premium Gradients
    static let gradientHero = LinearGradient(
        colors: [Color(hex: "#6366F1"), Color(hex: "#8B5CF6"), Color(hex: "#3B82F6")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientSunset = LinearGradient(
        colors: [Color(hex: "#F43F5E"), Color(hex: "#FB923C")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientOcean = LinearGradient(
        colors: [Color(hex: "#0EA5E9"), Color(hex: "#10B981")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientSunrise = LinearGradient(
        colors: [Color(hex: "#F59E0B"), Color(hex: "#F43F5E")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientLavender = LinearGradient(
        colors: [Color(hex: "#8B5CF6"), Color(hex: "#EC4899")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientMint = LinearGradient(
        colors: [Color(hex: "#10B981"), Color(hex: "#06B6D4")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientGlassCard = LinearGradient(
        colors: [Color.white.opacity(0.15), Color.white.opacity(0.05)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - UI Adaptive Surfaces (Crisp Light & OLED Midnight Dark)
    static let appBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.04, green: 0.05, blue: 0.08, alpha: 1.0) // OLED Midnight Obsidian (#0B0F15)
            : UIColor(red: 0.95, green: 0.96, blue: 0.98, alpha: 1.0) // Crisp Slate Mist (#F2F4F8)
    })
    
    static let cardBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.09, green: 0.11, blue: 0.16, alpha: 1.0) // Deep Glass Card (#171C28)
            : UIColor.white
    })
    
    static let textPrimary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor.white
            : UIColor(red: 0.09, green: 0.11, blue: 0.15, alpha: 1.0)
    })
    
    static let textSecondary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.68, green: 0.72, blue: 0.78, alpha: 1.0)
            : UIColor(red: 0.38, green: 0.42, blue: 0.48, alpha: 1.0)
    })
    
    static let textTertiary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.45, green: 0.49, blue: 0.55, alpha: 1.0)
            : UIColor(red: 0.65, green: 0.69, blue: 0.74, alpha: 1.0)
    })
    
    // MARK: - Category Vibrant Palette
    static let categoryEntertainment = Color(hex: "#EF4444")   // Vibrant Red
    static let categoryProductivity = Color(hex: "#6366F1")    // Indigo
    static let categoryHealth = Color(hex: "#10B981")          // Emerald Green
    static let categoryShopping = Color(hex: "#F59E0B")        // Electric Amber
    static let categoryFood = Color(hex: "#F43F5E")            // Coral Rose
    static let categoryEducation = Color(hex: "#3B82F6")       // Royal Blue
    static let categoryAiTools = Color(hex: "#8B5CF6")         // Neon Violet
    static let categoryUtilities = Color(hex: "#0EA5E9")       // Sky Blue
    static let categoryGaming = Color(hex: "#14B8A6")          // Teal
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
