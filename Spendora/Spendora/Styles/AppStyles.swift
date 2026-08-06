//
//  AppStyles.swift
//

import SwiftUI

// MARK: - AppStyles

/**
 `AppStyles` provides a unified, enterprise-grade design system token architecture for Spendora.
 Features SF Pro Display/Text typographic hierarchy, glassmorphism tokens, and micro-shadow systems.
 */
struct AppStyles {

    // MARK: - Typography Hierarchy
    struct Typography {
        /// Hero Price Display (38pt, Black, Display)
        static let heroPrice = Font.system(size: 38, weight: .black, design: .default)
        
        /// Large Title: SF Pro Display Bold, 34pt
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .default)
        
        /// Title: SF Pro Display Semibold, 28pt
        static let title = Font.system(size: 28, weight: .semibold, design: .default)
        
        /// Headline: SF Pro Display Semibold, 20pt
        static let headline = Font.system(size: 20, weight: .semibold, design: .default)
        
        /// Body: SF Pro Text Regular, 16pt
        static let body = Font.system(size: 16, weight: .regular, design: .default)
        
        /// Caption: SF Pro Text Regular, 13pt
        static let caption = Font.system(size: 13, weight: .regular, design: .default)
        
        /// Footnote: SF Pro Text Regular, 11pt
        static let footnote = Font.system(size: 11, weight: .regular, design: .default)
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

    // MARK: - Corner Radius Tokens (12-16px Card Standard)
    struct Radius {
        /// 6pt badge pill radius
        static let small: CGFloat = 6
        /// 10pt icon container radius
        static let icon: CGFloat = 10
        /// 14pt button radius
        static let button: CGFloat = 14
        /// 16pt card standard radius
        static let card: CGFloat = 16
        /// 20pt hero banner radius
        static let hero: CGFloat = 20
    }

    // MARK: - Shadow Elevation System
    struct Shadow {
        /// Soft subtle card shadow
        static let soft = Color.black.opacity(0.04)
        /// Medium glass shadow
        static let medium = Color.black.opacity(0.08)
        /// Strong hero glow shadow
        static let heroGlow = Color(hex: "#2563EB").opacity(0.35)
    }
}
