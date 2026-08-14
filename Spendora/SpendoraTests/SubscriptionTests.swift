//
//  SubscriptionTests.swift
//

import XCTest
@testable import Spendora

final class SubscriptionTests: XCTestCase {
    

    /**
     Executes `testMonthlyCost_MonthlySubscription` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func testMonthlyCost_MonthlySubscription() {
        let monthlySub = Subscription(
            name: "Test Monthly",
            cost: 10,
            isYearly: false,
            nextBillingDate: Date().addingTimeInterval(86400 * 30)
        )
        XCTAssertEqual(monthlySub.monthlyCost, 10)
        XCTAssertEqual(monthlySub.yearlyCost, 120)
    }
    

    /**
     Executes `testMonthlyCost_YearlySubscription` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func testMonthlyCost_YearlySubscription() {
        let yearlySub = Subscription(
            name: "Test Yearly",
            cost: 120,
            isYearly: true,
            nextBillingDate: Date().addingTimeInterval(86400 * 365)
        )
        XCTAssertEqual(yearlySub.monthlyCost, 10)
        XCTAssertEqual(yearlySub.yearlyCost, 120)
    }
    

    /**
     Executes `testDaysUntilBilling_FutureDate` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func testDaysUntilBilling_FutureDate() {
        let futureDate = Date().addingTimeInterval(86400 * 5)
        let sub = Subscription(
            name: "Test",
            cost: 10,
            isYearly: false,
            nextBillingDate: futureDate
        )
        XCTAssertEqual(sub.daysUntilBilling, 5)
    }
    

    /**
     Executes `testIsUpcoming_Within7Days` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func testIsUpcoming_Within7Days() {
        let date = Date().addingTimeInterval(86400 * 3)
        let sub = Subscription(
            name: "Test",
            cost: 10,
            isYearly: false,
            nextBillingDate: date
        )
        XCTAssertTrue(sub.isUpcoming)
    }
    

    /**
     Executes `testIsUpcoming_Beyond7Days` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func testIsUpcoming_Beyond7Days() {
        let date = Date().addingTimeInterval(86400 * 10)
        let sub = Subscription(
            name: "Test",
            cost: 10,
            isYearly: false,
            nextBillingDate: date
        )
        XCTAssertFalse(sub.isUpcoming)
    }
    

    /**
     Executes `testIsDueToday` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func testIsDueToday() {
        let sub = Subscription(
            name: "Test",
            cost: 10,
            isYearly: false,
            nextBillingDate: Date()
        )
        XCTAssertTrue(sub.isDueToday)
    }
    

    /**
     Executes `testIsOverdue` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func testIsOverdue() {
        let sub = Subscription(
            name: "Test",
            cost: 10,
            isYearly: false,
            nextBillingDate: Date().addingTimeInterval(-86400)
        )
        XCTAssertTrue(sub.isOverdue)
    }
    

    /**
     Executes `testIsValid_ValidSubscription` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func testIsValid_ValidSubscription() {
        let sub = Subscription(
            name: "Netflix",
            cost: 15.99,
            isYearly: false,
            nextBillingDate: Date().addingTimeInterval(86400 * 30)
        )
        XCTAssertTrue(sub.isValid)
    }
    

    /**
     Executes `testIsValid_EmptyName` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func testIsValid_EmptyName() {
        let sub = Subscription(
            name: "",
            cost: 15.99,
            isYearly: false,
            nextBillingDate: Date().addingTimeInterval(86400 * 30)
        )
        XCTAssertFalse(sub.isValid)
    }
    

    /**
     Executes `testIsValid_ZeroCost` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func testIsValid_ZeroCost() {
        let sub = Subscription(
            name: "Test",
            cost: 0,
            isYearly: false,
            nextBillingDate: Date().addingTimeInterval(86400 * 30)
        )
        XCTAssertFalse(sub.isValid)
    }


    /**
     Executes `testSubscriptionStatus_ActiveAndCancelled` for component logic.
     */
    func testSubscriptionStatus_ActiveAndCancelled() {
        let activeSub = Subscription(name: "Netflix", cost: 15, isYearly: false, nextBillingDate: Date().addingTimeInterval(86400))
        XCTAssertFalse(activeSub.isCancelled)

        let cancelledSub = Subscription(name: "News", cost: 10, isYearly: false, nextBillingDate: Date().addingTimeInterval(86400), isCancelled: true)
        XCTAssertTrue(cancelledSub.isCancelled)
    }


    /**
     Executes `testCurrencyNormalization` for component logic.
     */
    func testCurrencyNormalization() {
        let subUSD = Subscription(name: "ChatGPT", cost: 20.0, isYearly: false, nextBillingDate: Date().addingTimeInterval(86400), currency: "USD")
        XCTAssertEqual(subUSD.currency, "USD")
        XCTAssertGreaterThan(subUSD.monthlyCost, 0)
    }
}
