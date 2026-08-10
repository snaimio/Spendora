//
//  Color+App.swift
//  Spendora
//

import SwiftUI

// MARK: - Semantic Color System (60-30-10 Color Strategy)

/**
 `Color` semantic extension providing Spendora's 60-30-10 color psychology system:
 - 60% Dominant: `appBackground` (#FFFFFF Light / #0F0F1A Dark)
 - 30% Secondary: `cardBackground` (#F8F9FE Light / #1E293B Dark) + Typography hierarchy
 - 10% Accent: `brandPrimary` (#00D4AA Teal), `brandSecondary` (#FF6B6B Coral), `brandAccent` (#FFD93D Gold)
 */
extension Color {
    
    // MARK: - 10% Accent Colors (Purpose-Driven Semantic Tokens)
    static let brandPrimary = Color(hex: "#00D4AA")      // Primary Actions, CTAs, Success (Vibrant Teal)
    static let brandSecondary = Color(hex: "#FF6B6B")    // Secondary Actions, Prices, Urgency, Danger (Coral)
    static let brandAccent = Color(hex: "#FFD93D")       // Highlights, Badges, Warnings, Spotlight (Gold)
    static let brandTertiary = Color(hex: "#00B4D8")     // Cyan gradient stop
    static let brandPurple = Color(hex: "#6C5CE7")       // Royal Purple gradient stop
    static let brandAmber = Color(hex: "#FFD93D")        // Gold / Amber
    static let brandRose = Color(hex: "#FF6B6B")         // Coral Red
    
    // MARK: - Status Colors
    static let brandSuccess = Color(hex: "#00D4AA")      // Success Confirmation (Teal)
    static let brandWarning = Color(hex: "#FFD93D")      // Warning / Attention (Gold)
    static let brandDanger = Color(hex: "#FF6B6B")       // Danger / Overdue (Coral)

    // MARK: - 60% Dominant & 30% Secondary Canvas & Structure (Adaptive Light/Dark)
    static let appBackground = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#0F0F1A")
            : UIColor(hex: "#FFFFFF")
    })
    
    static let cardBackground = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#1E293B")
            : UIColor(hex: "#F8F9FE")
    })
    
    static let surfaceBackground = cardBackground

    // MARK: - Typography Hierarchy Tokens (Apple HIG High Contrast)
    static let textPrimary = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor.white
            : UIColor(hex: "#1A1A2E")
    })
    
    static let textSecondary = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#CBD5E1")
            : UIColor(hex: "#64748B")
    })
    
    static let textTertiary = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#94A3B8")
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

    // MARK: - Modern Gradients
    static let gradientPrimary = LinearGradient(
        colors: [Color(hex: "#00D4AA"), Color(hex: "#00B4D8")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientHero = LinearGradient(
        colors: [Color(hex: "#00D4AA"), Color(hex: "#00B4D8"), Color(hex: "#6C5CE7")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let gradientSunset = LinearGradient(
        colors: [Color(hex: "#FF6B6B"), Color(hex: "#FFD93D")],
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

// MARK: - Ambient Brand Background & 3D Specular Modifiers

struct SpendoraBrandBackgroundView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            // 3D Ambient Glowing Spendora Teal Orb (Top-Right)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "#00D4AA").opacity(colorScheme == .dark ? 0.18 : 0.08), Color.clear],
                        center: .center,
                        startRadius: 10,
                        endRadius: 260
                    )
                )
                .frame(width: 340, height: 340)
                .offset(x: 130, y: -190)
                .blur(radius: 20)
            
            // 3D Ambient Glowing Coral Orb (Bottom-Left)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "#FF6B6B").opacity(colorScheme == .dark ? 0.12 : 0.06), Color.clear],
                        center: .center,
                        startRadius: 10,
                        endRadius: 280
                    )
                )
                .frame(width: 360, height: 360)
                .offset(x: -150, y: 240)
                .blur(radius: 25)
        }
    }
}

struct Spendora3DCardModifier: ViewModifier {
    let cornerRadius: CGFloat
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .background(Color.cardBackground)
            .cornerRadius(cornerRadius)
            // Elevation 2 Multi-Layered Drop Shadow
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.22 : 0.05), radius: 10, x: 0, y: 4)
            .shadow(color: Color(hex: "#00D4AA").opacity(colorScheme == .dark ? 0.10 : 0.03), radius: 3, x: 0, y: 1)
            // Bevel Stroke
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color(hex: "#00D4AA").opacity(colorScheme == .dark ? 0.4 : 0.18),
                                Color.white.opacity(colorScheme == .dark ? 0.08 : 0.4)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.0
                    )
            )
    }
}

extension View {
    func spendoraBrandBackground() -> some View {
        self.background(SpendoraBrandBackgroundView())
    }
    
    func spendora3DCard(cornerRadius: CGFloat = 16) -> some View {
        self.modifier(Spendora3DCardModifier(cornerRadius: cornerRadius))
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
