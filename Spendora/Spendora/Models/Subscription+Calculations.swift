//
//  Subscription+Calculations.swift
//

/**
 * Main/Core Functions & Purpose:
 * Extension for Subscription model containing cost calculations, billing cycle conversions,
 * health score algorithms, and trial days countdown calculations.
 */

import Foundation


// MARK: - Subscription Extension

/**
 Extension on `Subscription` providing utility methods and helpers.
 */
extension Subscription {
    
    /// Normalizes cost to a monthly figure (divides yearly cost by 12, or returns monthly cost as is)
    var monthlyCost: Double {  // monthlyCost property
        isYearly ? cost / 12.0 : cost
    }

    /// Normalizes cost to a yearly total (multiplies monthly cost by 12, or returns yearly cost as is)
    var yearlyCost: Double {  // yearlyCost property
        isYearly ? cost : cost * 12.0
    }

    /// Calculated average monthly expenditure for analytics
    var averageMonthlyCost: Double {  // averageMonthlyCost property
        monthlyCost
    }

    /// Computes subscription health score out of 100 based on overdue status, trial warnings, and price increases
    var healthScore: Int {  // healthScore property
        var score = 100
        if isOverdue { score -= 20 }
        if trialWarning { score -= 10 }
        if priceIncreased { score -= 10 }
        return max(score, 0)
    }

    /// Calculates exact number of calendar days remaining until the next billing charge date
    var daysUntilBilling: Int {  // daysUntilBilling property
        Calendar.current.dateComponents(
            [.day],
            from: Calendar.current.startOfDay(for: Date()),
            to: Calendar.current.startOfDay(for: nextBillingDate)
        ).day ?? 0
    }

    /// Returns true if next billing date falls within the upcoming 7 days
    var isUpcoming: Bool {  // isUpcoming property
        (0...7).contains(daysUntilBilling)
    }

    /// Returns true if billing date matches current calendar day
    var isDueToday: Bool {  // isDueToday property
        Calendar.current.isDateInToday(nextBillingDate)
    }

    /// Returns true if next billing date has passed relative to start of today
    var isOverdue: Bool {  // isOverdue property
        nextBillingDate < Calendar.current.startOfDay(for: Date())
    }

    /// Validates that name is not empty, cost is positive, and next billing date is in the future
    var isValid: Bool {  // isValid property
        !displayName.isEmpty && cost > 0 && nextBillingDate > Date()
    }

    /// Clamps user usage rating between 0 and 5 stars
    var normalizedUsageRating: Int {  // normalizedUsageRating property
        min(max(usageRating, 0), 5)
    }

    /// Computes days remaining before free trial period expires
    var trialDaysRemaining: Int {  // trialDaysRemaining property
        guard isTrial, let trialEndDate else { return 0 }
        return Calendar.current.dateComponents(
            [.day],
            from: Calendar.current.startOfDay(for: Date()),
            to: Calendar.current.startOfDay(for: trialEndDate)
        ).day ?? 0
    }

    /// Returns true if trial expires within 3 days and has not been marked as converted
    var trialWarning: Bool {  // trialWarning property
        isTrial && !trialConvertedToPaid && (0...3).contains(trialDaysRemaining)
    }

    /// Detects whether current cost exceeds baseline expected price
    var priceIncreased: Bool {  // priceIncreased property
        guard priceAlertEnabled, let expectedPrice else { return false }
        return cost > expectedPrice + 0.001
    }

    /// Calculates monetary difference between current cost and expected price
    var priceIncreaseAmount: Double {  // priceIncreaseAmount property
        guard priceAlertEnabled, let expectedPrice else { return 0 }
        return max(0, cost - expectedPrice)
    }

    /// Calculates percentage increase relative to expected price
    var percentageIncrease: Double {  // percentageIncrease property
        guard priceAlertEnabled, let expectedPrice, expectedPrice > 0 else { return 0 }
        return ((cost - expectedPrice) / expectedPrice) * 100
    }
}
