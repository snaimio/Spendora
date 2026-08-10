//
//  Color+App.swift
//  Spendora
//

import SwiftUI

// MARK: - Apple Semantic System Tokens & Emerald Accent

extension Color {
    
    // MARK: - Core Accent Tokens
    static let brandPrimary = SpendoraTheme.accent
    static let brandSecondary = Color(.systemRed)
    static let brandAccent = SpendoraTheme.accent
    static let brandSuccess = Color(.systemGreen)
    static let brandWarning = Color(.systemOrange)
    static let brandDanger = Color(.systemRed)
    static let brandPurple = Color(.systemPurple)
    static let brandCyan = Color(.systemCyan)
    static let brandGold = Color(.systemYellow)
    static let brandAmber = Color(.systemOrange)
    static let brandRose = Color(.systemPink)
    static let brandSlate = Color(.secondaryLabel)
    static let brandTertiary = SpendoraTheme.accentText

    // MARK: - Canvas & Surfaces (Apple Semantic Hierarchy)
    static let appBackground = Color(.systemBackground)
    static let cardBackground = Color(.secondarySystemBackground)
    static let surfaceBackground = Color(.secondarySystemBackground)
    static let secondaryCardBackground = Color(.tertiarySystemBackground)
    static let cardBorder = Color(.separator).opacity(0.6)

    // MARK: - Typography Hierarchy
    static let textPrimary = Color(.label)
    static let textSecondary = Color(.secondaryLabel)
    static let textTertiary = Color(.tertiaryLabel)

    // MARK: - Category Colors (Apple System Palette)
    static let categoryEntertainment = Color(.systemPink)
    static let categoryProductivity = SpendoraTheme.accent
    static let categoryHealth = Color(.systemGreen)
    static let categoryShopping = Color(.systemOrange)
    static let categoryFood = Color(.systemRed)
    static let categoryEducation = Color(.systemIndigo)
    static let categoryAiTools = Color(.systemCyan)
    static let categoryMusic = Color(.systemPurple)
    static let categoryGaming = Color(.systemBlue)
    static let categoryUtilities = Color(.secondaryLabel)
    static let categoryOther = Color(.secondaryLabel)

    // MARK: - Gradients (Subtle Only)
    static let gradientPrimary = LinearGradient(
        colors: [SpendoraTheme.accent, SpendoraTheme.accent],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let gradientHero = gradientPrimary
    static let gradientSunset = gradientPrimary

    // MARK: - Hex Initializer Helper
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

struct SpendoraBrandBackgroundView: View {
    var body: some View {
        Color(.systemBackground)
            .ignoresSafeArea()
    }
}

extension View {
    func spendoraBrandBackground() -> some View {
        self.background(SpendoraBrandBackgroundView())
    }
    
    func spendora3DCard(cornerRadius: CGFloat = 12) -> some View {
        self.modifier(SpendoraAppleCardModifier(cornerRadius: cornerRadius))
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
