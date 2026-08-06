//
//  Color+App.swift
//  Spendora
//

import SwiftUI

// MARK: - Color Extension

/**
 Extension on `Color` providing Spendora's Signature Bold Teal (#00D4AA) Color System.
 Features Bold Teal, Coral (#FF6B6B), and Gold (#FFD93D) for maximum visual clarity.
 */
extension Color {
    
    // MARK: - Signature Colors (Viral Teal Theme)
    static let brandPrimary = Color(hex: "#00D4AA")      // Bold Teal - SIGNATURE COLOR
    static let brandSecondary = Color(hex: "#FF6B6B")    // Coral - Alerts & Actions
    static let brandTertiary = Color(hex: "#00D4AA")     // Mint/Teal Accent
    static let brandAccent = Color(hex: "#FFD93D")       // Gold - Highlights
    static let brandAmber = Color(hex: "#FFD93D")        // Amber Gold
    static let brandDark = Color(hex: "#0F0F1A")         // Deep Navy
    static let brandLight = Color(hex: "#F8F9FE")        // Light Lavender
    static let brandCard = Color(hex: "#FFFFFF")         // Pure White Cards
    static let brandPurple = Color(hex: "#6C5CE7")       // Purple Accent
    static let brandRose = Color(hex: "#FF6B6B")         // Rose Coral Accent
    
    // MARK: - Status Colors
    static let brandSuccess = Color(hex: "#00D4AA")      // Mint Green
    static let brandWarning = Color(hex: "#FFD93D")      // Amber
    static let brandDanger = Color(hex: "#FF6B6B")       // Coral Red
    
    // MARK: - Gradients
    static let gradientPrimary = LinearGradient(
        colors: [Color(hex: "#00D4AA"), Color(hex: "#00B4D8")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientSunset = LinearGradient(
        colors: [Color(hex: "#FF6B6B"), Color(hex: "#FFD93D")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientHero = LinearGradient(
        colors: [Color(hex: "#00D4AA"), Color(hex: "#00B4D8"), Color(hex: "#6C5CE7")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - UI Colors (Adaptive Light/Dark)
    static let appBackground = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#0F0F1A")
            : UIColor(hex: "#F8F9FE")
    })
    
    static let cardBackground = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#1A1A2E")
            : UIColor.white
    })
    
    static let textPrimary = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor.white
            : UIColor(hex: "#0F0F1A")
    })
    
    static let textSecondary = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#94A3B8")
            : UIColor(hex: "#64748B")
    })
    
    static let textTertiary = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#64748B")
            : UIColor(hex: "#94A3B8")
    })

    // MARK: - Category Colors
    static let categoryEntertainment = Color(hex: "#FF6B6B")
    static let categoryProductivity = Color(hex: "#00D4AA")
    static let categoryHealth = Color(hex: "#FFD93D")
    static let categoryShopping = Color(hex: "#FF8A5C")
    static let categoryFood = Color(hex: "#FF6B6B")
    static let categoryEducation = Color(hex: "#6C5CE7")
    static let categoryAiTools = Color(hex: "#00B4D8")
    static let categoryMusic = Color(hex: "#FF6B6B")
    static let categoryGaming = Color(hex: "#A29BFE")
    static let categoryUtilities = Color(hex: "#636E72")
    static let categoryOther = Color(hex: "#636E72")
    
    // MARK: - Helper
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        self.init(
            red: CGFloat((int >> 16) & 0xFF) / 255,
            green: CGFloat((int >> 8) & 0xFF) / 255,
            blue: CGFloat(int & 0xFF) / 255,
            alpha: 1
        )
    }
}
