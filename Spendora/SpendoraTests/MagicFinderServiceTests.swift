//
//  MagicFinderServiceTests.swift
//  SpendoraTests
//

import XCTest
@testable import Spendora

final class MagicFinderServiceTests: XCTestCase {
    
    var magicFinder: MagicFinderService!
    
    override func setUp() {
        super.setUp()
        magicFinder = MagicFinderService.shared
    }
    
    override func tearDown() {
        magicFinder = nil
        super.tearDown()
    }
    
    func testDetectSubscriptions_Netflix() {
        let text = "I have a Netflix subscription"
        let detected = magicFinder.detectSubscriptions(from: text)
        XCTAssertTrue(detected.contains("Netflix"))
    }
    
    func testDetectSubscriptions_MultipleServices() {
        let text = "I use Netflix, Spotify, and Amazon Prime"
        let detected = magicFinder.detectSubscriptions(from: text)
        XCTAssertTrue(detected.contains("Netflix"))
        XCTAssertTrue(detected.contains("Spotify"))
        XCTAssertTrue(detected.contains("Amazon Prime"))
    }
    
    func testDetectSubscriptions_NoMatch() {
        let text = "This is a regular text with no subscriptions"
        let detected = magicFinder.detectSubscriptions(from: text)
        XCTAssertTrue(detected.isEmpty)
    }
    
    func testExtractAmount_StandardFormat() {
        let text = "Your monthly charge is $15.99"
        let amount = magicFinder.extractAmount(from: text)
        XCTAssertEqual(amount, 15.99)
    }
    
    func testExtractAmount_WithCommas() {
        let text = "Your annual subscription costs $1,299.99"
        let amount = magicFinder.extractAmount(from: text)
        XCTAssertEqual(amount, 1299.99)
    }
    
    func testExtractAmount_NoAmount() {
        let text = "No numbers here"
        let amount = magicFinder.extractAmount(from: text)
        XCTAssertNil(amount)
    }
    
    func testExtractNextBillingDate_MMDDYYYY() {
        let text = "Your next billing date is 06/15/2025"
        let date = magicFinder.extractNextBillingDate(from: text)
        XCTAssertNotNil(date)
    }
    
    func testQuickAddFromText_CompleteInfo() {
        let text = "Netflix costs $15.99 per month"
        let (name, cost, category) = magicFinder.quickAddFromText(text)
        XCTAssertEqual(name, "Netflix")
        XCTAssertEqual(cost, 15.99)
        XCTAssertEqual(category, "Entertainment")
    }
}
