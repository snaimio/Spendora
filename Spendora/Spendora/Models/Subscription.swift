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
    
    init(name: String, cost: Double, isYearly: Bool, nextBillingDate: Date, category: String = "Other", notes: String? = nil) {
        self.id = UUID()
        self.name = name
        self.cost = cost
        self.isYearly = isYearly
        self.nextBillingDate = nextBillingDate
        self.category = category
        self.createdAt = Date()
        self.notes = notes
    }
    
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
}

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
