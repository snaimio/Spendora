//
//  Color+App.swift
//

import SwiftUI


// MARK: - Color Extension

/**
 Extension on `Color` providing utility methods and helpers.
 */
extension Color {
    
    // MARK: - Brand Colors (Sunset & Ocean Theme)
    static let brandPrimary = Color(hex: "#FF6B6B")      // Coral Red
    static let brandSecondary = Color(hex: "#FF9A9E")    // Soft Pink
    static let brandTertiary = Color(hex: "#4ECDC4")     // Mint Green
    static let brandAccent = Color(hex: "#FFE66D")       // Sunshine Yellow
    static let brandPurple = Color(hex: "#A29BFE")       // Lavender
    
    // MARK: - Gradients
    static let gradientSunset = LinearGradient(
        colors: [Color(hex: "#FF6B6B"), Color(hex: "#FFE66D")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientOcean = LinearGradient(
        colors: [Color(hex: "#4ECDC4"), Color(hex: "#45B7D1")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientSunrise = LinearGradient(
        colors: [Color(hex: "#FF9A9E"), Color(hex: "#FAD0C4")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientLavender = LinearGradient(
        colors: [Color(hex: "#A29BFE"), Color(hex: "#D4A5FF")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientMint = LinearGradient(
        colors: [Color(hex: "#4ECDC4"), Color(hex: "#A8E6CF")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientSunsetOcean = LinearGradient(
        colors: [Color(hex: "#FF6B6B"), Color(hex: "#4ECDC4")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - UI Colors (Adaptive Light & Dark Mode)
    static let appBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.04, green: 0.05, blue: 0.07, alpha: 1.0) // Rich OLED Midnight (#0B0D11)
            : UIColor(red: 0.99, green: 0.97, blue: 0.94, alpha: 1.0)
    })
    
    static let cardBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.10, green: 0.11, blue: 0.14, alpha: 1.0) // Deep Dark Elevation (#1A1C24)
            : UIColor.white
    })
    
    static let textPrimary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor.white
            : UIColor(red: 0.17, green: 0.20, blue: 0.21, alpha: 1.0)
    })
    
    static let textSecondary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.72, green: 0.76, blue: 0.80, alpha: 1.0)
            : UIColor(red: 0.39, green: 0.43, blue: 0.45, alpha: 1.0)
    })
    
    static let textTertiary = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.48, green: 0.52, blue: 0.56, alpha: 1.0)
            : UIColor(red: 0.70, green: 0.74, blue: 0.76, alpha: 1.0)
    })
    
    // MARK: - Category Colors (Vibrant & Fun)
    static let categoryEntertainment = Color(hex: "#FF6B6B")   // Coral
    static let categoryProductivity = Color(hex: "#4ECDC4")    // Mint
    static let categoryHealth = Color(hex: "#FF9A9E")          // Soft Pink
    static let categoryShopping = Color(hex: "#FFE66D")        // Yellow
    static let categoryFood = Color(hex: "#FF8A5C")            // Orange
    static let categoryEducation = Color(hex: "#A29BFE")       // Lavender
    static let categoryOther = Color(hex: "#B2BEC3")           // Gray
    
    // MARK: - Helper
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0  // int property
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
