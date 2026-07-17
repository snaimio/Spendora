//
//  MagicFinderService.swift
//  Spendora
//

import Foundation
import SwiftUI

class MagicFinderService {
    static let shared = MagicFinderService()

    // Popular subscription keywords for detection
    private let subscriptionPatterns: [String: String] = [
        "netflix": "Netflix",
        "spotify": "Spotify",
        "apple music": "Apple Music",
        "apple one": "Apple One",
        "disney": "Disney+",
        "hulu": "Hulu",
        "youtube": "YouTube Premium",
        "prime": "Amazon Prime",
        "amazon": "Amazon Prime",
        "hbo": "HBO Max",
        "max": "HBO Max",
        "microsoft": "Microsoft 365",
        "office": "Microsoft 365",
        "google": "Google Workspace",
        "dropbox": "Dropbox",
        "notion": "Notion",
        "fitbit": "Fitbit Premium",
        "myfitnesspal": "MyFitnessPal",
        "hellofresh": "HelloFresh",
        "adobe": "Adobe Creative Cloud",
        "playstation": "PlayStation Plus",
        "xbox": "Xbox Game Pass",
        "peacock": "Peacock",
        "paramount": "Paramount+",
        "starz": "Starz",
        "showtime": "Showtime",
        "crunchyroll": "Crunchyroll",
        "audible": "Audible",
        "kindle": "Kindle Unlimited",
        "duolingo": "Duolingo Plus",
        "headspace": "Headspace",
        "calm": "Calm",
        "strava": "Strava",
        "peloton": "Peloton",
        "whoop": "Whoop",
        "zwift": "Zwift"
    ]

    // Email patterns commonly associated with subscriptions
    private let emailPatterns: [String] = [
        "subscription",
        "renewal",
        "billing",
        "invoice",
        "receipt",
        "payment",
        "charged",
        "monthly",
        "yearly",
        "trial",
        "free trial",
        "membership",
        "premium"
    ]

    func detectSubscriptions(from text: String) -> [String] {
        var detected: Set<String> = []
        let lowercased = text.lowercased()

        for (pattern, service) in subscriptionPatterns {
            if lowercased.contains(pattern) {
                detected.insert(service)
            }
        }

        return Array(detected)
    }

    func detectFromEmailBody(_ body: String) -> [String] {
        var detected: Set<String> = []
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

    private func detectCategory(from text: String) -> String? {
        let lowercased = text.lowercased()

        if lowercased.contains("music")
            || lowercased.contains("tv")
            || lowercased.contains("movie")
            || lowercased.contains("show") {

            return "Entertainment"

        } else if lowercased.contains("work")
            || lowercased.contains("office")
            || lowercased.contains("cloud")
            || lowercased.contains("storage") {

            return "Productivity"

        } else if lowercased.contains("fitness")
            || lowercased.contains("health")
            || lowercased.contains("gym")
            || lowercased.contains("workout") {

            return "Health & Fitness"

        } else if lowercased.contains("shop")
            || lowercased.contains("delivery")
            || lowercased.contains("prime") {

            return "Shopping"

        } else if lowercased.contains("food")
            || lowercased.contains("meal")
            || lowercased.contains("cook") {

            return "Food & Dining"

        } else if lowercased.contains("learn")
            || lowercased.contains("course")
            || lowercased.contains("class") {

            return "Education"
        }

        return nil
    }
}
