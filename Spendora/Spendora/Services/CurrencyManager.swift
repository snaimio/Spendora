import Foundation
import SwiftUI
import Combine

/**
 CurrencyManager class handling global currency selection, exchange rate conversions, and price formatting.
 Supports popular global currencies (CAD, USD, EUR, GBP, JPY, AUD, INR, etc.) and persists user preferences in UserDefaults.
*/
class CurrencyManager: ObservableObject {
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
        .BRL: 5.45,
        .CNY: 7.25,
        .MXN: 18.5,
        .SGD: 1.35,
        .NZD: 1.64,
        .KRW: 1380.0,
        .AED: 3.67
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

    var id: String { code }
    var code: String { rawValue }

    var symbol: String {
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

    var flag: String {
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

    var name: String {
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

    var displayName: String {
        "\(code) - \(name) (\(symbol.trimmingCharacters(in: .whitespaces)))"
    }

    var pickerLabel: String {
        "\(flag)  \(code) - \(name) (\(symbol.trimmingCharacters(in: .whitespaces)))"
    }
}
