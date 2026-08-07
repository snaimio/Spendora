//
//  Color+App.swift
//  Spendora
//

import SwiftUI

// MARK: - Color Extension

/**
 Extension on `Color` providing Spendora's Luxury Gunmetal Leather & Polished Rose-Gold / Amber Theme.
 Extracted directly from the master logo asset and visual mockup specifications.
 */
extension Color {
    
    // MARK: - Signature Luxury Palette (Master Logo Theme)
    static let brandPrimary = Color(hex: "#D4AF37")      // Polished Brass / Gold Accent
    static let brandSecondary = Color(hex: "#94A3B8")    // Brushed Gunmetal Grey
    static let brandTertiary = Color(hex: "#D4AF37")     // Polished Brass Accent
    static let brandAccent = Color(hex: "#F59E0B")       // Glowing Gold Highlight
    static let brandAmber = Color(hex: "#F59E0B")        // Amber Gold
    static let brandDark = Color(hex: "#0F0F1A")         // Deep Leather Black
    static let brandLight = Color(hex: "#F8F9FE")        // Light Mode Surface
    static let brandCard = Color(hex: "#1E293B")         // Machined Dark Slate Cards
    static let brandPurple = Color(hex: "#8B5CF6")       // Violet Metal Accent
    static let brandRose = Color(hex: "#FF6B6B")         // Rose Coral Accent
    
    // MARK: - Status Colors
    static let brandSuccess = Color(hex: "#D4AF37")      // Gold / Brass Confirmation
    static let brandWarning = Color(hex: "#F59E0B")      // Amber Gold
    static let brandDanger = Color(hex: "#FF6B6B")       // Rose Red
    
    // MARK: - Vibrant Brand Gradients
    static let gradientPrimary = LinearGradient(
        colors: [Color(hex: "#D4AF37"), Color(hex: "#F59E0B")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientSunset = LinearGradient(
        colors: [Color(hex: "#FF6B6B"), Color(hex: "#F59E0B")],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let gradientVibrantGold = LinearGradient(
        colors: [Color(hex: "#F59E0B"), Color(hex: "#D4AF37"), Color(hex: "#FF8A5C")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gradientHero = LinearGradient(
        colors: [Color(hex: "#2B2D32"), Color(hex: "#1A1B1E")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - UI Colors (Adaptive Light/Dark)
    static let appBackground = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#0F0F1A")
            : UIColor(hex: "#F8F9FE")
    })
    
    static let cardBackground = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#1E293B")
            : UIColor.white
    })
    
    static let textPrimary = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor.white
            : UIColor(hex: "#0F0F1A")
    })
    
    static let textSecondary = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#CBD5E1")
            : UIColor(hex: "#64748B")
    })
    
    static let textTertiary = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#94A3B8")
            : UIColor(hex: "#94A3B8")
    })

    // MARK: - Category Colors
    static let categoryEntertainment = Color(hex: "#FF6B6B")
    static let categoryProductivity = Color(hex: "#D4AF37")
    static let categoryHealth = Color(hex: "#F59E0B")
    static let categoryShopping = Color(hex: "#FF8A5C")
    static let categoryFood = Color(hex: "#FF6B6B")
    static let categoryEducation = Color(hex: "#8B5CF6")
    static let categoryAiTools = Color(hex: "#38BDF8")
    static let categoryMusic = Color(hex: "#FF6B6B")
    static let categoryGaming = Color(hex: "#A78BFA")
    static let categoryUtilities = Color(hex: "#94A3B8")
    static let categoryOther = Color(hex: "#94A3B8")
    
    // MARK: - Helper
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

// MARK: - Ambient Brand Background Overlay

struct SpendoraBrandBackgroundView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            // Ambient Glowing Gold Orb (Top-Right)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "#D4AF37").opacity(colorScheme == .dark ? 0.15 : 0.08), Color.clear],
                        center: .center,
                        startRadius: 10,
                        endRadius: 240
                    )
                )
                .frame(width: 320, height: 320)
                .offset(x: 120, y: -180)
                .blur(radius: 20)
            
            // Ambient Glowing Coral Orb (Bottom-Left)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "#FF6B6B").opacity(colorScheme == .dark ? 0.12 : 0.06), Color.clear],
                        center: .center,
                        startRadius: 10,
                        endRadius: 260
                    )
                )
                .frame(width: 340, height: 340)
                .offset(x: -140, y: 220)
                .blur(radius: 25)
        }
    }
}

extension View {
    func spendoraBrandBackground() -> some View {
        self.background(SpendoraBrandBackgroundView())
    }
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        self.init(
            red: CGFloat((int >> 16) & 0xFF) / 255,
            green: CGFloat((int >> 8) & 0xFF) / 255,
            blue: CGFloat(int & 0xFF) / 255,
            alpha: 1
        )
    }
}
