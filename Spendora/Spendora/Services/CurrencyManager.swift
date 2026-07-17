//
//  CurrencyManager.swift
//  Spendora
//

import Foundation
import SwiftUI
import Combine

class CurrencyManager: ObservableObject {
    static let shared = CurrencyManager()

    @Published var currentCurrency: Currency = .CAD

    private init() {
        loadSavedCurrency()
    }

    private func loadSavedCurrency() {
        let savedCode = UserDefaults.standard.string(
            forKey: "selectedCurrencyCode"
        )

        switch savedCode {
        case "USD":
            currentCurrency = .USD
        case "CAD":
            currentCurrency = .CAD
        case "EUR":
            currentCurrency = .EUR
        case "GBP":
            currentCurrency = .GBP
        case "JPY":
            currentCurrency = .JPY
        case "AUD":
            currentCurrency = .AUD
        default:
            currentCurrency = .CAD
            UserDefaults.standard.set(
                "CAD",
                forKey: "selectedCurrencyCode"
            )
        }
    }

    func format(_ amount: Double) -> String {
        let formattedAmount = String(format: "%.2f", amount)
        return "\(currentCurrency.symbol)\(formattedAmount)"
    }

    func setCurrency(_ currency: Currency) {
        currentCurrency = currency
        UserDefaults.standard.set(
            currency.code,
            forKey: "selectedCurrencyCode"
        )

        objectWillChange.send()
    }
}

enum Currency {
    case USD
    case CAD
    case EUR
    case GBP
    case JPY
    case AUD

    var symbol: String {
        switch self {
        case .USD: return "$"
        case .CAD: return "C$"
        case .EUR: return "€"
        case .GBP: return "£"
        case .JPY: return "¥"
        case .AUD: return "A$"
        }
    }

    var code: String {
        switch self {
        case .USD: return "USD"
        case .CAD: return "CAD"
        case .EUR: return "EUR"
        case .GBP: return "GBP"
        case .JPY: return "JPY"
        case .AUD: return "AUD"
        }
    }

    var displayName: String {
        "\(symbol) (\(code))"
    }

    static var allCases: [Currency] {
        [.USD, .CAD, .EUR, .GBP, .JPY, .AUD]
    }
}
