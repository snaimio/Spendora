//
//  BudgetService.swift
//

/**
 * Main/Core Functions & Purpose:
 * BudgetService singleton class managing overall monthly and yearly spending caps.
 * Handles category-level budget limits, spending alerts, budget status calculations (under/over budget),
 * and persists configuration locally in UserDefaults.
 */

import Foundation
import SwiftUI


// MARK: - BudgetService

/**
 `BudgetService` is a class that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for budgetservice handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `BudgetService` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
class BudgetService {

    // MARK: - Properties

    /// Shared singleton instance for app-wide budget calculations
    static let shared = BudgetService()

    private let defaults = UserDefaults.standard
    private let budgetKey = "monthlyBudget"
    private let yearlyBudgetKey = "yearlyBudget"
    private let categoryBudgetsKey = "categoryBudgets"

    /// Overall monthly spending budget limit
    var monthlyBudget: Double {  // monthlyBudget property
        get { defaults.double(forKey: budgetKey) }
        set { defaults.set(newValue, forKey: budgetKey) }
    }

    var yearlyBudget: Double {  // yearlyBudget property
        get {
            let val = defaults.double(forKey: yearlyBudgetKey)
            return val > 0 ? val : monthlyBudget * 12
        }
        set { defaults.set(newValue, forKey: yearlyBudgetKey) }
    }


    /**
     Executes `categoryBudget` for component logic.
     
     - Parameter category: Value passed to `categoryBudget`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func categoryBudget(for category: String) -> Double {
        let dict = defaults.dictionary(forKey: categoryBudgetsKey) as? [String: Double] ?? [:]
        return dict[category] ?? 0.0
    }


    /**
     Executes `setCategoryBudget` for component logic.
     
     - Parameter amount: Value passed to `setCategoryBudget`.
     - Parameter category: Value passed to `setCategoryBudget`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func setCategoryBudget(_ amount: Double, for category: String) {
        var dict = defaults.dictionary(forKey: categoryBudgetsKey) as? [String: Double] ?? [:]
        dict[category] = amount
        defaults.set(dict, forKey: categoryBudgetsKey)
    }


    /**
     Executes `progressRatio` for component logic.
     
     - Parameter currentSpending: Value passed to `progressRatio`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func progressRatio(currentSpending: Double) -> Double {
        guard monthlyBudget > 0 else { return 0.0 }
        return min(max(currentSpending / monthlyBudget, 0.0), 1.0)
    }


    /**
     Executes `isOverBudget` for component logic.
     
     - Parameter currentSpending: Value passed to `isOverBudget`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func isOverBudget(currentSpending: Double) -> Bool {
        guard monthlyBudget > 0 else { return false }
        return currentSpending > monthlyBudget
    }


    /**
     Executes `remainingBudget` for component logic.
     
     - Parameter currentSpending: Value passed to `remainingBudget`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func remainingBudget(currentSpending: Double) -> Double {
        monthlyBudget - currentSpending
    }


    /**
     Executes `budgetStatus` for component logic.
     
     - Parameter currentSpending: Value passed to `budgetStatus`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
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
