//
//  Color+App.swift
//  Spendora
//

import SwiftUI

// MARK: - Obsidian Indigo & Fintech Luxury Palette

/**
 `Color` semantic extension providing Spendora's unified Revolut × Apple Wallet × Monzo design system:
 
 ### ☀️ Light Mode:
 - Primary: `#4F46E5` (Obsidian Indigo)
 - Primary Light: `#EEF2FF`
 - Primary Dark: `#3730A3`
 - Canvas Background: `#F8F9FC` (Warm Off-White)
 - Surface (Card): `#FFFFFF`
 - Surface Secondary: `#F1F3F9`
 - Text Primary: `#0F172A`
 - Text Secondary: `#64748B`
 - Text Tertiary: `#94A3B8`
 - Border / Hairline: `#E2E8F0`
 
 ### 🌙 Dark Mode:
 - Primary: `#6366F1` (Luminous Indigo)
 - Primary Light: `#1E1B4B`
 - Primary Dark: `#4338CA`
 - Canvas Background: `#0C0D12` (Tinted Obsidian)
 - Surface (Card): `#161822`
 - Surface Secondary: `#1F2232`
 - Text Primary: `#F8FAFC`
 - Text Secondary: `#94A3B8`
 - Text Tertiary: `#475569`
 - Border / Hairline: `#26293B`
 */
extension Color {
    
    // MARK: - Core Brand Tokens
    static let brandPrimary = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#6366F1")                     // Luminous Indigo in Dark
            : UIColor(hex: "#4F46E5")                     // Obsidian Indigo in Light
    })
    
    static let brandPrimaryLight = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#1E1B4B")
            : UIColor(hex: "#EEF2FF")
    })
    
    static let brandPrimaryDark = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#4338CA")
            : UIColor(hex: "#3730A3")
    })
    
    static let brandSecondary = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#F87171")
            : UIColor(hex: "#EF4444")
    })
    
    static let brandAccent = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#818CF8")
            : UIColor(hex: "#6366F1")
    })
    
    static let brandSuccess = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#34D399")
            : "#10B981".isEmpty ? UIColor.green : UIColor(hex: "#10B981")
    })
    
    static let brandWarning = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#FBBF24")
            : UIColor(hex: "#F59E0B")
    })
    
    static let brandDanger = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#F87171")
            : UIColor(hex: "#EF4444")
    })
    
    static let brandPurple = Color(hex: "#8B5CF6")
    static let brandCyan = Color(hex: "#06B6D4")
    static let brandGold = Color(hex: "#F59E0B")
    static let brandAmber = Color(hex: "#F59E0B")
    static let brandRose = Color(hex: "#EC4899")
    static let brandSlate = Color(hex: "#64748B")
    static let brandTertiary = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#818CF8")
            : UIColor(hex: "#6366F1")
    })

    // MARK: - Adaptive Canvas & Surfaces
    static let appBackground = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#0C0D12")                     // Tinted Obsidian in Dark
            : UIColor(hex: "#F8F9FC")                     // Warm Off-White in Light
    })
    
    static let cardBackground = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#161822")                     // Elevated Dark Surface
            : UIColor(hex: "#FFFFFF")                     // Pure White Card
    })
    
    static let surfaceBackground = cardBackground
    
    static let secondaryCardBackground = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#1F2232")                     // Nested Dark Container
            : UIColor(hex: "#F1F3F9")                     // Soft Secondary Surface
    })

    // MARK: - Typography Hierarchy
    static let textPrimary = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#F8FAFC")                     // Crisp White in Dark
            : UIColor(hex: "#0F172A")                     // Rich Midnight Slate in Light
    })
    
    static let textSecondary = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#94A3B8")                     // Muted Slate in Dark
            : UIColor(hex: "#64748B")                     // Refined Slate in Light
    })
    
    static let textTertiary = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#475569")
            : UIColor(hex: "#94A3B8")
    })

    static let cardBorder = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#26293B")
            : UIColor(hex: "#E2E8F0")
    })

    // MARK: - Category Colors (Fintech Clean Palette)
    static let categoryEntertainment = Color(hex: "#EC4899") // Pink
    static let categoryProductivity = Color(hex: "#4F46E5")   // Indigo
    static let categoryHealth = Color(hex: "#10B981")         // Emerald
    static let categoryShopping = Color(hex: "#F59E0B")       // Amber
    static let categoryFood = Color(hex: "#EF4444")           // Red
    static let categoryEducation = Color(hex: "#8B5CF6")      // Purple
    static let categoryAiTools = Color(hex: "#06B6D4")        // Cyan
    static let categoryMusic = Color(hex: "#6366F1")          // Violet
    static let categoryGaming = Color(hex: "#7C3AED")         // Deep Violet
    static let categoryUtilities = Color(hex: "#64748B")      // Slate
    static let categoryOther = Color(hex: "#64748B")          // Slate

    // MARK: - Gradients
    static let gradientPrimary = LinearGradient(
        colors: [Color(hex: "#4F46E5"), Color(hex: "#6366F1")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientHero = LinearGradient(
        colors: [Color(hex: "#4F46E5"), Color(hex: "#7C3AED"), Color(hex: "#EC4899")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let gradientSunset = LinearGradient(
        colors: [Color(hex: "#EF4444"), Color(hex: "#F59E0B")],
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
            
            // Subtle Indigo Ambient Glow (Top-Right)
            RadialGradient(
                colors: [
                    (colorScheme == .dark ? Color(hex: "#6366F1") : Color(hex: "#4F46E5"))
                        .opacity(colorScheme == .dark ? 0.08 : 0.04),
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
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(
                color: (colorScheme == .dark ? Color.black : Color(hex: "#0F172A"))
                    .opacity(colorScheme == .dark ? 0.35 : 0.04),
                radius: colorScheme == .dark ? 12 : 10,
                x: 0,
                y: colorScheme == .dark ? 6 : 4
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        Color.cardBorder,
                        lineWidth: colorScheme == .dark ? 1.0 : 0.5
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
