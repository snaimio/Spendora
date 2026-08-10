//
//  Color+App.swift
//  Spendora
//

import SwiftUI

// MARK: - 60-30-10 Warm Cream & Coral Fire Design Tokens

extension Color {
    
    // MARK: - Core 60-30-10 Brand Tokens
    static let brandPrimary = SpendoraTheme.Colors.coral
    static let brandSecondary = SpendoraTheme.Colors.danger
    static let brandAccent = SpendoraTheme.Colors.coralWarm
    static let brandSuccess = SpendoraTheme.Colors.success
    static let brandWarning = SpendoraTheme.Colors.warning
    static let brandDanger = SpendoraTheme.Colors.danger
    static let brandPurple = Color(hex: "#8B5CF6")
    static let brandCyan = Color(hex: "#06B6D4")
    static let brandGold = SpendoraTheme.Colors.warning
    static let brandAmber = SpendoraTheme.Colors.warning
    static let brandRose = SpendoraTheme.Colors.coral
    static let brandSlate = SpendoraTheme.Colors.textSecondary
    static let brandTertiary = SpendoraTheme.Colors.coralWarm

    // MARK: - Canvas & Surfaces
    static let appBackground = SpendoraTheme.Colors.canvas
    static let cardBackground = SpendoraTheme.Colors.card
    static let surfaceBackground = SpendoraTheme.Colors.card
    static let secondaryCardBackground = SpendoraTheme.Colors.coralTint
    static let cardBorder = SpendoraTheme.Colors.border

    // MARK: - Typography Hierarchy
    static let textPrimary = SpendoraTheme.Colors.textPrimary
    static let textSecondary = SpendoraTheme.Colors.textSecondary
    static let textTertiary = SpendoraTheme.Colors.textTertiary

    // MARK: - Category Colors
    static let categoryEntertainment = Color(hex: "#FF6B6B") // Coral
    static let categoryProductivity = Color(hex: "#00C9A7")   // Mint
    static let categoryHealth = Color(hex: "#FFB347")         // Warm Orange
    static let categoryShopping = Color(hex: "#FF8E53")       // Warm Coral
    static let categoryFood = Color(hex: "#FF4757")           // Vivid Red
    static let categoryEducation = Color(hex: "#8B5CF6")      // Purple
    static let categoryAiTools = Color(hex: "#06B6D4")        // Cyan
    static let categoryMusic = Color(hex: "#FF6B6B")          // Pink/Coral
    static let categoryGaming = Color(hex: "#7C3AED")         // Violet
    static let categoryUtilities = Color(hex: "#8A8A9A")      // Slate
    static let categoryOther = Color(hex: "#8A8A9A")          // Slate

    // MARK: - Gradients
    static let gradientPrimary = SpendoraTheme.Colors.coralGradient
    static let gradientHero = SpendoraTheme.Colors.heroGradient
    static let gradientSunset = LinearGradient(
        colors: [Color(hex: "#FF4757"), Color(hex: "#FFB347")],
        startPoint: .leading,
        endPoint: .trailing
    )

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

// MARK: - Ambient Brand Background & Luxury Card Modifiers

struct SpendoraBrandBackgroundView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            RadialGradient(
                colors: [
                    SpendoraTheme.Colors.coral.opacity(colorScheme == .dark ? 0.08 : 0.04),
                    Color.clear
                ],
                center: .topTrailing,
                startRadius: 10,
                endRadius: 420
            )
            .ignoresSafeArea()
        }
    }
}

struct SpendoraAppleCardModifier: ViewModifier {
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .modifier(SpendoraFintechCardModifier(cornerRadius: cornerRadius))
    }
}

extension View {
    func spendoraBrandBackground() -> some View {
        self.background(SpendoraBrandBackgroundView())
    }
    
    func spendora3DCard(cornerRadius: CGFloat = 16) -> some View {
        self.modifier(SpendoraAppleCardModifier(cornerRadius: cornerRadius))
    }
    
    func appleCard(cornerRadius: CGFloat = 16) -> some View {
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
