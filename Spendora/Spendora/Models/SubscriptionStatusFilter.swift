//
//  SubscriptionStatusFilter.swift
//  Spendora
//

import Foundation

// MARK: - SubscriptionStatusFilter

enum SubscriptionStatusFilter: String, CaseIterable, Identifiable {
    case active = "Active"
    case cancelled = "Cancelled"
    case all = "All"
    
    var id: String { rawValue }
}
