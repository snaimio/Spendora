//
//  BudgetServiceTests.swift
//  SpendoraTests
//

import XCTest
import SwiftUI 
@testable import Spendora

final class BudgetServiceTests: XCTestCase {
    
    var budgetService: BudgetService!
    
    override func setUp() {
        super.setUp()
        budgetService = BudgetService.shared
        budgetService.monthlyBudget = 100
    }
    
    override func tearDown() {
        budgetService.monthlyBudget = 0
        budgetService = nil
        super.tearDown()
    }
    
    func testIsOverBudget_WhenOverBudget() {
        XCTAssertTrue(budgetService.isOverBudget(currentSpending: 150))
        XCTAssertTrue(budgetService.isOverBudget(currentSpending: 101))
    }
    
    func testIsOverBudget_WhenUnderBudget() {
        XCTAssertFalse(budgetService.isOverBudget(currentSpending: 50))
        XCTAssertFalse(budgetService.isOverBudget(currentSpending: 100))
    }
    
    func testIsOverBudget_WhenNoBudgetSet() {
        budgetService.monthlyBudget = 0
        XCTAssertFalse(budgetService.isOverBudget(currentSpending: 150))
    }
    
    func testRemainingBudget_CalculatesCorrectly() {
        XCTAssertEqual(budgetService.remainingBudget(currentSpending: 30), 70)
        XCTAssertEqual(budgetService.remainingBudget(currentSpending: 100), 0)
        XCTAssertEqual(budgetService.remainingBudget(currentSpending: 120), -20)
    }
    
    func testBudgetStatus_OnTrack() {
        let (status, color) = budgetService.budgetStatus(currentSpending: 30)
        XCTAssertTrue(status.contains("On track"))
        XCTAssertEqual(color, .green)
    }
    
    func testBudgetStatus_OverBudget() {
        let (status, color) = budgetService.budgetStatus(currentSpending: 120)
        XCTAssertTrue(status.contains("Over budget"))
        XCTAssertEqual(color, .red)
    }
    
    func testBudgetStatus_NoBudgetSet() {
        budgetService.monthlyBudget = 0
        let (status, color) = budgetService.budgetStatus(currentSpending: 50)
        XCTAssertEqual(status, "Set a budget")
        XCTAssertEqual(color, .gray)
    }
}
