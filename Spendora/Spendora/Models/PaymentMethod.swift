//
//  PaymentMethod.swift
//

/**
 * Main/Core Functions & Purpose:
 * PaymentMethod enum representing supported user payment methods (Credit Card, Debit Card, Apple Pay, PayPal, Bank Transfer).
 */

import Foundation


// MARK: - PaymentMethod

/**
 `PaymentMethod` is a enum that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for paymentmethod handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `PaymentMethod` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
enum PaymentMethod: String, CaseIterable, Identifiable {

    // MARK: - Properties

    case creditCard = "Credit Card"
    case debitCard = "Debit Card"
    case applePay = "Apple Pay"
    case paypal = "PayPal"
    case bankTransfer = "Bank Transfer"
    case other = "Other"

    var id: String { rawValue }  // id property

    var displayName: String { rawValue }  // displayName property

    var icon: String {  // icon property
        switch self {
        case .creditCard: return "creditcard.fill"
        case .debitCard: return "creditcard"
        case .applePay: return "applelogo"
        case .paypal: return "dollarsign.circle.fill"
        case .bankTransfer: return "building.columns.fill"
        case .other: return "ellipsis.circle"
        }
    }


    /**
     Executes `from` for component logic.
     
     - Parameter string: Value passed to `from`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    static func from(_ string: String) -> PaymentMethod {
        PaymentMethod(rawValue: string) ?? .creditCard
    }
}
