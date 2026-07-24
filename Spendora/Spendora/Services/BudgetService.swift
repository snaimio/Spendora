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
    private let yearlyBudgetKey = "yearlyBudget"
    private let categoryBudgetsKey = "categoryBudgets"

    var monthlyBudget: Double {
        get { defaults.double(forKey: budgetKey) }
        set { defaults.set(newValue, forKey: budgetKey) }
    }

    var yearlyBudget: Double {
        get {
            let val = defaults.double(forKey: yearlyBudgetKey)
            return val > 0 ? val : monthlyBudget * 12
        }
        set { defaults.set(newValue, forKey: yearlyBudgetKey) }
    }

    func categoryBudget(for category: String) -> Double {
        let dict = defaults.dictionary(forKey: categoryBudgetsKey) as? [String: Double] ?? [:]
        return dict[category] ?? 0.0
    }

    func setCategoryBudget(_ amount: Double, for category: String) {
        var dict = defaults.dictionary(forKey: categoryBudgetsKey) as? [String: Double] ?? [:]
        dict[category] = amount
        defaults.set(dict, forKey: categoryBudgetsKey)
    }

    func progressRatio(currentSpending: Double) -> Double {
        guard monthlyBudget > 0 else { return 0.0 }
        return min(max(currentSpending / monthlyBudget, 0.0), 1.0)
    }

    func isOverBudget(currentSpending: Double) -> Bool {
        guard monthlyBudget > 0 else { return false }
        return currentSpending > monthlyBudget
    }

    func remainingBudget(currentSpending: Double) -> Double {
        monthlyBudget - currentSpending
    }

    func budgetStatus(currentSpending: Double) -> (status: String, color: Color) {
        guard monthlyBudget > 0 else {
            return ("Set a budget", .gray)
        }

        let remaining = remainingBudget(currentSpending: currentSpending)
        let ratio = progressRatio(currentSpending: currentSpending)

        if remaining < 0 {
            return (
                "⚠️ Over budget by \(CurrencyManager.shared.format(abs(remaining)))",
                .red
            )
        } else if ratio >= 0.85 {
            return (
                "⚠️ Warning: \(CurrencyManager.shared.format(remaining)) left (\(Int(ratio * 100))% used)",
                .orange
            )
        } else {
            return (
                "✅ On track: \(CurrencyManager.shared.format(remaining)) remaining",
                .green
            )
        }
    }
}
