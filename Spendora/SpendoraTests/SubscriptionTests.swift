//
//  SubscriptionTests.swift
//  SpendoraTests
//

import XCTest
@testable import Spendora

final class SubscriptionTests: XCTestCase {
    
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
    
    func testIsDueToday() {
        let sub = Subscription(
            name: "Test",
            cost: 10,
            isYearly: false,
            nextBillingDate: Date()
        )
        XCTAssertTrue(sub.isDueToday)
    }
    
    func testIsOverdue() {
        let sub = Subscription(
            name: "Test",
            cost: 10,
            isYearly: false,
            nextBillingDate: Date().addingTimeInterval(-86400)
        )
        XCTAssertTrue(sub.isOverdue)
    }
    
    func testIsValid_ValidSubscription() {
        let sub = Subscription(
            name: "Netflix",
            cost: 15.99,
            isYearly: false,
            nextBillingDate: Date().addingTimeInterval(86400 * 30)
        )
        XCTAssertTrue(sub.isValid)
    }
    
    func testIsValid_EmptyName() {
        let sub = Subscription(
            name: "",
            cost: 15.99,
            isYearly: false,
            nextBillingDate: Date().addingTimeInterval(86400 * 30)
        )
        XCTAssertFalse(sub.isValid)
    }
    
    func testIsValid_ZeroCost() {
        let sub = Subscription(
            name: "Test",
            cost: 0,
            isYearly: false,
            nextBillingDate: Date().addingTimeInterval(86400 * 30)
        )
        XCTAssertFalse(sub.isValid)
    }

    func testSubscriptionStatus_PausedAndCancelled() {
        let activeSub = Subscription(name: "Netflix", cost: 15, isYearly: false, nextBillingDate: Date().addingTimeInterval(86400))
        XCTAssertEqual(activeSub.status, .active)

        let pausedSub = Subscription(name: "Gym", cost: 50, isYearly: false, nextBillingDate: Date().addingTimeInterval(86400), statusRaw: "Paused")
        XCTAssertEqual(pausedSub.status, .paused)

        let cancelledSub = Subscription(name: "News", cost: 10, isYearly: false, nextBillingDate: Date().addingTimeInterval(86400), isCancelled: true)
        XCTAssertEqual(cancelledSub.status, .cancelled)
    }

    func testCurrencyNormalization() {
        let subUSD = Subscription(name: "ChatGPT", cost: 20.0, isYearly: false, nextBillingDate: Date().addingTimeInterval(86400), currencyCode: "USD")
        XCTAssertEqual(subUSD.currency, .USD)
        XCTAssertGreaterThan(subUSD.normalizedMonthlyCost, 0)
    }
}
