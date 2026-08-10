//
//  AppStyles.swift
//  Spendora
//

import SwiftUI

// MARK: - AppStyles (Apple HIG Compliant Design System)

/**
 `AppStyles` provides Spendora's unified typography scale, spacing tokens, and radius tokens.
 */
struct AppStyles {
    
    // MARK: - Typography System
    struct Typography {
        static let heroPrice = Font.system(size: 42, weight: .black, design: .monospaced)
        static let title = Font.system(size: 28, weight: .bold, design: .rounded)
        static let headline = Font.system(size: 20, weight: .bold, design: .rounded) // Subscription Names (LARGEST)
        static let body = Font.system(size: 16, weight: .regular, design: .rounded)
        static let subheadline = Font.system(size: 15, weight: .medium, design: .rounded)
        static let caption = Font.system(size: 13, weight: .regular, design: .rounded)
        static let captionBold = Font.system(size: 13, weight: .bold, design: .rounded)
        static let micro = Font.system(size: 11, weight: .bold, design: .rounded)
        
        // Aliases
        static let largeTitle = title
        static let title3 = headline
        static let caption2 = Font.system(size: 12, weight: .bold, design: .rounded)
        static let footnote = micro
        static let badge = micro
    }
    
    // MARK: - Spacing Tokens
    struct Spacing {
        static let element: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let cardPadding: CGFloat = 16
        static let large: CGFloat = 20
        static let sectionSpacing: CGFloat = 24
        static let xLarge: CGFloat = 32
    }
    
    // MARK: - Corner Radius Tokens
    struct Radius {
        static let small: CGFloat = 8
        static let chip: CGFloat = 10
        static let medium: CGFloat = 12
        static let card: CGFloat = 16
        static let hero: CGFloat = 20
        static let large: CGFloat = 24
    }
    
    // MARK: - Shadows
    struct Shadow {
        static let elevation1 = Color.black.opacity(0.03)
        static let elevation2 = Color.black.opacity(0.06)
        static let elevation3 = Color.black.opacity(0.12)
        static let tealGlow = Color(hex: "#00D4AA").opacity(0.3)
    }
}
