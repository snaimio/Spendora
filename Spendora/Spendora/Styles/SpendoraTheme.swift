//
//  SpendoraTheme.swift
//  Spendora
//

import SwiftUI

// MARK: - SpendoraTheme (60-30-10 Warm Cream & Coral Fire Design System)

public struct SpendoraTheme {

    // MARK: - Colors (60-30-10 Architecture)
    public struct Colors {
        // 60% — Canvas Background
        public static let canvasLight = Color(hex: "#FFFBF5")
        public static let canvasDark = Color(hex: "#0F0E17")
        public static let canvas = Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(hex: "#0F0E17") : UIColor(hex: "#FFFBF5")
        })

        // 30% — Surfaces
        public static let cardLight = Color(hex: "#FFFFFF")
        public static let cardDark = Color(hex: "#1C1B29")
        public static let cardElevatedDark = Color(hex: "#242336")
        public static let card = Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(hex: "#1C1B29") : UIColor(hex: "#FFFFFF")
        })
        public static let cardElevated = Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(hex: "#242336") : UIColor(hex: "#FFFFFF")
        })
        
        // Borders & Dividers
        public static let borderLight = Color(hex: "#F0EBE3")
        public static let borderDark = Color(hex: "#2A2838")
        public static let border = Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(hex: "#2A2838") : UIColor(hex: "#F0EBE3")
        })

        // Typography
        public static let textPrimary = Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(hex: "#F5F0E8") : UIColor(hex: "#1A1A2E")
        })
        public static let textSecondary = Color(hex: "#8A8A9A")
        public static let textTertiary = Color(hex: "#A0A0B0")

        // 10% — Coral Fire Accent
        public static let coral = Color(hex: "#FF6B6B")
        public static let coralDeep = Color(hex: "#E85555")
        public static let coralWarm = Color(hex: "#FF8E53")
        public static let coralTint = Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(hex: "#2C1E26") : UIColor(hex: "#FFF0EE")
        })
        public static let chevron = Color(hex: "#FFB3A7")

        // Semantic Accents
        public static let success = Color(hex: "#00C9A7")     // Mint
        public static let warning = Color(hex: "#FFB347")     // Warm Orange
        public static let danger = Color(hex: "#FF4757")      // Vivid Red
        public static let cancelled = Color(hex: "#A0A0B0")   // Muted Slate

        // Gradients
        public static let coralGradient = LinearGradient(
            colors: [Color(hex: "#FF6B6B"), Color(hex: "#FF8E53")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        public static let heroGradient = LinearGradient(
            colors: [Color(hex: "#FF6B6B"), Color(hex: "#FF8E53"), Color(hex: "#FFA07A")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Typography Scale
    public struct Typography {
        public static let heroAmount = Font.system(size: 52, weight: .bold, design: .default).monospacedDigit()
        public static let largeTitle = Font.system(size: 32, weight: .bold, design: .default)
        public static let title = Font.system(size: 22, weight: .semibold, design: .default)
        public static let headline = Font.system(size: 18, weight: .semibold, design: .default)
        public static let body = Font.system(size: 15, weight: .regular, design: .default)
        public static let subheadline = Font.system(size: 14, weight: .medium, design: .default)
        public static let caption = Font.system(size: 12, weight: .regular, design: .default)
        public static let label = Font.system(size: 11, weight: .semibold, design: .default)
        public static let micro = Font.system(size: 10, weight: .semibold, design: .default)
    }

    // MARK: - Spacing Tokens
    public struct Spacing {
        public static let xs: CGFloat = 4
        public static let sm: CGFloat = 8
        public static let md: CGFloat = 12
        public static let lg: CGFloat = 16
        public static let xl: CGFloat = 20
        public static let xxl: CGFloat = 28
    }

    // MARK: - Corner Radius Tokens
    public struct Radius {
        public static let badge: CGFloat = 6
        public static let pill: CGFloat = 8
        public static let button: CGFloat = 12
        public static let subCard: CGFloat = 12
        public static let card: CGFloat = 16
        public static let hero: CGFloat = 20
        public static let sheet: CGFloat = 24
    }
}

// MARK: - Shadow & Card ViewModifiers

public struct SpendoraCoralShadowModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    let cornerRadius: CGFloat

    public func body(content: Content) -> some View {
        content
            .background(SpendoraTheme.Colors.card)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(
                color: colorScheme == .dark
                    ? Color.black.opacity(0.35)
                    : SpendoraTheme.Colors.coral.opacity(0.10),
                radius: 14,
                x: 0,
                y: 6
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(SpendoraTheme.Colors.border, lineWidth: 0.5)
            )
    }
}

extension View {
    public func spendoraCard(cornerRadius: CGFloat = 16) -> some View {
        self.modifier(SpendoraCoralShadowModifier(cornerRadius: cornerRadius))
    }
}
