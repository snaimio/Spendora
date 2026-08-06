//
//  Color+App.swift
//

import SwiftUI

// MARK: - Color Extension

/**
 Extension on `Color` providing Spendora's DIRECTION A: "BOLD TEAL & CASH APP ENERGY" Signature Color System.
 Features Electric Teal (#00D4AA), Vibrant Coral (#FF6B6B), and Warm Gold (#FFD93D).
 */
extension Color {
    
    // MARK: - Signature Bold Teal Palette
    static let brandPrimary = Color(hex: "#00D4AA")      // Electric Bold Teal (Cash App Energy)
    static let brandSecondary = Color(hex: "#0EA5E9")    // Vibrant Sky Blue
    static let brandAccent = Color(hex: "#0EA5E9")       // Electric Cyan Accent
    static let brandTertiary = Color(hex: "#10B981")     // Emerald Mint
    static let brandCoral = Color(hex: "#FF6B6B")        // Vibrant Coral Alert
    static let brandGold = Color(hex: "#FFD93D")         // Warm Sunshine Gold
    static let brandPurple = Color(hex: "#8B5CF6")       // Electric Violet
    static let brandRose = Color(hex: "#F43F5E")         // Rose Red
    
    // MARK: - Urgency Countdown Status Colors
    static let statusUrgentRed = Color(hex: "#FF6B6B")   // Due Today / Overdue (Red)
    static let statusSoonAmber = Color(hex: "#FFD93D")   // Due ≤ 7 Days (Amber Gold)
    static let statusSafeGreen = Color(hex: "#00D4AA")   // Due > 30 Days (Teal Safe)
    
    // MARK: - Signature Gradient Meshes
    static let gradientHero = LinearGradient(
        colors: [Color(hex: "#00D4AA"), Color(hex: "#0EA5E9"), Color(hex: "#6366F1")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientTeal = LinearGradient(
        colors: [Color(hex: "#00D4AA"), Color(hex: "#10B981")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientCoral = LinearGradient(
        colors: [Color(hex: "#FF6B6B"), Color(hex: "#FFD93D")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientGold = LinearGradient(
        colors: [Color(hex: "#FFD93D"), Color(hex: "#F59E0B")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Adaptive High-Contrast Surfaces (Dark Space Charcoal & Crisp Light)
    static let appBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.04, green: 0.06, blue: 0.09, alpha: 1.0)     // Space Dark (#0B0F17)
            : UIColor(red: 0.97, green: 0.98, blue: 0.99, alpha: 1.0)     // Soft Slate (#F8FAFC)
    })
    
    static let cardBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.11, green: 0.14, blue: 0.20, alpha: 1.0)     // Elevated Slate Glass (#1C2433)
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
            : UIColor(red: 0.30, green: 0.36, blue: 0.45, alpha: 1.0)     // Slate (#475569)
    })
    
    static let textTertiary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.58, green: 0.64, blue: 0.72, alpha: 1.0)     // (#94A3B8)
            : UIColor(red: 0.45, green: 0.50, blue: 0.60, alpha: 1.0)
    })

    // MARK: - 10+ Category Colors
    static let categoryEntertainment = Color(hex: "#FF6B6B")   // Coral
    static let categoryProductivity = Color(hex: "#00D4AA")    // Electric Teal
    static let categoryHealth = Color(hex: "#10B981")          // Emerald Mint
    static let categoryShopping = Color(hex: "#FFD93D")        // Gold
    static let categoryFood = Color(hex: "#EF4444")            // Red
    static let categoryEducation = Color(hex: "#8B5CF6")       // Violet
    static let categoryAiTools = Color(hex: "#0EA5E9")         // Cyan
    static let categoryUtilities = Color(hex: "#14B8A6")       // Teal
    static let categoryGaming = Color(hex: "#D946EF")          // Magenta
    static let categoryServices = Color(hex: "#3B82F6")        // Royal Blue
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
