//
//  Subscription.swift
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

    // MARK: - Core Subscription Metadata Properties

    /// Unique identifier for each subscription record
    var id: UUID = UUID()  // id property

    /// Display name of the subscription service (e.g. Netflix, Spotify, iCloud)
    var name: String = ""  // name property

    /// Billing cost amount per billing cycle
    var cost: Double = 0.0  // cost property

    /// Category classification (e.g. Entertainment, Utilities, Productivity)
    var category: String = "Other"  // category property

    /// Flag indicating whether billing cycle is yearly (true) or monthly (false)
    var isYearly: Bool = false  // isYearly property

    /// Flag indicating whether this is a one-time / lifetime purchase
    var isOneTime: Bool = false  // isOneTime property

    /// Direct web link URL for cancellation or managing account (e.g. https://netflix.com/account)
    var linkURL: String?  // linkURL property

    /// Next scheduled renewal / billing charge date
    var nextBillingDate: Date = Date()  // nextBillingDate property

    /// Optional user notes or reminders regarding this subscription
    var notes: String?  // notes property

    /// Accent theme color hex code string for UI card rendering
    var colorHex: String?  // colorHex property

    /// Flag indicating if this subscription is currently on a free trial period
    var isTrial: Bool = false  // isTrial property

    /// Expiration date for free trial period if isTrial is true
    var trialEndDate: Date?  // trialEndDate property

    /// Tracks whether trial successfully converted into a paid subscription
    var trialConvertedToPaid: Bool = false  // trialConvertedToPaid property

    /// Expected baseline cost used for price change alert warnings
    var expectedPrice: Double?  // expectedPrice property

    /// Toggle flag to enable notification alerts when cost exceeds expected price
    var priceAlertEnabled: Bool = false  // priceAlertEnabled property

    /// User utility rating from 1 to 5 stars measuring subscription value
    var usageRating: Int = 3  // usageRating property

    /// Custom user-defined category override string
    var customCategory: String?  // customCategory property

    /// Payment method used (e.g. Credit Card, Apple Pay, PayPal)
    var paymentMethod: String?  // paymentMethod property

    /// Optional search and filter tag strings
    var tags: [String]?  // tags property

    /// Currency code string (e.g. CAD, USD, EUR, GBP)
    var currency: String = "USD"  // currency property

    /// Status flag indicating if subscription was cancelled
    var isCancelled: Bool = false  // isCancelled property

    /// Date when subscription was marked as cancelled
    var cancellationDate: Date?  // cancellationDate property

    /// User-provided reason for cancelling subscription
    var cancellationReason: String?  // cancellationReason property

    /// Customizable notification reminder days before billing date (e.g. 0, 1, 3, 7 days, or -1 for disabled)
    var reminderDaysBefore: Int = 3  // reminderDaysBefore property

    /// Timestamp when record was created in app
    var createdAt: Date = Date()  // createdAt property

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
        cancellationReason: String? = nil,
        reminderDaysBefore: Int = 3
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
        self.reminderDaysBefore = reminderDaysBefore
        self.createdAt = Date()
    }
}
