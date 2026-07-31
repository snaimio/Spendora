//
//  Font+App.swift
//  Spendora
//

import SwiftUI

extension Font {
    
    // MARK: - Premium Spendora Typography System
    
    /// Hero Currency & Main Dashboard Totals (Tabular Monospaced Digits for crisp financial alignment)
    static func appHeroPrice(size: CGFloat = 34) -> Font {
        .system(size: size, weight: .bold, design: .rounded).monospacedDigit()
    }
    
    /// Display Titles (Sleek, rounded letterform)
    static func appTitle(_ size: CGFloat = 26) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }
    
    /// Section Headlines
    static func appHeadline(_ size: CGFloat = 18) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }
    
    /// Financial Amounts & Prices (Tabular alignment)
    static func appPrice(_ size: CGFloat = 17, weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight, design: .rounded).monospacedDigit()
    }
    
    /// Primary Reading Text (SF Pro default for maximum optical legibility and eye comfort)
    static let appBody = Font.system(.body, design: .default)
    
    /// Secondary Reading Text
    static let appSubheadline = Font.system(.subheadline, design: .default)
    
    /// Badges & Micro Text
    static let appCaption = Font.system(.caption, design: .rounded)
    static let appCaptionBold = Font.system(.caption, design: .rounded).weight(.bold)
}

extension View {
    /// Applies premium monospaced digit formatting to any view containing currency/numbers
    func appTabularNumbers() -> some View {
        self.fontDesign(.rounded)
            .monospacedDigit()
    }
}
