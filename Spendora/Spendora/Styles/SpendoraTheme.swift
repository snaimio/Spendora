//
//  SpendoraTheme.swift
//  Spendora
//

import SwiftUI

// MARK: - SubscriptionStatusFilter
public enum SubscriptionStatusFilter: String, CaseIterable, Identifiable {
    case active = "Active"
    case cancelled = "Cancelled"
    case all = "All"
    
    public var id: String { rawValue }
}

// MARK: - SpendoraTheme (Apple Native HIG & Emerald Accent Architecture)

public struct SpendoraTheme {

    // MARK: - Emerald Signature Accent (#00C07A Light / #00D988 Dark)
    public static let accent = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#00D988")
            : UIColor(hex: "#00C07A")
    })
    
    public static let accentTint = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#00D988").withAlphaComponent(0.15)
            : UIColor(hex: "#00C07A").withAlphaComponent(0.12)
    })
    
    public static let accentText = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#00D988")
            : UIColor(hex: "#007A4C")
    })

    // MARK: - Native Apple System Surfaces & Labels
    public struct Colors {
        public static let canvas = Color(.systemBackground)
        public static let secondaryCanvas = Color(.secondarySystemBackground)
        public static let tertiaryCanvas = Color(.tertiarySystemBackground)
        
        public static let card = Color(.secondarySystemBackground)
        public static let cardElevated = Color(.tertiarySystemBackground)
        
        public static let textPrimary = Color(.label)
        public static let textSecondary = Color(.secondaryLabel)
        public static let textTertiary = Color(.tertiaryLabel)
        
        public static let separator = Color(.separator)
        public static let border = Color(.separator).opacity(0.6)
        
        // Semantic Apple Colors
        public static let success = Color(.systemGreen)
        public static let warning = Color(.systemOrange)
        public static let danger = Color(.systemRed)
        public static let link = Color(.systemBlue)
        public static let cancelled = Color(.tertiaryLabel)
        
        public static let coral = SpendoraTheme.accent
        public static let coralWarm = SpendoraTheme.accent
        public static let coralTint = SpendoraTheme.accentTint
        public static let chevron = Color(.tertiaryLabel)
    }

    // MARK: - Typography Scale (SF Pro & SF Rounded for Numbers)
    public static let heroNumber = Font.system(size: 52, weight: .bold, design: .rounded).monospacedDigit()
    public static let statNumber = Font.system(size: 20, weight: .semibold, design: .rounded).monospacedDigit()
    public static let cardAmount = Font.system(size: 16, weight: .semibold, design: .rounded).monospacedDigit()
    
    public struct Typography {
        public static let heroAmount = SpendoraTheme.heroNumber
        public static let largeTitle = Font.largeTitle.weight(.bold)
        public static let title = Font.title2.weight(.bold)
        public static let headline = Font.headline
        public static let body = Font.body
        public static let subheadline = Font.subheadline
        public static let caption = Font.caption
        public static let label = Font.caption.weight(.semibold)
        public static let micro = Font.caption2.weight(.semibold)
    }

    // MARK: - Spacing Tokens (Apple HIG 20pt / 16pt / 12pt)
    public static let cardPadding: CGFloat = 16
    public static let sectionSpacing: CGFloat = 20
    public static let cardRadius: CGFloat = 12
    public static let accentBarWidth: CGFloat = 3
    
    public struct Spacing {
        public static let xs: CGFloat = 4
        public static let sm: CGFloat = 8
        public static let md: CGFloat = 12
        public static let lg: CGFloat = 16
        public static let xl: CGFloat = 20
        public static let xxl: CGFloat = 24
    }

    public struct Radius {
        public static let badge: CGFloat = 6
        public static let pill: CGFloat = 8
        public static let subCard: CGFloat = 12
        public static let button: CGFloat = 12
        public static let iconBox: CGFloat = 10
        public static let card: CGFloat = 12
        public static let hero: CGFloat = 12
    }
}

// MARK: - Native Inset Card Modifier

public struct SpendoraAppleCardModifier: ViewModifier {
    let cornerRadius: CGFloat

    public func body(content: Content) -> some View {
        content
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

public typealias SpendoraCoralShadowModifier = SpendoraAppleCardModifier
public typealias SpendoraFintechCardModifier = SpendoraAppleCardModifier

extension View {
    public func spendoraCard(cornerRadius: CGFloat = 12) -> some View {
        self.modifier(SpendoraAppleCardModifier(cornerRadius: cornerRadius))
    }
    
    public func appleCard(cornerRadius: CGFloat = 12) -> some View {
        self.modifier(SpendoraAppleCardModifier(cornerRadius: cornerRadius))
    }
    
    public func pressableButton() -> some View {
        self
    }
    
    public func pressableCard() -> some View {
        self
    }
}
