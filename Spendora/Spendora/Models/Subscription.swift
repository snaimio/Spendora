//
//  Subscription.swift
//  Spendora
//
//  Capstone 2026 - Mobile Application Development
//  Author: Sheikh Naim
//

/**
 * Main/Core Functions & Purpose:
 * Subscription SwiftData model representing an active, trial, or cancelled subscription record.
 * Persists all metadata including name, cost, category, next billing date, payment method, notes, and trial flags.
 */

import Foundation
import SwiftData

@Model
final class Subscription {

    // MARK: - Properties

    var id: UUID = UUID()

    var name: String = ""

    var cost: Double = 0.0

    var category: String = "Other"

    var isYearly: Bool = false

    var nextBillingDate: Date = Date()

    var notes: String?

    var colorHex: String?

    var isTrial: Bool = false

    var trialEndDate: Date?

    var trialConvertedToPaid: Bool = false

    var expectedPrice: Double?

    var priceAlertEnabled: Bool = false

    var usageRating: Int = 3

    var customCategory: String?

    var paymentMethod: String?

    var tags: [String]?

    var currency: String = "USD"

    var isCancelled: Bool = false

    var cancellationDate: Date?

    var cancellationReason: String?

    var createdAt: Date = Date()

    // MARK: - Initializer

    init(
        id: UUID = UUID(),
        name: String,
        cost: Double,
        category: String = "Other",
        isYearly: Bool = false,
        nextBillingDate: Date = Date(),
        notes: String? = nil,
        colorHex: String? = nil,
        isTrial: Bool = false,
        trialEndDate: Date? = nil,
        trialConvertedToPaid: Bool = false,
        expectedPrice: Double? = nil,
        priceAlertEnabled: Bool = false,
        usageRating: Int = 3,
        customCategory: String? = nil,
        paymentMethod: String? = nil,
        tags: [String]? = nil,
        currency: String = "USD",
        isCancelled: Bool = false,
        cancellationDate: Date? = nil,
        cancellationReason: String? = nil
    ) {
        self.id = id
        self.name = name
        self.cost = cost
        self.category = category
        self.isYearly = isYearly
        self.nextBillingDate = nextBillingDate
        self.notes = notes
        self.colorHex = colorHex
        self.isTrial = isTrial
        self.trialEndDate = trialEndDate
        self.trialConvertedToPaid = trialConvertedToPaid
        self.expectedPrice = expectedPrice
        self.priceAlertEnabled = priceAlertEnabled
        self.usageRating = usageRating
        self.customCategory = customCategory
        self.paymentMethod = paymentMethod
        self.tags = tags
        self.currency = currency
        self.isCancelled = isCancelled
        self.cancellationDate = cancellationDate
        self.cancellationReason = cancellationReason
        self.createdAt = Date()
    }
}
