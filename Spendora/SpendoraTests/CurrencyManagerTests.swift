//
//  CurrencyManagerTests.swift
//  SpendoraTests
//

import XCTest
@testable import Spendora

final class CurrencyManagerTests: XCTestCase {
    
    var currencyManager: CurrencyManager!
    
    override func setUp() {
        super.setUp()
        currencyManager = CurrencyManager.shared
        currencyManager.setCurrency(.CAD)
    }
    
    override func tearDown() {
        currencyManager = nil
        super.tearDown()
    }
    
    func testFormatCurrency_CAD() {
        currencyManager.setCurrency(.CAD)
        XCTAssertEqual(currencyManager.format(10.50), "C$10.50")
        XCTAssertEqual(currencyManager.format(0), "C$0.00")
        XCTAssertEqual(currencyManager.format(999.99), "C$999.99")
    }
    
    func testFormatCurrency_USD() {
        currencyManager.setCurrency(.USD)
        XCTAssertEqual(currencyManager.format(10.50), "$10.50")
        XCTAssertEqual(currencyManager.format(0), "$0.00")
    }
    
    func testFormatCurrency_EUR() {
        currencyManager.setCurrency(.EUR)
        XCTAssertEqual(currencyManager.format(10.50), "€10.50")
    }
    
    func testCurrencySwitch_PersistsToUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "selectedCurrencyCode")
        
        currencyManager.setCurrency(.USD)
        let savedCode = defaults.string(forKey: "selectedCurrencyCode")
        XCTAssertEqual(savedCode, "USD")
    }
}
