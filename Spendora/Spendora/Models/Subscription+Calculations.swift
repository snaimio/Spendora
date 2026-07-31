//
//  Subscription+Calculations.swift
//  Spendora
//
//  Capstone 2026 - Mobile Application Development
//  Author: Sheikh Naim
//

/**
 * Main/Core Functions & Purpose:
 * Extension for Subscription model containing cost calculations, billing cycle conversions,
 * health score algorithms, and trial days countdown calculations.
 */

import Foundation

extension Subscription {
    
    var monthlyCost: Double {
        isYearly ? cost / 12.0 : cost
    }

    var yearlyCost: Double {
        isYearly ? cost : cost * 12.0
    }

    var averageMonthlyCost: Double {
        monthlyCost
    }

    var healthScore: Int {
        var score = 100
        if isOverdue { score -= 20 }
        if trialWarning { score -= 10 }
        if priceIncreased { score -= 10 }
        return max(score, 0)
    }

    var daysUntilBilling: Int {
        Calendar.current.dateComponents(
            [.day],
            from: Calendar.current.startOfDay(for: Date()),
            to: Calendar.current.startOfDay(for: nextBillingDate)
        ).day ?? 0
    }

    var isUpcoming: Bool {
        (0...7).contains(daysUntilBilling)
    }

    var isDueToday: Bool {
        Calendar.current.isDateInToday(nextBillingDate)
    }

    var isOverdue: Bool {
        nextBillingDate < Calendar.current.startOfDay(for: Date())
    }

    var isValid: Bool {
        !displayName.isEmpty && cost > 0 && nextBillingDate > Date()
    }

    var normalizedUsageRating: Int {
        min(max(usageRating, 0), 5)
    }

    var trialDaysRemaining: Int {
        guard isTrial, let trialEndDate else { return 0 }
        return Calendar.current.dateComponents(
            [.day],
            from: Calendar.current.startOfDay(for: Date()),
            to: Calendar.current.startOfDay(for: trialEndDate)
        ).day ?? 0
    }

    var trialWarning: Bool {
        isTrial && !trialConvertedToPaid && (0...3).contains(trialDaysRemaining)
    }

    var priceIncreased: Bool {
        guard priceAlertEnabled, let expectedPrice else { return false }
        return cost > expectedPrice + 0.001
    }

    var priceIncreaseAmount: Double {
        guard priceAlertEnabled, let expectedPrice else { return 0 }
        return max(0, cost - expectedPrice)
    }

    var percentageIncrease: Double {
        guard priceAlertEnabled, let expectedPrice, expectedPrice > 0 else { return 0 }
        return ((cost - expectedPrice) / expectedPrice) * 100
    }
}
