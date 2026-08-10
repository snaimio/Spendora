//
//  Subscription+Formatting.swift
//  Spendora
//

import Foundation
import SwiftUI

// MARK: - SubscriptionCategory

/**
 `SubscriptionCategory` represents subscription classification with Spendora Teal brand category colors and icons.
 */
enum SubscriptionCategory: String, CaseIterable, Identifiable {

    case entertainment = "Entertainment"
    case music = "Music"
    case productivity = "Productivity"
    case ai = "AI & Tools"
    case health = "Health & Fitness"
    case shopping = "Shopping"
    case food = "Food & Dining"
    case education = "Education"
    case gaming = "Gaming"
    case utilities = "Utilities"
    case other = "Other"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .entertainment: return "tv.fill"
        case .music: return "music.note"
        case .productivity: return "briefcase.fill"
        case .ai: return "cpu"
        case .health: return "heart.fill"
        case .shopping: return "cart.fill"
        case .food: return "fork.knife"
        case .education: return "book.fill"
        case .gaming: return "gamecontroller.fill"
        case .utilities: return "wrench.and.screwdriver.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .entertainment: return Color(hex: "#FF6B6B")
        case .music: return Color(hex: "#FF6B6B")
        case .productivity: return Color(hex: "#00D4AA")
        case .ai: return Color(hex: "#00B4D8")
        case .health: return Color(hex: "#FFD93D")
        case .shopping: return Color(hex: "#FF8A5C")
        case .food: return Color(hex: "#FF6B6B")
        case .education: return Color(hex: "#6C5CE7")
        case .gaming: return Color(hex: "#A29BFE")
        case .utilities, .other: return Color(hex: "#636E72")
        }
    }
}

// MARK: - Subscription Extension

/**
 Extension on `Subscription` providing utility methods and helpers.
 */
extension Subscription {
    
    var displayName: String { name }

    var formattedCost: String {
        CurrencyManager.shared.format(cost)
    }

    var monthlyCostFormatted: String {
        CurrencyManager.shared.format(monthlyCost)
    }

    var yearlyCostFormatted: String {
        CurrencyManager.shared.format(yearlyCost)
    }

    var billingFrequencyText: String {
        isYearly ? "/ year" : "/ month"
    }

    var usageRatingStars: String {
        String(repeating: "⭐️", count: normalizedUsageRating)
    }

    var cancellationImpactText: String {
        "Canceling would save \(yearlyCostFormatted) per year"
    }

    var categoryEnum: SubscriptionCategory {
        SubscriptionCategory(rawValue: category) ?? .other
    }

    var effectiveCategory: String {
        if let customCategory, !customCategory.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return customCategory
        }
        return category
    }

    var trialStatus: String {
        guard isTrial else { return "Not a Trial" }
        if trialConvertedToPaid { return "Converted to Paid" }
        if trialDaysRemaining < 0 { return "Trial Ended" }
        if trialDaysRemaining == 0 { return "Ends Today" }
        return "\(trialDaysRemaining) Days Remaining"
    }

    var formattedNextBillingDate: String {
        nextBillingDate.formatted(.dateTime.month(.abbreviated).day().year())
    }
}
