//
//  AppStyles.swift
//

import SwiftUI

// MARK: - AppStyles

/**
 `AppStyles` provides Spendora's design system tokens, typography scale, spring physics, and glassmorphism specs.
 */
struct AppStyles {

    // MARK: - Typography System
    struct Typography {
        /// Hero Display Price: 38pt Black Rounded
        static let hero = Font.system(size: 38, weight: .black, design: .rounded)
        
        /// Large Title: 34pt Bold Rounded
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
        
        /// Title: 28pt Semibold Rounded
        static let title = Font.system(size: 28, weight: .semibold, design: .rounded)
        
        /// Headline: 20pt Semibold Rounded
        static let headline = Font.system(size: 20, weight: .semibold, design: .rounded)
        
        /// Body: 16pt Regular Rounded
        static let body = Font.system(size: 16, weight: .regular, design: .rounded)
        
        /// Subheadline: 15pt Regular Rounded
        static let subheadline = Font.system(size: 15, weight: .regular, design: .rounded)
        
        /// Caption: 13pt Regular Rounded
        static let caption = Font.system(size: 13, weight: .regular, design: .rounded)
        
        /// Footnote: 11pt Regular Rounded
        static let footnote = Font.system(size: 11, weight: .regular, design: .rounded)
        
        /// Status Badge Pill: 11pt Heavy Rounded
        static let badge = Font.system(size: 11, weight: .heavy, design: .rounded)
    }

    // MARK: - Animation System
    struct AnimationTokens {
        /// Signature Spring Animation (.spring response: 0.3, dampingFraction: 0.7)
        static let signatureSpring = Animation.spring(response: 0.3, dampingFraction: 0.7)
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

    // MARK: - Corner Radius Tokens (16pt Standard Card)
    struct Radius {
        /// 6pt badge pill radius
        static let small: CGFloat = 6
        /// 12pt icon container radius
        static let icon: CGFloat = 12
        /// 16pt standard card radius
        static let card: CGFloat = 16
        /// 20pt hero banner radius
        static let hero: CGFloat = 20
        /// 24pt modal radius
        static let modal: CGFloat = 24
    }

    // MARK: - Glassmorphism Shadow System
    struct Shadow {
        /// Soft subtle card shadow
        static let soft = Color.black.opacity(0.04)
        /// Medium glass shadow
        static let medium = Color.black.opacity(0.08)
        /// Glowing hero shadow
        static let heroGlow = Color(hex: "#00D4AA").opacity(0.38)
    }
}
