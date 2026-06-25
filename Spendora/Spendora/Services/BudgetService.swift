//
//  BudgetService.swift
//  Spendora
//

import Foundation
import SwiftUI

class BudgetService {
    static let shared = BudgetService()
    
    private let defaults = UserDefaults.standard
    private let budgetKey = "monthlyBudget"
    
    var monthlyBudget: Double {
        get { defaults.double(forKey: budgetKey) }
        set { defaults.set(newValue, forKey: budgetKey) }
    }
    
    func isOverBudget(currentSpending: Double) -> Bool {
        guard monthlyBudget > 0 else { return false }
        return currentSpending > monthlyBudget
    }
    
    func remainingBudget(currentSpending: Double) -> Double {
        return monthlyBudget - currentSpending
    }
    
    func budgetStatus(currentSpending: Double) -> (status: String, color: Color) {
        guard monthlyBudget > 0 else { return ("Set a budget", .gray) }
        let remaining = remainingBudget(currentSpending: currentSpending)
        if remaining < 0 {
            return ("⚠️ Over budget by \(CurrencyManager.shared.format(abs(remaining)))", .red)
        } else if remaining < 10 {
            return ("⚠️ Approaching limit: \(CurrencyManager.shared.format(remaining)) left", .orange)
        } else {
            return ("✅ On track: \(CurrencyManager.shared.format(remaining)) remaining", .green)
        }
    }
}
