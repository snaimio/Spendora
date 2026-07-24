//
//  Subscription.swift
//  Spendora
//

import Foundation
import SwiftData

@Model
final class Subscription {

    // MARK: - Core Properties

    var id: UUID
    var name: String
    var cost: Double
    var isYearly: Bool
    var nextBillingDate: Date
    var category: String
    var createdAt: Date
    var notes: String?

    // MARK: - Trial Tracking

    var isTrial: Bool
    var trialEndDate: Date?
    var trialConvertedToPaid: Bool

    // MARK: - Price Monitoring

    var expectedPrice: Double?
    var priceAlertEnabled: Bool

    // MARK: - Custom Organization

    var customCategory: String?
    var paymentMethod: String?
    var tags: [String]?
    var currencyCode: String?
    var statusRaw: String?

    // MARK: - Appearance

    var colorHex: String?

    // MARK: - Usage Rating

    var usageRating: Int
    
    // MARK: - Cancellation Properties (NEW)
    var isCancelled: Bool
    var cancellationDate: Date?
    var cancellationReason: String?

    // MARK: - Initializer

    init(
        name: String,
        cost: Double,
        isYearly: Bool,
        nextBillingDate: Date,
        category: String = SubscriptionCategory.other.rawValue,
        notes: String? = nil,
        isTrial: Bool = false,
        trialEndDate: Date? = nil,
        expectedPrice: Double? = nil,
        priceAlertEnabled: Bool = false,
        customCategory: String? = nil,
        paymentMethod: String? = nil,
        tags: [String]? = nil,
        colorHex: String? = nil,
        usageRating: Int = 0,
        isCancelled: Bool = false,
        cancellationDate: Date? = nil,
        cancellationReason: String? = nil,
        currencyCode: String? = nil,
        statusRaw: String? = "Active"
    ) {
        self.id = UUID()
        self.name = name
        self.cost = cost
        self.isYearly = isYearly
        self.nextBillingDate = nextBillingDate
        self.category = category
        self.createdAt = Date()
        self.notes = notes

        self.isTrial = isTrial
        self.trialEndDate = trialEndDate
        self.trialConvertedToPaid = false

        self.expectedPrice = expectedPrice
        self.priceAlertEnabled = priceAlertEnabled

        self.customCategory = customCategory
        self.paymentMethod = paymentMethod
        self.tags = tags
        self.currencyCode = currencyCode
        self.statusRaw = statusRaw

        self.colorHex = colorHex
        self.usageRating = usageRating
        
        self.isCancelled = isCancelled
        self.cancellationDate = cancellationDate
        self.cancellationReason = cancellationReason
    }

    // MARK: - Currency & Status Helpers

    var currency: Currency {
        if let currencyCode, let matched = Currency.allCases.first(where: { $0.code == currencyCode }) {
            return matched
        }
        return CurrencyManager.shared.currentCurrency
    }

    var status: SubscriptionStatus {
        if isCancelled { return .cancelled }
        guard let statusRaw else { return .active }
        return SubscriptionStatus(rawValue: statusRaw) ?? .active
    }

    var normalizedMonthlyCost: Double {
        CurrencyManager.shared.convertToCurrent(amount: monthlyCost, from: currency)
    }

    var normalizedYearlyCost: Double {
        CurrencyManager.shared.convertToCurrent(amount: yearlyCost, from: currency)
    }

    // MARK: - Display Helpers

    var displayName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var formattedNextBillingDate: String {
        nextBillingDate.formatted(
            .dateTime
                .month(.abbreviated)
                .day()
                .year()
        )
    }

    var formattedCost: String {
        CurrencyManager.shared.format(cost, currency: currency)
    }

    var monthlyEquivalentDescription: String {
        if isYearly {
            return "\(formattedCost)/year (\(monthlyCostFormatted)/month)"
        } else {
            return "\(formattedCost)/month"
        }
    }

    // MARK: - Billing Calculations

    var monthlyCost: Double {
        guard cost > 0 else { return 0 }
        return isYearly ? cost / 12 : cost
    }

    var yearlyCost: Double {
        guard cost > 0 else { return 0 }
        return isYearly ? cost : cost * 12
    }

    var monthlyCostFormatted: String {
        monthlyCost.formatted(
            .currency(
                code: Locale.current.currency?.identifier ?? "USD"
            )
        )
    }

    var yearlyCostFormatted: String {
        yearlyCost.formatted(
            .currency(
                code: Locale.current.currency?.identifier ?? "USD"
            )
        )
    }

    // MARK: - Analytics Properties

    var annualSavingsIfCancelled: Double {
        yearlyCost
    }

    var averageMonthlyCost: Double {
        monthlyCost
    }

    var usageRatingStars: String {
        String(repeating: "⭐️", count: normalizedUsageRating)
    }

    var cancellationImpactText: String {
        "Canceling would save \(yearlyCostFormatted) per year"
    }

    var healthScore: Int {
        var score = 100

        if isOverdue {
            score -= 20
        }

        if trialWarning {
            score -= 10
        }

        if priceIncreased {
            score -= 10
        }

        return max(score, 0)
    }

    // MARK: - Billing Status

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

    // MARK: - Validation

    var isValid: Bool {
        !displayName.isEmpty &&
        cost > 0 &&
        nextBillingDate > Date()
    }

    // MARK: - Category Helpers

    var categoryEnum: SubscriptionCategory {
        SubscriptionCategory(rawValue: category) ?? .other
    }

    var effectiveCategory: String {
        if let customCategory,
           !customCategory.trimmingCharacters(
                in: .whitespacesAndNewlines
           ).isEmpty {
            return customCategory
        }

        return category
    }

    // MARK: - Payment Helpers

    var effectivePaymentMethod: String {
        paymentMethod ?? "Not Set"
    }

    // MARK: - Tags

    var tagsList: [String] {
        get { tags ?? [] }
        set { tags = newValue }
    }

    // MARK: - Usage Rating

    var normalizedUsageRating: Int {
        min(max(usageRating, 0), 5)
    }

    // MARK: - Trial Features

    var trialDaysRemaining: Int {
        guard isTrial,
              let trialEndDate
        else {
            return 0
        }

        return Calendar.current.dateComponents(
            [.day],
            from: Calendar.current.startOfDay(for: Date()),
            to: Calendar.current.startOfDay(for: trialEndDate)
        ).day ?? 0
    }

    var trialWarning: Bool {
        isTrial &&
        !trialConvertedToPaid &&
        (0...3).contains(trialDaysRemaining)
    }

    var trialStatus: String {

        guard isTrial else {
            return "Not a Trial"
        }

        if trialConvertedToPaid {
            return "Converted to Paid"
        }

        if trialDaysRemaining < 0 {
            return "Trial Ended"
        }

        if trialDaysRemaining == 0 {
            return "Ends Today"
        }

        return "\(trialDaysRemaining) Days Remaining"
    }

    // MARK: - Price Monitoring

    var priceIncreased: Bool {
        guard priceAlertEnabled,
              let expectedPrice
        else {
            return false
        }

        // Avoid floating-point edge cases
        return cost > expectedPrice + 0.001
    }

    var priceIncreaseAmount: Double {
        guard priceAlertEnabled,
              let expectedPrice
        else {
            return 0
        }

        return max(0, cost - expectedPrice)
    }

    var percentageIncrease: Double {
        guard priceAlertEnabled,
              let expectedPrice,
              expectedPrice > 0
        else {
            return 0
        }

        return ((cost - expectedPrice) / expectedPrice) * 100
    }
    
    // MARK: - Cancellation Helpers (NEW)
    
    var formattedCancellationDate: String {
        guard let cancellationDate = cancellationDate else {
            return "Not cancelled"
        }
        return cancellationDate.formatted(
            .dateTime
                .month(.abbreviated)
                .day()
                .year()
        )
    }
    
    var cancellationStatus: String {
        if isCancelled {
            return "Cancelled"
        } else {
            return "Active"
        }
    }
}

// MARK: - Categories

enum SubscriptionCategory: String, CaseIterable, Identifiable {

    case entertainment = "Entertainment"
    case productivity = "Productivity"
    case health = "Health & Fitness"
    case shopping = "Shopping"
    case food = "Food & Dining"
    case education = "Education"
    case other = "Other"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .entertainment:
            return "tv.fill"

        case .productivity:
            return "briefcase.fill"

        case .health:
            return "heart.fill"

        case .shopping:
            return "bag.fill"

        case .food:
            return "fork.knife"

        case .education:
            return "book.fill"

        case .other:
            return "tag.fill"
        }
    }

    var colorSystemName: String {
        switch self {
        case .entertainment:
            return "purple"

        case .productivity:
            return "blue"

        case .health:
            return "green"

        case .shopping:
            return "orange"

        case .food:
            return "red"

        case .education:
            return "indigo"

        case .other:
            return "gray"
        }
    }
}

// MARK: - Payment Methods

enum PaymentMethod: String, CaseIterable, Identifiable {

    case creditCard = "💳 Credit Card"
    case debitCard = "💳 Debit Card"
    case paypal = "💰 PayPal"
    case applePay = "📱 Apple Pay"
    case googlePay = "📱 Google Pay"
    case bankTransfer = "🏦 Bank Transfer"
    case other = "🔵 Other"

    var id: String { rawValue }
}

// MARK: - Subscription Status

enum SubscriptionStatus: String, CaseIterable, Identifiable {
    case active = "Active"
    case paused = "Paused"
    case cancelled = "Cancelled"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .active: return "checkmark.circle.fill"
        case .paused: return "pause.circle.fill"
        case .cancelled: return "xmark.circle.fill"
        }
    }

    var colorSystemName: String {
        switch self {
        case .active: return "green"
        case .paused: return "orange"
        case .cancelled: return "red"
        }
    }
}
