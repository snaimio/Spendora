//
//  CurrencyManager.swift
//

import Foundation
import SwiftUI
import Combine

/**
 CurrencyManager class handling global currency selection, exchange rate conversions, and price formatting.
 Supports popular global currencies (CAD, USD, EUR, GBP, JPY, AUD, INR, etc.) and persists user preferences in UserDefaults.
*/

// MARK: - CurrencyManager

/**
 `CurrencyManager` is a class that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for currencymanager handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `CurrencyManager` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
class CurrencyManager: ObservableObject {

    // MARK: - Properties

    /// Shared singleton instance for app-wide currency conversion and formatting
    static let shared = CurrencyManager()

    /// Active selected currency, defaulting to CAD (Canadian Dollar)
    @Published var currentCurrency: Currency = .CAD

    private init() {
        loadSavedCurrency()
    }

    /// Restores previously saved ISO currency code from UserDefaults
    private func loadSavedCurrency() {
        let savedCode = UserDefaults.standard.string(
            forKey: "selectedCurrencyCode"
        )
        if let savedCode, let loaded = Currency.allCases.first(where: { $0.code == savedCode }) {
            currentCurrency = loaded
        } else {
            currentCurrency = .CAD
            UserDefaults.standard.set("CAD", forKey: "selectedCurrencyCode")
        }
    }


    /**
     Executes `format` for component logic.
     
     - Parameter amount: Value passed to `format`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func format(_ amount: Double) -> String {
        let formattedAmount = String(format: "%.2f", amount)
        return "\(currentCurrency.symbol)\(formattedAmount)"
    }


    /**
     Executes `format` for component logic.
     
     - Parameter amount: Value passed to `format`.
     - Parameter currency: Value passed to `format`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func format(_ amount: Double, currency: Currency) -> String {
        let formattedAmount = String(format: "%.2f", amount)
        return "\(currency.symbol)\(formattedAmount)"
    }


    /**
     Executes `setCurrency` for component logic.
     
     - Parameter currency: Value passed to `setCurrency`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func setCurrency(_ currency: Currency) {
        currentCurrency = currency
        UserDefaults.standard.set(
            currency.code,
            forKey: "selectedCurrencyCode"
        )
        objectWillChange.send()
    }

    // Exchange rates normalized to 1 USD
    private let ratesToUSD: [Currency: Double] = [
        .USD: 1.0,
        .CAD: 1.36,
        .EUR: 0.92,
        .GBP: 0.78,
        .JPY: 155.0,
        .AUD: 1.51,
        .CHF: 0.89,
        .INR: 83.5,
        .BRL: 5.45,
        .CNY: 7.25,
        .MXN: 18.5,
        .SGD: 1.35,
        .NZD: 1.64,
        .KRW: 1380.0,
        .AED: 3.67
    ]


    /**
     Executes `convert` for component logic.
     
     - Parameter amount: Value passed to `convert`.
     - Parameter sourceCurrency: Value passed to `convert`.
     - Parameter targetCurrency: Value passed to `convert`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func convert(amount: Double, from sourceCurrency: Currency, to targetCurrency: Currency) -> Double {
        guard let sourceRate = ratesToUSD[sourceCurrency],
              let targetRate = ratesToUSD[targetCurrency],
              sourceRate > 0 else {
            return amount
        }
        let amountInUSD = amount / sourceRate
        return amountInUSD * targetRate
    }


    /**
     Executes `convertToCurrent` for component logic.
     
     - Parameter amount: Value passed to `convertToCurrent`.
     - Parameter sourceCurrency: Value passed to `convertToCurrent`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func convertToCurrent(amount: Double, from sourceCurrency: Currency) -> Double {
        convert(amount: amount, from: sourceCurrency, to: currentCurrency)
    }
}


// MARK: - Currency

/**
 `Currency` is a enum that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for currency handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `Currency` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
enum Currency: String, CaseIterable, Identifiable {

    // MARK: - Properties

    case CAD
    case USD
    case EUR
    case GBP
    case JPY
    case AUD
    case CHF
    case INR
    case BRL
    case CNY
    case MXN
    case SGD
    case NZD
    case KRW
    case AED

    var id: String { code }  // id property
    var code: String { rawValue }  // code property

    var symbol: String {  // symbol property
        switch self {
        case .CAD: return "C$"
        case .USD: return "$"
        case .EUR: return "€"
        case .GBP: return "£"
        case .JPY: return "¥"
        case .AUD: return "A$"
        case .CHF: return "CHF "
        case .INR: return "₹"
        case .BRL: return "R$"
        case .CNY: return "¥"
        case .MXN: return "Mex$"
        case .SGD: return "S$"
        case .NZD: return "NZ$"
        case .KRW: return "₩"
        case .AED: return "AED "
        }
    }

    var flag: String {  // flag property
        switch self {
        case .CAD: return "🇨🇦"
        case .USD: return "🇺🇸"
        case .EUR: return "🇪🇺"
        case .GBP: return "🇬🇧"
        case .JPY: return "🇯🇵"
        case .AUD: return "🇦🇺"
        case .CHF: return "🇨🇭"
        case .INR: return "🇮🇳"
        case .BRL: return "🇧🇷"
        case .CNY: return "🇨🇳"
        case .MXN: return "🇲🇽"
        case .SGD: return "🇸🇬"
        case .NZD: return "🇳🇿"
        case .KRW: return "🇰🇷"
        case .AED: return "🇦🇪"
        }
    }

    var name: String {  // name property
        switch self {
        case .CAD: return "Canadian Dollar"
        case .USD: return "US Dollar"
        case .EUR: return "Euro"
        case .GBP: return "British Pound"
        case .JPY: return "Japanese Yen"
        case .AUD: return "Australian Dollar"
        case .CHF: return "Swiss Franc"
        case .INR: return "Indian Rupee"
        case .BRL: return "Brazilian Real"
        case .CNY: return "Chinese Yuan"
        case .MXN: return "Mexican Peso"
        case .SGD: return "Singapore Dollar"
        case .NZD: return "New Zealand Dollar"
        case .KRW: return "South Korean Won"
        case .AED: return "UAE Dirham"
        }
    }

    var displayName: String {  // displayName property
        "\(code) - \(name) (\(symbol.trimmingCharacters(in: .whitespaces)))"
    }

    var pickerLabel: String {  // pickerLabel property
        "\(flag)  \(code) - \(name) (\(symbol.trimmingCharacters(in: .whitespaces)))"
    }
}
