//
//  BudgetServiceTests.swift
//

import XCTest
import SwiftUI 
@testable import Spendora

final class BudgetServiceTests: XCTestCase {
    
    var budgetService: BudgetService!  // budgetService property
    

    /**
     Executes `setUp` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    override func setUp() {
        super.setUp()
        budgetService = BudgetService.shared
        budgetService.monthlyBudget = 100
    }
    

    /**
     Executes `tearDown` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    override func tearDown() {
        budgetService.monthlyBudget = 0
        budgetService = nil
        super.tearDown()
    }
    

    /**
     Executes `testIsOverBudget_WhenOverBudget` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func testIsOverBudget_WhenOverBudget() {
        XCTAssertTrue(budgetService.isOverBudget(currentSpending: 150))
        XCTAssertTrue(budgetService.isOverBudget(currentSpending: 101))
    }
    

    /**
     Executes `testIsOverBudget_WhenUnderBudget` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func testIsOverBudget_WhenUnderBudget() {
        XCTAssertFalse(budgetService.isOverBudget(currentSpending: 50))
        XCTAssertFalse(budgetService.isOverBudget(currentSpending: 100))
    }
    

    /**
     Executes `testIsOverBudget_WhenNoBudgetSet` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func testIsOverBudget_WhenNoBudgetSet() {
        budgetService.monthlyBudget = 0
        XCTAssertFalse(budgetService.isOverBudget(currentSpending: 150))
    }
    

    /**
     Executes `testRemainingBudget_CalculatesCorrectly` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func testRemainingBudget_CalculatesCorrectly() {
        XCTAssertEqual(budgetService.remainingBudget(currentSpending: 30), 70)
        XCTAssertEqual(budgetService.remainingBudget(currentSpending: 100), 0)
        XCTAssertEqual(budgetService.remainingBudget(currentSpending: 120), -20)
    }
    

    /**
     Executes `testBudgetStatus_OnTrack` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func testBudgetStatus_OnTrack() {
        let (status, color) = budgetService.budgetStatus(currentSpending: 30)
        XCTAssertTrue(status.contains("On track"))
        XCTAssertEqual(color, .green)
    }
    

    /**
     Executes `testBudgetStatus_OverBudget` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func testBudgetStatus_OverBudget() {
        let (status, color) = budgetService.budgetStatus(currentSpending: 120)
        XCTAssertTrue(status.contains("Over budget"))
        XCTAssertEqual(color, .red)
    }
    

    /**
     Executes `testBudgetStatus_NoBudgetSet` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func testBudgetStatus_NoBudgetSet() {
        budgetService.monthlyBudget = 0
        let (status, color) = budgetService.budgetStatus(currentSpending: 50)
        XCTAssertEqual(status, "Set a budget")
        XCTAssertEqual(color, .gray)
    }
}
