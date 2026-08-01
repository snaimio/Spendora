//
//  CurrencyManagerTests.swift
//

import XCTest
@testable import Spendora

final class CurrencyManagerTests: XCTestCase {
    
    var currencyManager: CurrencyManager!  // currencyManager property
    

    /**
     Executes `setUp` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    override func setUp() {
        super.setUp()
        currencyManager = CurrencyManager.shared
        currencyManager.setCurrency(.CAD)
    }
    

    /**
     Executes `tearDown` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    override func tearDown() {
        currencyManager = nil
        super.tearDown()
    }
    

    /**
     Executes `testFormatCurrency_CAD` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func testFormatCurrency_CAD() {
        currencyManager.setCurrency(.CAD)
        XCTAssertEqual(currencyManager.format(10.50), "C$10.50")
        XCTAssertEqual(currencyManager.format(0), "C$0.00")
        XCTAssertEqual(currencyManager.format(999.99), "C$999.99")
    }
    

    /**
     Executes `testFormatCurrency_USD` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func testFormatCurrency_USD() {
        currencyManager.setCurrency(.USD)
        XCTAssertEqual(currencyManager.format(10.50), "$10.50")
        XCTAssertEqual(currencyManager.format(0), "$0.00")
    }
    

    /**
     Executes `testFormatCurrency_EUR` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func testFormatCurrency_EUR() {
        currencyManager.setCurrency(.EUR)
        XCTAssertEqual(currencyManager.format(10.50), "€10.50")
    }
    

    /**
     Executes `testCurrencySwitch_PersistsToUserDefaults` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func testCurrencySwitch_PersistsToUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "selectedCurrencyCode")
        
        currencyManager.setCurrency(.USD)
        let savedCode = defaults.string(forKey: "selectedCurrencyCode")
        XCTAssertEqual(savedCode, "USD")
    }
}
