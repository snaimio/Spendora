//
//  AppStyles.swift
//  Spendora
//

import SwiftUI

// MARK: - AppStyles (Fintech Studio Standards)

struct AppStyles {
    
    // MARK: - Typography
    struct Typography {
        static let heroPrice = SpendoraTheme.Typography.heroAmount
        static let largeTitle = SpendoraTheme.Typography.largeTitle
        static let title = SpendoraTheme.Typography.title
        static let headline = SpendoraTheme.Typography.headline
        static let body = SpendoraTheme.Typography.body
        static let subheadline = SpendoraTheme.Typography.subheadline
        static let caption = SpendoraTheme.Typography.caption
        static let captionBold = Font.system(size: 13, weight: .semibold, design: .default)
        static let label = SpendoraTheme.Typography.label
        static let micro = SpendoraTheme.Typography.micro
        static let caption2 = label
        static let footnote = caption
        static let badge = label
        static let title3 = title
    }
    
    // MARK: - Spacing Grid
    struct Spacing {
        static let xs: CGFloat = SpendoraTheme.Spacing.xs
        static let sm: CGFloat = SpendoraTheme.Spacing.sm
        static let md: CGFloat = SpendoraTheme.Spacing.md
        static let lg: CGFloat = SpendoraTheme.Spacing.lg
        static let xl: CGFloat = SpendoraTheme.Spacing.xl
        static let xxl: CGFloat = SpendoraTheme.Spacing.xxl
        
        static let element: CGFloat = xs
        static let small: CGFloat = sm
        static let medium: CGFloat = md
        static let cardPadding: CGFloat = lg
        static let large: CGFloat = xl
        static let sectionSpacing: CGFloat = xxl
        static let xLarge: CGFloat = xxl
    }
    
    // MARK: - Corner Radius
    struct Radius {
        static let small: CGFloat = SpendoraTheme.Radius.badge
        static let chip: CGFloat = SpendoraTheme.Radius.pill
        static let button: CGFloat = SpendoraTheme.Radius.button
        static let medium: CGFloat = SpendoraTheme.Radius.subCard
        static let iconBox: CGFloat = SpendoraTheme.Radius.iconBox
        static let card: CGFloat = SpendoraTheme.Radius.card
        static let hero: CGFloat = SpendoraTheme.Radius.hero
        static let large: CGFloat = 24
    }
    
    // MARK: - Shadows
    struct Shadow {
        static let elevation1 = Color.black.opacity(0.04)
        static let elevation2 = Color.black.opacity(0.12)
        static let elevation3 = Color.black.opacity(0.35)
        static let brandGlow = SpendoraTheme.Colors.coral.opacity(0.15)
    }
}
