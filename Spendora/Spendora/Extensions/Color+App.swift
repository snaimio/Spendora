//
//  Color+App.swift
//  Spendora
//

import SwiftUI

extension Color {
    
    // MARK: - Brand Colors
    static let brandPrimary = Color(hex: "#6366F1")      // Indigo
    static let brandSecondary = Color(hex: "#8B5CF6")    // Purple
    static let brandAccent = Color(hex: "#F59E0B")       // Amber
    
    // MARK: - Gradients
    static let primaryGradient = LinearGradient(
        colors: [.brandPrimary, .brandSecondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let secondaryGradient = LinearGradient(
        colors: [Color(hex: "#F472B6"), Color(hex: "#FB923C")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [Color(.systemBackground), Color(.systemBackground)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    // MARK: - Category Colors (Vibrant)
    static let categoryEntertainment = Color(hex: "#EC4899")
    static let categoryProductivity = Color(hex: "#10B981")
    static let categoryHealth = Color(hex: "#3B82F6")
    static let categoryShopping = Color(hex: "#F59E0B")
    static let categoryFood = Color(hex: "#8B5CF6")
    static let categoryEducation = Color(hex: "#06B6D4")
    static let categoryOther = Color(hex: "#6B7280")
    
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
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
