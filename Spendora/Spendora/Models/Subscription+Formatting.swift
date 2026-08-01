//
//  Subscription+Formatting.swift
//

/**
 * Main/Core Functions & Purpose:
 * Extension for Subscription model containing formatted string outputs, status descriptors,
 * category enums, and currency symbol resolutions.
 */

import Foundation
import SwiftUI


// MARK: - SubscriptionCategory

/**
 `SubscriptionCategory` is a enum that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for subscriptioncategory handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `SubscriptionCategory` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
enum SubscriptionCategory: String, CaseIterable, Identifiable {

    // MARK: - Properties

    case entertainment = "Entertainment"
    case music = "Music"
    case productivity = "Productivity"
    case ai = "AI & Tools"
    case health = "Health & Fitness"
    case shopping = "Shopping"
    case food = "Food & Dining"
    case other = "Other"

    var id: String { rawValue }  // id property

    var icon: String {  // icon property
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


// MARK: - Subscription Extension

/**
 Extension on `Subscription` providing utility methods and helpers.
 */
extension Subscription {
    
    var displayName: String { name }  // displayName property

    var formattedCost: String {  // formattedCost property
        CurrencyManager.shared.format(cost)
    }

    var monthlyCostFormatted: String {  // monthlyCostFormatted property
        CurrencyManager.shared.format(monthlyCost)
    }

    var yearlyCostFormatted: String {  // yearlyCostFormatted property
        CurrencyManager.shared.format(yearlyCost)
    }

    var billingFrequencyText: String {  // billingFrequencyText property
        isYearly ? "/ year" : "/ month"
    }

    var usageRatingStars: String {  // usageRatingStars property
        String(repeating: "⭐️", count: normalizedUsageRating)
    }

    var cancellationImpactText: String {  // cancellationImpactText property
        "Canceling would save \(yearlyCostFormatted) per year"
    }

    var categoryEnum: SubscriptionCategory {  // categoryEnum property
        SubscriptionCategory(rawValue: category) ?? .other
    }

    var effectiveCategory: String {  // effectiveCategory property
        if let customCategory, !customCategory.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return customCategory
        }
        return category
    }

    var trialStatus: String {  // trialStatus property
        guard isTrial else { return "Not a Trial" }
        if trialConvertedToPaid { return "Converted to Paid" }
        if trialDaysRemaining < 0 { return "Trial Ended" }
        if trialDaysRemaining == 0 { return "Ends Today" }
        return "\(trialDaysRemaining) Days Remaining"
    }

    var formattedNextBillingDate: String {  // formattedNextBillingDate property
        nextBillingDate.formatted(.dateTime.month(.abbreviated).day().year())
    }
}
