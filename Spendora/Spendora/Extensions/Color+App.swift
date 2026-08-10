//
//  Color+App.swift
//  Spendora
//

import SwiftUI

// MARK: - Slate & Rose-Gold Metallic Luxury Palette (Apple HIG & OLED Dark Architecture)

/**
 `Color` semantic extension providing Spendora's unified luxury dark-mode architecture:
 - Canvas Background: Deep matte charcoal black `#0E0E10` (OLED Depth, no generic white/flat surfaces).
 - Card Containers: Elevated translucent dark cards `#1C1C1E` with subtle glassmorphic blur, 18pt continuous corner radius, and 1px border stroke `#2C2C2E`.
 - Primary Accent: Warm Champagne Gold / Rose-Gold `#C6A473` for active controls, active chips, and primary CTAs.
 - Functional Colors: System Red `#FF453A` (urgency/cancellations) and System Green `#30D158` (savings/active status).
 - Typography: Primary `#FFFFFF` (Crisp White) and Secondary `#8E8E93` (Muted Slate Grey).
 */
extension Color {
    
    // MARK: - Core Rose-Gold & Slate Luxury Tokens
    static let brandPrimary = Color(hex: "#C6A473")       // Warm Champagne Gold / Rose-Gold (SIGNATURE ACCENT)
    static let brandSecondary = Color(hex: "#FF453A")     // Apple System Red / Urgent Action
    static let brandAccent = Color(hex: "#DFCAA6")        // Soft Champagne Highlight
    static let brandSuccess = Color(hex: "#30D158")       // Apple System Green / Active Status
    static let brandWarning = Color(hex: "#FF9F0A")       // Apple System Amber / Warning
    static let brandDanger = Color(hex: "#FF453A")        // Apple System Red
    static let brandPurple = Color(hex: "#BF5AF2")        // Apple System Purple
    static let brandCyan = Color(hex: "#64D2FF")          // Apple System Cyan
    static let brandTertiary = Color(hex: "#DFCAA6")
    static let brandAmber = Color(hex: "#FF9F0A")
    static let brandRose = Color(hex: "#FF375F")
    static let brandGold = Color(hex: "#C6A473")
    static let brandSlate = Color(hex: "#8E8E93")

    // MARK: - Adaptive Canvas & Surfaces (OLED Deep Charcoal #0E0E10)
    static let appBackground = Color(UIColor { trait in
        trait.userInterfaceStyle == .light
            ? UIColor(hex: "#141416")                     // Refined Deep Slate in Light
            : UIColor(hex: "#0E0E10")                     // OLED Pure Charcoal Black in Dark
    })
    
    static let cardBackground = Color(UIColor { trait in
        trait.userInterfaceStyle == .light
            ? UIColor(hex: "#1F1F23")                     // Elevated Dark Card
            : UIColor(hex: "#1C1C1E")                     // Elevated Translucent Card
    })
    
    static let surfaceBackground = cardBackground
    
    static let secondaryCardBackground = Color(UIColor { trait in
        trait.userInterfaceStyle == .light
            ? UIColor(hex: "#28282D")
            : UIColor(hex: "#2C2C2E")                     // Secondary Grouped Card
    })

    // MARK: - Typography Hierarchy (Apple High-Contrast White & Slate)
    static let textPrimary = Color(UIColor { trait in
        trait.userInterfaceStyle == .light
            ? UIColor(hex: "#FFFFFF")                     // Crisp White
            : UIColor(hex: "#FFFFFF")
    })
    
    static let textSecondary = Color(UIColor { trait in
        trait.userInterfaceStyle == .light
            ? UIColor(hex: "#9E9EA3")
            : UIColor(hex: "#8E8E93")                     // Muted Slate Grey
    })
    
    static let textTertiary = Color(UIColor { trait in
        trait.userInterfaceStyle == .light
            ? UIColor(hex: "#636366")
            : UIColor(hex: "#636366")
    })

    // MARK: - Category Colors (Refined Luxury Metallic Palette)
    static let categoryEntertainment = Color(hex: "#FF375F") // Rose Red
    static let categoryProductivity = Color(hex: "#C6A473")   // Rose Gold
    static let categoryHealth = Color(hex: "#30D158")         // Emerald Green
    static let categoryShopping = Color(hex: "#FF9F0A")       // Amber Gold
    static let categoryFood = Color(hex: "#FF453A")           // Crimson Red
    static let categoryEducation = Color(hex: "#BF5AF2")      // Purple
    static let categoryAiTools = Color(hex: "#64D2FF")        // Cyan
    static let categoryMusic = Color(hex: "#C6A473")          // Champagne Gold
    static let categoryGaming = Color(hex: "#5E5CE6")         // Violet
    static let categoryUtilities = Color(hex: "#8E8E93")      // Slate
    static let categoryOther = Color(hex: "#8E8E93")          // Slate

    // MARK: - Luxury Gradients
    static let gradientPrimary = LinearGradient(
        colors: [Color(hex: "#C6A473"), Color(hex: "#DFCAA6")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientHero = LinearGradient(
        colors: [Color(hex: "#C6A473"), Color(hex: "#E5D2B8"), Color(hex: "#A88452")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let gradientSunset = LinearGradient(
        colors: [Color(hex: "#FF453A"), Color(hex: "#C6A473")],
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

// MARK: - Ambient Brand Background & Luxury Glass Card Modifiers

struct SpendoraBrandBackgroundView: View {
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            // Subtle Warm Rose-Gold Ambient Glow (Top-Right)
            RadialGradient(
                colors: [Color(hex: "#C6A473").opacity(0.08), Color.clear],
                center: .topTrailing,
                startRadius: 10,
                endRadius: 400
            )
            .ignoresSafeArea()
        }
    }
}

struct SpendoraAppleCardModifier: ViewModifier {
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            // Subtle luxury shadow
            .shadow(
                color: Color.black.opacity(0.40),
                radius: 8,
                x: 0,
                y: 4
            )
            // Crisp 1px border stroke (#2C2C2E)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color(hex: "#2C2C2E"), lineWidth: 1.0)
            )
    }
}

extension View {
    func spendoraBrandBackground() -> some View {
        self.background(SpendoraBrandBackgroundView())
    }
    
    func spendora3DCard(cornerRadius: CGFloat = 18) -> some View {
        self.modifier(SpendoraAppleCardModifier(cornerRadius: cornerRadius))
    }
    
    func appleCard(cornerRadius: CGFloat = 18) -> some View {
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
