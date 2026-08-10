//
//  AppStyles.swift
//  Spendora
//

import SwiftUI

// MARK: - AppStyles (Fintech SF Pro Typography & 4pt Spacing System)

/**
 `AppStyles` provides Spendora's exact SF Pro typography scale, 4pt base grid spacing tokens,
 and standardized corner radii for top-tier fintech applications.
 */
struct AppStyles {
    
    // MARK: - Typography Scale (SF Pro Text & Display)
    struct Typography {
        /// Hero Number: 40pt Bold Monospaced with tight tracking for dashboard figures
        static let heroPrice = Font.system(size: 40, weight: .bold, design: .default).monospacedDigit()
        
        /// Large Title: 32pt Bold for top screen headers
        static let largeTitle = Font.system(size: 32, weight: .bold, design: .default)
        
        /// Title: 22pt Semibold for major section and card headers
        static let title = Font.system(size: 22, weight: .semibold, design: .default)
        
        /// Headline: 18pt Semibold for subscription service names (LARGEST text on card)
        static let headline = Font.system(size: 18, weight: .semibold, design: .default)
        
        /// Body: 15pt Regular for standard descriptions and list text
        static let body = Font.system(size: 15, weight: .regular, design: .default)
        
        /// Subheadline: 14pt Medium for category and billing frequencies
        static let subheadline = Font.system(size: 14, weight: .medium, design: .default)
        
        /// Caption: 12pt Regular for timestamps and secondary dates
        static let caption = Font.system(size: 12, weight: .regular, design: .default)
        static let captionBold = Font.system(size: 12, weight: .semibold, design: .default)
        
        /// Label / Badge: 11pt Semibold with wide tracking for status pills and mini tags
        static let label = Font.system(size: 11, weight: .semibold, design: .default)
        static let micro = label
        static let caption2 = label
        static let footnote = caption
        static let badge = label
        static let title3 = title
    }
    
    // MARK: - 4pt Base Grid Spacing Tokens
    struct Spacing {
        static let xs: CGFloat = 4      // Element inner gap, chip icon spacing
        static let sm: CGFloat = 8      // Nested row item padding, chip vertical
        static let md: CGFloat = 12     // Gap between adjacent sub-cards / well padding
        static let lg: CGFloat = 16     // Standard card inner padding & screen margins
        static let xl: CGFloat = 20     // Gap between distinct cards within section
        static let xxl: CGFloat = 28    // Vertical separation between major sections
        
        // Aliases
        static let element: CGFloat = xs
        static let small: CGFloat = sm
        static let medium: CGFloat = md
        static let cardPadding: CGFloat = lg
        static let large: CGFloat = xl
        static let sectionSpacing: CGFloat = xxl
        static let xLarge: CGFloat = xxl
    }
    
    // MARK: - Corner Radius Tokens (Exact Fintech Standard)
    struct Radius {
        static let small: CGFloat = 6   // Status pills, mini tags
        static let chip: CGFloat = 8    // Filter pills, interactive chips
        static let button: CGFloat = 12 // Primary CTA action buttons
        static let medium: CGFloat = 12 // Sub-card containers, icon boxes
        static let card: CGFloat = 16   // Standard subscription cards & metric tiles
        static let hero: CGFloat = 16   // Hero dashboard summary container
        static let large: CGFloat = 20  // Modals and large sheet presentation
    }
    
    // MARK: - Shadows
    struct Shadow {
        static let elevation1 = Color.black.opacity(0.04)
        static let elevation2 = Color.black.opacity(0.12)
        static let elevation3 = Color.black.opacity(0.35)
        static let brandGlow = Color(hex: "#4F46E5").opacity(0.25)
    }
}
