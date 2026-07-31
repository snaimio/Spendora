/**
 * Main/Core Functions & Purpose:
 * PaymentMethod enum representing supported user payment methods (Credit Card, Debit Card, Apple Pay, PayPal, Bank Transfer).
 */

import Foundation

enum PaymentMethod: String, CaseIterable, Identifiable {
    case creditCard = "Credit Card"
    case debitCard = "Debit Card"
    case applePay = "Apple Pay"
    case paypal = "PayPal"
    case bankTransfer = "Bank Transfer"
    case other = "Other"

    var id: String { rawValue }

    var displayName: String { rawValue }

    var icon: String {
        switch self {
        case .creditCard: return "creditcard.fill"
        case .debitCard: return "creditcard"
        case .applePay: return "applelogo"
        case .paypal: return "dollarsign.circle.fill"
        case .bankTransfer: return "building.columns.fill"
        case .other: return "ellipsis.circle"
        }
    }

    static func from(_ string: String) -> PaymentMethod {
        PaymentMethod(rawValue: string) ?? .creditCard
    }
}
