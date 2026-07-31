//
//  HomeView+Calculations.swift
//  Spendora
//
//  Capstone 2026 - Mobile Application Development
//  Author: Sheikh Naim
//

/**
 * Main/Core Functions & Purpose:
 * Extension for HomeView containing search filtering, sorting logic, monthly/yearly spend aggregations,
 * and upcoming billing subscription lookups.
 */

import SwiftUI

extension HomeView {
    
    var sortedSubscriptions: [Subscription] {
        switch sortOption {
        case .alphabetical:
            return subscriptions.sorted { $0.displayName < $1.displayName }
        case .cost:
            return subscriptions.sorted { $0.monthlyCost > $1.monthlyCost }
        case .cheapest:
            return subscriptions.sorted { $0.monthlyCost < $1.monthlyCost }
        case .renewalDate:
            return subscriptions.sorted { $0.nextBillingDate < $1.nextBillingDate }
        case .category:
            return subscriptions.sorted { $0.effectiveCategory < $1.effectiveCategory }
        case .recentlyAdded:
            return subscriptions.sorted { $0.createdAt > $1.createdAt }
        }
    }
    
    var filteredSubscriptions: [Subscription] {
        if searchText.isEmpty { return sortedSubscriptions }
        return sortedSubscriptions.filter {
            $0.displayName.localizedCaseInsensitiveContains(searchText) ||
            $0.effectiveCategory.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var totalMonthly: Double {
        filteredSubscriptions.reduce(0) { $0 + $1.monthlyCost }
    }
    
    var totalYearly: Double {
        filteredSubscriptions.reduce(0) { $0 + $1.yearlyCost }
    }
    
    var subscriptionCount: Int {
        filteredSubscriptions.count
    }
    
    var nextSubscription: Subscription? {
        subscriptions
            .filter { !$0.isOverdue }
            .sorted { $0.nextBillingDate < $1.nextBillingDate }
            .first
    }
}
