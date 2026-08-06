//
//  Color+App.swift
//

import SwiftUI

// MARK: - Color Extension

/**
 Extension on `Color` providing Apple's recognized HIG system color palette and Apple Wallet/Health design system.
 Fits both Crisp Light Mode and OLED Midnight Dark Mode.
 */
extension Color {
    
    // MARK: - Apple Recognized HIG System Colors
    static let brandPrimary = Color(hex: "#007AFF")      // Apple System Blue
    static let brandSecondary = Color(hex: "#5856D6")    // Apple System Indigo
    static let brandTertiary = Color(hex: "#34C759")     // Apple System Green
    static let brandAccent = Color(hex: "#5AC8FA")       // Apple System Light Blue
    static let brandRose = Color(hex: "#FF2D55")         // Apple System Pink/Red
    static let brandAmber = Color(hex: "#FF9500")        // Apple System Orange
    static let brandPurple = Color(hex: "#AF52DE")       // Apple System Purple
    
    // MARK: - Apple Signature Gradients (Wallet, Fitness, Music)
    static let gradientHero = LinearGradient(
        colors: [Color(hex: "#007AFF"), Color(hex: "#5856D6")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientPurple = LinearGradient(
        colors: [Color(hex: "#5856D6"), Color(hex: "#AF52DE")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientSunset = LinearGradient(
        colors: [Color(hex: "#FF2D55"), Color(hex: "#FF9500")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientOcean = LinearGradient(
        colors: [Color(hex: "#007AFF"), Color(hex: "#34C759")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientSunrise = LinearGradient(
        colors: [Color(hex: "#FF9500"), Color(hex: "#FF2D55")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientLavender = LinearGradient(
        colors: [Color(hex: "#AF52DE"), Color(hex: "#FF2D55")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientMint = LinearGradient(
        colors: [Color(hex: "#34C759"), Color(hex: "#5AC8FA")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientGlassCard = LinearGradient(
        colors: [Color.white.opacity(0.18), Color.white.opacity(0.06)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Apple Native UI Adaptive Surfaces
    static let appBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)        // Pure Apple OLED Black
            : UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)     // Apple Grouped Secondary System Background (#F2F2F7)
    })
    
    static let cardBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0)     // Apple Secondary System Fill (#1C1C1E)
            : UIColor.white
    })
    
    static let textPrimary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor.white
            : UIColor(red: 0.1, green: 0.1, blue: 0.12, alpha: 1.0)
    })
    
    static let textSecondary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.55, green: 0.55, blue: 0.57, alpha: 1.0)     // Apple System Secondary Label
            : UIColor(red: 0.44, green: 0.44, blue: 0.46, alpha: 1.0)
    })
    
    static let textTertiary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.38, green: 0.38, blue: 0.40, alpha: 1.0)
            : UIColor(red: 0.68, green: 0.68, blue: 0.70, alpha: 1.0)
    })
    
    // MARK: - Apple Category Colors
    static let categoryEntertainment = Color(hex: "#FF2D55")   // Apple Pink/Red
    static let categoryProductivity = Color(hex: "#007AFF")    // Apple Blue
    static let categoryHealth = Color(hex: "#34C759")          // Apple Green
    static let categoryShopping = Color(hex: "#FF9500")        // Apple Orange
    static let categoryFood = Color(hex: "#FF3B30")            // Apple Red
    static let categoryEducation = Color(hex: "#5856D6")       // Apple Indigo
    static let categoryAiTools = Color(hex: "#AF52DE")         // Apple Purple
    static let categoryUtilities = Color(hex: "#5AC8FA")       // Apple Teal/Light Blue
    static let categoryGaming = Color(hex: "#30B0C7")          // Apple Cyan
    static let categoryOther = Color(hex: "#8E8E93")           // Apple Gray
    
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
