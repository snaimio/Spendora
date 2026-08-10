//
//  AppStyles.swift
//  Spendora
//

import SwiftUI

// MARK: - AppStyles (Apple San Francisco Typography & Luxury Spacing System)

/**
 `AppStyles` provides Apple's official San Francisco typography scale, 18pt continuous corner radii,
 and 16pt luxury spacing tokens.
 */
struct AppStyles {
    
    // MARK: - Apple Typography Scale (SF Pro Text & Display)
    struct Typography {
        static let heroPrice = Font.system(size: 42, weight: .bold, design: .default).monospacedDigit()
        static let title = Font.system(size: 28, weight: .bold, design: .default)
        static let headline = Font.system(size: 20, weight: .semibold, design: .default) // Subscription Names (LARGEST)
        static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
        static let body = Font.system(size: 16, weight: .regular, design: .default)
        static let caption = Font.system(size: 13, weight: .regular, design: .default)
        static let captionBold = Font.system(size: 13, weight: .semibold, design: .default)
        static let micro = Font.system(size: 11, weight: .semibold, design: .default)
        
        // Aliases & Financial Helpers
        static let largeTitle = title
        static let title3 = Font.system(size: 20, weight: .semibold, design: .default)
        static let caption2 = Font.system(size: 11, weight: .semibold, design: .default)
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
    
    // MARK: - Corner Radius Tokens (Standardized 18pt Cards & 12pt Buttons)
    struct Radius {
        static let small: CGFloat = 8
        static let chip: CGFloat = 8
        static let medium: CGFloat = 12
        static let button: CGFloat = 12
        static let card: CGFloat = 18
        static let hero: CGFloat = 18
        static let large: CGFloat = 22
    }
    
    // MARK: - Shadows
    struct Shadow {
        static let elevation1 = Color.black.opacity(0.20)
        static let elevation2 = Color.black.opacity(0.40)
        static let elevation3 = Color.black.opacity(0.60)
        static let goldGlow = Color(hex: "#C6A473").opacity(0.25)
    }
}
