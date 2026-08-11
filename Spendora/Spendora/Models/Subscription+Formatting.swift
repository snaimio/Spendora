//
//  Subscription+Formatting.swift
//  Spendora
//

import Foundation
import SwiftUI

// MARK: - SubscriptionCategory

/**
 `SubscriptionCategory` represents subscription classification with Apple's refined system palette.
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
        case .entertainment: return Color(hex: "#FF2D55") // Apple Pink
        case .music: return Color(hex: "#AF52DE")         // Apple Purple
        case .productivity: return Color(hex: "#007AFF")   // Apple Blue
        case .ai: return Color(hex: "#32ADE6")            // Apple Cyan
        case .health: return Color(hex: "#34C759")         // Apple Green
        case .shopping: return Color(hex: "#FF9500")       // Apple Orange
        case .food: return Color(hex: "#FF3B30")           // Apple Red
        case .education: return Color(hex: "#5856D6")      // Apple Indigo
        case .gaming: return Color(hex: "#5E5CE6")         // Apple Violet
        case .utilities, .other: return Color(hex: "#8E8E93") // Apple Gray
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

    var canUndoPayment: Bool {
        previousBillingDate != nil
    }

    func markAsPaid() {
        let calendar = Calendar.current
        previousBillingDate = nextBillingDate
        lastPaymentDate = Date()
        
        if isYearly {
            if let next = calendar.date(byAdding: .year, value: 1, to: nextBillingDate) {
                nextBillingDate = next
            }
        } else {
            if let next = calendar.date(byAdding: .month, value: 1, to: nextBillingDate) {
                nextBillingDate = next
            }
        }
    }

    func undoPayment() {
        guard let prev = previousBillingDate else { return }
        nextBillingDate = prev
        previousBillingDate = nil
        lastPaymentDate = nil
    }
}
