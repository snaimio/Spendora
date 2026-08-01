//
//  MagicFinderPatterns.swift
//

/**
 * Main/Core Functions & Purpose:
 * Extension for MagicFinderService providing keyword dictionaries for subscription and transaction detection.
 */

import Foundation


// MARK: - MagicFinderService Extension

/**
 Extension on `MagicFinderService` providing utility methods and helpers.
 */
extension MagicFinderService {
    
    /// Keyword mapping for subscription merchants
    var subscriptionPatterns: [String: String] {  // subscriptionPatterns property
        [
            "chatgpt": "ChatGPT Plus",
            "openai": "ChatGPT Plus",
            "claude": "Claude Pro",
            "anthropic": "Claude Pro",
            "copilot": "GitHub Copilot",
            "midjourney": "Midjourney",
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
    }

    /// Email keywords associated with recurring bill receipts
    var emailPatterns: [String] {  // emailPatterns property
        [
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
    }
}
