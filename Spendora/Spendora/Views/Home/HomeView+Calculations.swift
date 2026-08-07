//
//  HomeView+Calculations.swift
//  Spendora
//

import SwiftUI

// MARK: - HomeView Extension

/**
 Extension on `HomeView` providing search filtering, sorting logic, active vs cancelled subscription separation,
 monthly/yearly spend aggregations, and upcoming billing lookups.
 */
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
    
    var activeSubscriptions: [Subscription] {
        filteredSubscriptions.filter { !$0.isCancelled }
    }
    
    var cancelledSubscriptions: [Subscription] {
        filteredSubscriptions.filter { $0.isCancelled }
    }
    
    var totalMonthly: Double {
        activeSubscriptions.reduce(0) { $0 + $1.monthlyCost }
    }
    
    var totalYearly: Double {
        activeSubscriptions.reduce(0) { $0 + $1.yearlyCost }
    }
    
    var subscriptionCount: Int {
        activeSubscriptions.count
    }
    
    var nextSubscription: Subscription? {
        subscriptions
            .filter { !$0.isCancelled && !$0.isOverdue }
            .sorted { $0.nextBillingDate < $1.nextBillingDate }
            .first
    }
}
