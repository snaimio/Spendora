/**
 * Main/Core Functions & Purpose:
 * Extension for Subscription model containing formatted string outputs, status descriptors,
 * category enums, and currency symbol resolutions.
 */

import Foundation
import SwiftUI

enum SubscriptionCategory: String, CaseIterable, Identifiable {
    case entertainment = "Entertainment"
    case music = "Music"
    case productivity = "Productivity"
    case ai = "AI & Tools"
    case health = "Health & Fitness"
    case shopping = "Shopping"
    case food = "Food & Dining"
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
        case .other: return "ellipsis.circle.fill"
        }
    }
}

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
