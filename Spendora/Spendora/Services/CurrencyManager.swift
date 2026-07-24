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
        if let savedCode, let loaded = Currency.allCases.first(where: { $0.code == savedCode }) {
            currentCurrency = loaded
        } else {
            currentCurrency = .CAD
            UserDefaults.standard.set("CAD", forKey: "selectedCurrencyCode")
        }
    }

    func format(_ amount: Double) -> String {
        let formattedAmount = String(format: "%.2f", amount)
        return "\(currentCurrency.symbol)\(formattedAmount)"
    }

    func format(_ amount: Double, currency: Currency) -> String {
        let formattedAmount = String(format: "%.2f", amount)
        return "\(currency.symbol)\(formattedAmount)"
    }

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
        .BRL: 5.45
    ]

    func convert(amount: Double, from sourceCurrency: Currency, to targetCurrency: Currency) -> Double {
        guard let sourceRate = ratesToUSD[sourceCurrency],
              let targetRate = ratesToUSD[targetCurrency],
              sourceRate > 0 else {
            return amount
        }
        let amountInUSD = amount / sourceRate
        return amountInUSD * targetRate
    }

    func convertToCurrent(amount: Double, from sourceCurrency: Currency) -> Double {
        convert(amount: amount, from: sourceCurrency, to: currentCurrency)
    }
}

enum Currency: String, CaseIterable, Identifiable {
    case USD
    case CAD
    case EUR
    case GBP
    case JPY
    case AUD
    case CHF
    case INR
    case BRL

    var id: String { code }

    var symbol: String {
        switch self {
        case .USD: return "$"
        case .CAD: return "C$"
        case .EUR: return "€"
        case .GBP: return "£"
        case .JPY: return "¥"
        case .AUD: return "A$"
        case .CHF: return "CHF "
        case .INR: return "₹"
        case .BRL: return "R$"
        }
    }

    var code: String { rawValue }

    var displayName: String {
        "\(symbol) (\(code))"
    }
}
