//
//  AppStyles.swift
//

import SwiftUI

// MARK: - AppStyles

/**
 `AppStyles` provides a unified, enterprise-grade design system token architecture for Spendora.
 Inspired by Apple's HIG and premier financial applications (Copilot, Monzo, Robinhood).
 */
struct AppStyles {

    // MARK: - Typography System (SF Pro Rounded & Text)
    struct Typography {
        /// Hero Price Display (36pt, Black, Rounded)
        static let heroPrice = Font.system(size: 36, weight: .black, design: .rounded)
        
        /// Large Title (34pt, Bold, Rounded)
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
        
        /// Screen Title 1 (28pt, Bold, Rounded)
        static let title1 = Font.system(size: 28, weight: .bold, design: .rounded)
        
        /// Group Header Title 2 (22pt, SemiBold, Rounded)
        static let title2 = Font.system(size: 22, weight: .semibold, design: .rounded)
        
        /// Item Headline (18pt, SemiBold, Rounded)
        static let headline = Font.system(size: 18, weight: .semibold, design: .rounded)
        
        /// Form Label Subheadline (15pt, SemiBold, Rounded)
        static let subheadline = Font.system(size: 15, weight: .semibold, design: .rounded)
        
        /// Standard Body Text (16pt, Regular, Rounded)
        static let body = Font.system(size: 16, weight: .regular, design: .rounded)
        
        /// Caption Description (13pt, Medium, Rounded)
        static let caption = Font.system(size: 13, weight: .medium, design: .rounded)
        
        /// Status Badge Pill (11pt, Heavy, Rounded)
        static let badge = Font.system(size: 11, weight: .heavy, design: .rounded)
    }

    // MARK: - Spacing System
    struct Spacing {
        /// 4pt micro gap
        static let xxSmall: CGFloat = 4
        /// 8pt tight spacing
        static let xSmall: CGFloat = 8
        /// 12pt compact spacing
        static let small: CGFloat = 12
        /// 16pt standard padding
        static let medium: CGFloat = 16
        /// 24pt section spacing
        static let large: CGFloat = 24
        /// 32pt container gap
        static let xLarge: CGFloat = 32
        /// 48pt hero spacing
        static let xxLarge: CGFloat = 48
    }

    // MARK: - Corner Radius Tokens
    struct Radius {
        /// 6pt badge pill radius
        static let small: CGFloat = 6
        /// 10pt icon container radius
        static let icon: CGFloat = 10
        /// 14pt button radius
        static let button: CGFloat = 14
        /// 18pt form field radius
        static let field: CGFloat = 18
        /// 20pt card radius
        static let card: CGFloat = 20
        /// 24pt hero banner radius
        static let hero: CGFloat = 24
    }

    // MARK: - Shadow Elevation System
    struct Shadow {
        /// Soft subtle card shadow
        static let soft = Color.black.opacity(0.04)
        /// Medium glass shadow
        static let medium = Color.black.opacity(0.08)
        /// Strong hero glow shadow
        static let heroGlow = Color(hex: "#6366F1").opacity(0.35)
    }
}
