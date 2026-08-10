//
//  SpendoraTheme.swift
//  Spendora
//

import SwiftUI

// MARK: - SpendoraTheme (Fintech Studio 60-30-10 & Golden UX Architecture)

public struct SpendoraTheme {

    // MARK: - Colors (60-30-10 Palette)
    public struct Colors {
        // 60% — Canvas
        public static let canvasLight = Color(hex: "#FFFBF5")
        public static let canvasDark = Color(hex: "#0F0E17")
        public static let canvas = Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(hex: "#0F0E17") : UIColor(hex: "#FFFBF5")
        })

        // 30% — Surfaces & Text
        public static let cardLight = Color(hex: "#FFFFFF")
        public static let cardDark = Color(hex: "#1C1B29")
        public static let cardElevatedDark = Color(hex: "#242336")
        public static let card = Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(hex: "#1C1B29") : UIColor(hex: "#FFFFFF")
        })
        public static let cardElevated = Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(hex: "#242336") : UIColor(hex: "#FFFFFF")
        })
        
        public static let borderLight = Color(hex: "#F0EBE3")
        public static let borderDark = Color(hex: "#2A2838")
        public static let border = Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(hex: "#2A2838") : UIColor(hex: "#F0EBE3")
        })

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
            trait.userInterfaceStyle == .dark ? UIColor(hex: "#211E30") : UIColor(hex: "#FFF0EE")
        })
        public static let chevron = Color(hex: "#FFB3A7")

        // Semantic Colors
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

    // MARK: - Typography Scale (SF Pro & Monospaced Digits)
    public struct Typography {
        public static let heroAmount = Font.system(size: 52, weight: .bold, design: .default).monospacedDigit()
        public static let largeTitle = Font.system(size: 32, weight: .bold, design: .default)
        public static let title = Font.system(size: 22, weight: .bold, design: .default)
        public static let headline = Font.system(size: 17, weight: .semibold, design: .default)
        public static let body = Font.system(size: 15, weight: .regular, design: .default)
        public static let subheadline = Font.system(size: 14, weight: .medium, design: .default)
        public static let caption = Font.system(size: 13, weight: .regular, design: .default)
        public static let label = Font.system(size: 11, weight: .semibold, design: .default)
        public static let micro = Font.system(size: 10, weight: .semibold, design: .default)
    }

    // MARK: - Spacing Grid Tokens
    public struct Spacing {
        public static let xs: CGFloat = 4
        public static let sm: CGFloat = 8
        public static let md: CGFloat = 12
        public static let lg: CGFloat = 16
        public static let xl: CGFloat = 20
        public static let xxl: CGFloat = 24
        public static let xxxl: CGFloat = 32
    }

    // MARK: - Corner Radius Tokens
    public struct Radius {
        public static let badge: CGFloat = 6
        public static let pill: CGFloat = 8
        public static let subCard: CGFloat = 12
        public static let button: CGFloat = 14
        public static let iconBox: CGFloat = 14
        public static let card: CGFloat = 20
        public static let hero: CGFloat = 20
    }
}

// MARK: - Card & Press Modifiers

public struct SpendoraFintechCardModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    let cornerRadius: CGFloat

    public func body(content: Content) -> some View {
        content
            .background(SpendoraTheme.Colors.card)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(
                color: colorScheme == .dark
                    ? Color.black.opacity(0.40)
                    : SpendoraTheme.Colors.coral.opacity(0.07),
                radius: 16,
                x: 0,
                y: colorScheme == .dark ? 8 : 6
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(SpendoraTheme.Colors.border, lineWidth: 0.5)
            )
    }
}

public typealias SpendoraCoralShadowModifier = SpendoraFintechCardModifier

public struct PressEffectModifier: ViewModifier {
    @State private var isPressed = false

    public func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}

public struct CardPressEffectModifier: ViewModifier {
    @State private var isPressed = false

    public func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}

extension View {
    public func spendoraCard(cornerRadius: CGFloat = 20) -> some View {
        self.modifier(SpendoraFintechCardModifier(cornerRadius: cornerRadius))
    }
    
    public func pressableButton() -> some View {
        self.modifier(PressEffectModifier())
    }
    
    public func pressableCard() -> some View {
        self.modifier(CardPressEffectModifier())
    }
}
