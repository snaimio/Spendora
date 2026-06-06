//
//  Color+App.swift
//  Spendora
//

import SwiftUI

extension Color {
    
    // MARK: - Brand Colors
    static let brandPrimary = Color.blue
    static let brandSecondary = Color.purple
    static let brandAccent = Color.orange
    
    // MARK: - Gradients
    static let primaryGradient = LinearGradient(
        colors: [.brandPrimary, .brandSecondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let secondaryGradient = LinearGradient(
        colors: [.pink, .orange],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Card Background
    static let cardBackground = Color(.systemBackground)
    static let cardShadow = Color.black.opacity(0.08)
    
    // MARK: - Category Colors
    static let categoryEntertainment = Color.blue
    static let categoryProductivity = Color.green
    static let categoryHealth = Color.red
    static let categoryShopping = Color.orange
    static let categoryFood = Color.purple
    static let categoryEducation = Color.teal
    static let categoryOther = Color.gray
}
