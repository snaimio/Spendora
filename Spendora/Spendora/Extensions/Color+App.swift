//
//  Color+App.swift
//  Spendora
//

import SwiftUI

// MARK: - Apple Fintech Semantic Color System

/**
 `Color` semantic extension providing Apple's native design philosophy:
 - Primary Brand: `#007AFF` (Apple System Blue - Trust, Security, Professionalism)
 - Success / Wealth: `#34C759` (Apple System Green - Growth, Active Status)
 - Accent / Urgency: `#FF3B30` (Apple System Red / Coral - Due Today, Overdue, Cancelled)
 - Warning / Attention: `#FF9500` (Apple System Orange / Gold - Due Soon, Trials)
 - Surfaces: `#FFFFFF` Light / `#000000` True OLED Black Dark
 - Cards: `#FFFFFF` Light / `#1C1C1E` Apple Elevated Secondary Grouped Surface Dark
 */
extension Color {
    
    // MARK: - Core Apple Fintech Tokens
    static let brandPrimary = Color(hex: "#007AFF")       // Apple System Blue
    static let brandSecondary = Color(hex: "#FF3B30")     // Apple System Coral/Red
    static let brandAccent = Color(hex: "#FF9500")        // Apple System Orange/Amber
    static let brandSuccess = Color(hex: "#34C759")       // Apple System Green
    static let brandWarning = Color(hex: "#FF9500")       // Apple System Orange
    static let brandDanger = Color(hex: "#FF3B30")        // Apple System Red
    static let brandPurple = Color(hex: "#5856D6")        // Apple System Indigo/Purple
    static let brandCyan = Color(hex: "#32ADE6")          // Apple System Cyan
    static let brandTertiary = Color(hex: "#32ADE6")
    static let brandAmber = Color(hex: "#FF9500")
    static let brandRose = Color(hex: "#FF2D55")

    // MARK: - Adaptive Canvas & Surfaces (Apple System Standards)
    static let appBackground = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#000000")                     // OLED Pure Black
            : UIColor(hex: "#F2F2F7")                     // Apple System Grouped Background
    })
    
    static let cardBackground = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#1C1C1E")                     // Apple Secondary Grouped Background
            : UIColor.white                               // Crisp Pure White
    })
    
    static let surfaceBackground = cardBackground
    
    static let secondaryCardBackground = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#2C2C2E")                     // Tertiary Grouped Background
            : UIColor(hex: "#F2F2F7")
    })

    // MARK: - Typography Hierarchy (Apple High-Contrast)
    static let textPrimary = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor.white
            : UIColor(hex: "#000000")
    })
    
    static let textSecondary = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#8E8E93")
            : UIColor(hex: "#6C6C70")
    })
    
    static let textTertiary = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#48484A")
            : UIColor(hex: "#AEAEB2")
    })

    // MARK: - Apple Category Colors
    static let categoryEntertainment = Color(hex: "#FF2D55") // Apple Pink
    static let categoryProductivity = Color(hex: "#007AFF")   // Apple Blue
    static let categoryHealth = Color(hex: "#34C759")         // Apple Green
    static let categoryShopping = Color(hex: "#FF9500")       // Apple Orange
    static let categoryFood = Color(hex: "#FF3B30")           // Apple Red
    static let categoryEducation = Color(hex: "#5856D6")      // Apple Indigo
    static let categoryAiTools = Color(hex: "#32ADE6")        // Apple Cyan
    static let categoryMusic = Color(hex: "#AF52DE")          // Apple Purple
    static let categoryGaming = Color(hex: "#5E5CE6")         // Apple Violet
    static let categoryUtilities = Color(hex: "#8E8E93")      // Apple Gray
    static let categoryOther = Color(hex: "#8E8E93")          // Apple Gray

    // MARK: - Apple Subtle Gradients
    static let gradientPrimary = LinearGradient(
        colors: [Color(hex: "#007AFF"), Color(hex: "#5856D6")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientHero = LinearGradient(
        colors: [Color(hex: "#007AFF"), Color(hex: "#32ADE6"), Color(hex: "#5856D6")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let gradientSunset = LinearGradient(
        colors: [Color(hex: "#FF9500"), Color(hex: "#FF3B30")],
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

// MARK: - Apple Card & Background Modifiers

struct SpendoraBrandBackgroundView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Color.appBackground
            .ignoresSafeArea()
    }
}

struct SpendoraAppleCardModifier: ViewModifier {
    let cornerRadius: CGFloat
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            // Subtle Apple-level shadow
            .shadow(
                color: Color.black.opacity(colorScheme == .dark ? 0.35 : 0.04),
                radius: colorScheme == .dark ? 8 : 6,
                x: 0,
                y: colorScheme == .dark ? 3 : 2
            )
            // Precise hairline border
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        colorScheme == .dark
                            ? Color.white.opacity(0.08)
                            : Color.black.opacity(0.04),
                        lineWidth: 0.5
                    )
            )
    }
}

extension View {
    func spendoraBrandBackground() -> some View {
        self.background(SpendoraBrandBackgroundView())
    }
    
    func spendora3DCard(cornerRadius: CGFloat = 16) -> some View {
        self.modifier(SpendoraAppleCardModifier(cornerRadius: cornerRadius))
    }
    
    func appleCard(cornerRadius: CGFloat = 14) -> some View {
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
