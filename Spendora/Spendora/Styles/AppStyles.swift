//
//  AppStyles.swift
//

import SwiftUI

// MARK: - AppStyles

/**
 `AppStyles` provides Spendora's design system tokens, eye-friendly typography scale, spring physics, and card layout specs.
 Smallest font size in the entire app is 14pt for maximum legibility and comfort.
 */
struct AppStyles {

    // MARK: - Typography System (Eye-Friendly Large Scale)
    struct Typography {
        /// Hero Display Price: 38pt Black Rounded
        static let hero = Font.system(size: 38, weight: .black, design: .rounded)
        
        /// Large Title: 34pt Bold Rounded
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
        
        /// Title: 28pt Semibold Rounded
        static let title = Font.system(size: 28, weight: .semibold, design: .rounded)
        
        /// Headline: 22pt Semibold Rounded
        static let headline = Font.system(size: 22, weight: .semibold, design: .rounded)
        
        /// Body: 18pt Medium Rounded (Roomy, easy to read)
        static let body = Font.system(size: 18, weight: .medium, design: .rounded)
        
        /// Subheadline: 16pt Medium Rounded
        static let subheadline = Font.system(size: 16, weight: .medium, design: .rounded)
        
        /// Caption: 14pt Regular Rounded (SMALLEST FONT IN APP - Eye-Friendly)
        static let caption = Font.system(size: 14, weight: .regular, design: .rounded)
        
        /// Footnote: 14pt Regular Rounded
        static let footnote = Font.system(size: 14, weight: .regular, design: .rounded)
        
        /// Status Badge Pill: 12pt Bold Rounded
        static let badge = Font.system(size: 12, weight: .bold, design: .rounded)
    }

    // MARK: - Animation System
    struct AnimationTokens {
        /// Signature Spring Animation (.spring response: 0.3, dampingFraction: 0.7)
        static let signatureSpring = Animation.spring(response: 0.3, dampingFraction: 0.7)
    }

    // MARK: - Spacing System
    struct Spacing {
        /// 6pt micro gap
        static let xxSmall: CGFloat = 6
        /// 10pt tight spacing
        static let xSmall: CGFloat = 10
        /// 14pt compact spacing
        static let small: CGFloat = 14
        /// 18pt standard padding
        static let medium: CGFloat = 18
        /// 26pt section spacing
        static let large: CGFloat = 26
        /// 36pt container gap
        static let xLarge: CGFloat = 36
        /// 52pt hero spacing
        static let xxLarge: CGFloat = 52
    }

    // MARK: - Corner Radius Tokens (18pt Spacious Card)
    struct Radius {
        /// 8pt badge pill radius
        static let small: CGFloat = 8
        /// 14pt icon container radius
        static let icon: CGFloat = 14
        /// 18pt standard spacious card radius
        static let card: CGFloat = 18
        /// 22pt hero banner radius
        static let hero: CGFloat = 22
        /// 26pt modal radius
        static let modal: CGFloat = 26
    }

    // MARK: - Shadow System
    struct Shadow {
        /// Soft subtle card shadow
        static let soft = Color.black.opacity(0.04)
        /// Medium glass shadow
        static let medium = Color.black.opacity(0.08)
        /// Glowing hero shadow
        static let heroGlow = Color(hex: "#007AFF").opacity(0.35)
    }
}
