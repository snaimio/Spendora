//
//  MagicFinderService.swift
//

/**
 * Main/Core Functions & Purpose:
 * MagicFinderService engine providing smart subscription detection from raw text or transaction descriptions.
 * Parses user input for recurring merchant keywords (Netflix, ChatGPT, Spotify, Adobe, etc.)
 * and automatically auto-fills preset details including category, cost, billing cycle, and cancellation URLs.
 */

import Foundation
import SwiftUI


// MARK: - MagicFinderService

/**
 `MagicFinderService` is a class that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for magicfinderservice handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `MagicFinderService` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
class MagicFinderService {

    // MARK: - Properties

    /// Shared singleton instance for subscription pattern matching
    static let shared = MagicFinderService()


    /**
     Executes `detectSubscriptions` for component logic.
     
     - Parameter text: Value passed to `detectSubscriptions`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func detectSubscriptions(from text: String) -> [String] {
        var detected: Set<String> = []  // detected property
        let lowercased = text.lowercased()

        for (pattern, service) in subscriptionPatterns {
            if lowercased.contains(pattern) {
                detected.insert(service)
            }
        }

        return Array(detected)
    }


    /**
     Executes `detectFromEmailBody` for component logic.
     
     - Parameter body: Value passed to `detectFromEmailBody`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func detectFromEmailBody(_ body: String) -> [String] {
        var detected: Set<String> = []  // detected property
        let lowercased = body.lowercased()

        // Check for subscription patterns
        for (pattern, service) in subscriptionPatterns {
            if lowercased.contains(pattern) {
                detected.insert(service)
            }
        }

        // Check for email patterns to confirm it's a subscription email
        var isSubscriptionEmail = false

        for pattern in emailPatterns {
            if lowercased.contains(pattern) {
                isSubscriptionEmail = true
                break
            }
        }

        return isSubscriptionEmail ? Array(detected) : []
    }


    /**
     Executes `extractAmount` for component logic.
     
     - Parameter text: Value passed to `extractAmount`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func extractAmount(from text: String) -> Double? {
        let pattern = #"\$\s*(\d{1,3}(?:,\d{3})*(?:\.\d{2})?)"#

        let regex = try? NSRegularExpression(pattern: pattern)
        let nsString = text as NSString

        let results = regex?.matches(
            in: text,
            range: NSRange(location: 0, length: nsString.length)
        )

        for result in results ?? [] {
            let amount = nsString
                .substring(with: result.range(at: 1))
                .replacingOccurrences(of: ",", with: "")

            if let value = Double(amount) {
                return value
            }
        }

        return nil
    }


    /**
     Executes `extractNextBillingDate` for component logic.
     
     - Parameter text: Value passed to `extractNextBillingDate`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func extractNextBillingDate(from text: String) -> Date? {
        let datePatterns = [
            #"next billing.*?(\d{1,2}/\d{1,2}/\d{2,4})"#,
            #"renews on (\d{1,2}/\d{1,2}/\d{2,4})"#,
            #"billed on (\d{1,2}/\d{1,2}/\d{2,4})"#,
            #"(\d{1,2}\s+(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+\d{2,4})"#
        ]

        for pattern in datePatterns {
            let regex = try? NSRegularExpression(
                pattern: pattern,
                options: .caseInsensitive
            )

            let nsString = text as NSString

            if let match = regex?.firstMatch(
                in: text,
                range: NSRange(location: 0, length: nsString.length)
            ) {
                let dateString = nsString.substring(
                    with: match.range(at: 1)
                )

                if let date = parseDate(dateString) {
                    return date
                }
            }
        }

        return nil
    }


    /**
     Executes `parseDate` for component logic.
     
     - Parameter dateString: Value passed to `parseDate`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    private func parseDate(_ dateString: String) -> Date? {
        let formatters = [
            "MM/dd/yyyy",
            "MM/dd/yy",
            "dd/MM/yyyy",
            "dd/MM/yy",
            "MMMM d, yyyy",
            "MMM d, yyyy",
            "dd MMM yyyy"
        ]

        for format in formatters {
            let formatter = DateFormatter()
            formatter.dateFormat = format

            if let date = formatter.date(from: dateString) {
                return date
            }
        }

        return nil
    }

    func quickAddFromText(
        _ text: String
    ) -> (name: String?, cost: Double?, category: String?) {

        let detected = detectSubscriptions(from: text)
        let name = detected.first
        let cost = extractAmount(from: text)
        let category = detectCategory(from: text)

        return (name, cost, category)
    }
}
