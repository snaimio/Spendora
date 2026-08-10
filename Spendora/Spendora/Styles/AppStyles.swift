//
//  AppStyles.swift
//  Spendora
//

import SwiftUI

// MARK: - AppStyles

/**
 `AppStyles` provides Spendora's design system tokens, Apple HIG typography scale, spacing rules, and shadow specs.
 Specified for Spendora Teal Brand Identity.
 */
struct AppStyles {
    
    // MARK: - Typography System
    struct Typography {
        static let heroPrice = Font.system(size: 42, weight: .black, design: .monospaced)
        static let title = Font.system(size: 28, weight: .bold, design: .rounded)
        static let headline = Font.system(size: 20, weight: .bold, design: .rounded)
        static let body = Font.system(size: 16, weight: .regular, design: .rounded)
        static let caption = Font.system(size: 13, weight: .regular, design: .rounded)
        static let micro = Font.system(size: 11, weight: .bold, design: .rounded)
        
        // Legacy Aliases
        static let largeTitle = title
        static let title3 = headline
        static let subheadline = Font.system(size: 15, weight: .regular, design: .rounded)
        static let caption2 = Font.system(size: 12, weight: .semibold, design: .rounded)
        static let footnote = micro
        static let badge = micro
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xxSmall: CGFloat = 4
        static let xSmall: CGFloat = 8
        static let small: CGFloat = 12
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let xLarge: CGFloat = 32
    }
    
    // MARK: - Corner Radius
    struct Radius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xLarge: CGFloat = 20
    }
    
    // MARK: - Shadows
    struct Shadow {
        static let soft = Color.black.opacity(0.04)
        static let medium = Color.black.opacity(0.08)
        static let strong = Color.black.opacity(0.12)
        static let glow = Color(hex: "#00D4AA").opacity(0.3)
    }
}
