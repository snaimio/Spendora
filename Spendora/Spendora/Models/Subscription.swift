/**
 * Main/Core Functions & Purpose:
 * Subscription SwiftData model representing an active, trial, or cancelled subscription record.
 * Persists all metadata including name, cost, category, next billing date, payment method, notes, and trial flags.
 */

import Foundation
import SwiftData

@Model
final class Subscription {

    // MARK: - Core Subscription Metadata Properties

    /// Unique identifier for each subscription record
    var id: UUID = UUID()

    /// Display name of the subscription service (e.g. Netflix, Spotify, iCloud)
    var name: String = ""

    /// Billing cost amount per billing cycle
    var cost: Double = 0.0

    /// Category classification (e.g. Entertainment, Utilities, Productivity)
    var category: String = "Other"

    /// Flag indicating whether billing cycle is yearly (true) or monthly (false)
    var isYearly: Bool = false

    /// Next scheduled renewal / billing charge date
    var nextBillingDate: Date = Date()

    /// Optional user notes or reminders regarding this subscription
    var notes: String?

    /// Accent theme color hex code string for UI card rendering
    var colorHex: String?

    /// Flag indicating if this subscription is currently on a free trial period
    var isTrial: Bool = false

    /// Expiration date for free trial period if isTrial is true
    var trialEndDate: Date?

    /// Tracks whether trial successfully converted into a paid subscription
    var trialConvertedToPaid: Bool = false

    /// Expected baseline cost used for price change alert warnings
    var expectedPrice: Double?

    /// Toggle flag to enable notification alerts when cost exceeds expected price
    var priceAlertEnabled: Bool = false

    /// User utility rating from 1 to 5 stars measuring subscription value
    var usageRating: Int = 3

    /// Custom user-defined category override string
    var customCategory: String?

    /// Payment method used (e.g. Credit Card, Apple Pay, PayPal)
    var paymentMethod: String?

    /// Optional search and filter tag strings
    var tags: [String]?

    /// Currency code string (e.g. CAD, USD, EUR, GBP)
    var currency: String = "USD"

    /// Status flag indicating if subscription was cancelled
    var isCancelled: Bool = false

    /// Date when subscription was marked as cancelled
    var cancellationDate: Date?

    /// User-provided reason for cancelling subscription
    var cancellationReason: String?

    /// Timestamp when record was created in app
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
