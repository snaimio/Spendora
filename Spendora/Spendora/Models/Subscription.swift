//
//  Subscription.swift
//  Spendora
//

import Foundation
import SwiftData

@Model
final class Subscription {
    var id: UUID
    var name: String
    var cost: Double
    var isYearly: Bool
    var nextBillingDate: Date
    var category: String
    var createdAt: Date
    var notes: String?
    
    // Free Trial Properties
    var isTrial: Bool
    var trialEndDate: Date?
    var trialConvertedToPaid: Bool
    
    // Price Alert Properties
    var expectedPrice: Double?
    var priceAlertEnabled: Bool
    
    // Custom Category
    var customCategory: String?
    
    init(
        name: String,
        cost: Double,
        isYearly: Bool,
        nextBillingDate: Date,
        category: String = "Other",
        notes: String? = nil,
        isTrial: Bool = false,
        trialEndDate: Date? = nil,
        expectedPrice: Double? = nil,
        priceAlertEnabled: Bool = false,
        customCategory: String? = nil
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
    }
    
    // MARK: - Computed Properties
    var monthlyCost: Double {
        guard cost > 0 else { return 0 }
        return isYearly ? cost / 12 : cost
    }
    
    var yearlyCost: Double {
        guard cost > 0 else { return 0 }
        return isYearly ? cost : cost * 12
    }
    
    var isUpcoming: Bool {
        let daysUntilBilling = Calendar.current.dateComponents([.day], from: Date(), to: nextBillingDate).day ?? 0
        return daysUntilBilling <= 7 && daysUntilBilling >= 0
    }
    
    var daysUntilBilling: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: nextBillingDate).day ?? 0
    }
    
    var formattedNextBillingDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: nextBillingDate)
    }
    
    var displayName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isValid: Bool {
        !displayName.isEmpty && cost > 0 && nextBillingDate > Date()
    }
    
    var effectiveCategory: String {
        if let customCategory = customCategory, !customCategory.isEmpty {
            return customCategory
        }
        return category
    }
    
    // MARK: - Free Trial Computed Properties
    var trialDaysRemaining: Int {
        guard isTrial, let endDate = trialEndDate else { return 0 }
        return Calendar.current.dateComponents([.day], from: Date(), to: endDate).day ?? 0
    }
    
    var trialStatus: String {
        guard isTrial else { return "Not a trial" }
        if trialConvertedToPaid { return "Converted to paid" }
        let days = trialDaysRemaining
        if days < 0 { return "Trial ended" }
        if days == 0 { return "Ends today" }
        return "\(days) days remaining"
    }
    
    var trialWarning: Bool {
        isTrial && !trialConvertedToPaid && trialDaysRemaining <= 3 && trialDaysRemaining >= 0
    }
    
    // MARK: - Price Alert Computed Properties
    var priceIncreased: Bool {
        guard priceAlertEnabled, let expected = expectedPrice else { return false }
        return cost > expected
    }
    
    var priceIncreaseAmount: Double {
        guard priceAlertEnabled, let expected = expectedPrice else { return 0 }
        return cost - expected
    }
}

// MARK: - Category Enum
enum SubscriptionCategory: String, CaseIterable {
    case entertainment = "Entertainment"
    case productivity = "Productivity"
    case health = "Health & Fitness"
    case shopping = "Shopping"
    case food = "Food & Dining"
    case education = "Education"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .entertainment: return "tv.fill"
        case .productivity: return "briefcase.fill"
        case .health: return "heart.fill"
        case .shopping: return "bag.fill"
        case .food: return "fork.knife"
        case .education: return "book.fill"
        case .other: return "tag.fill"
        }
    }
}
