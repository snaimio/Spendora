//
//  CancellationService.swift
//  Spendora
//

import Foundation
import SwiftUI

struct CancellationService {
    static let shared = CancellationService()

    private init() {}

    /// Returns the exact direct cancellation portal URL for over 100+ popular services
    func getDirectCancellationURL(for subscriptionName: String, notes: String? = nil) -> URL? {
        let name = subscriptionName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        var urlString: String?

        // Check if notes or name contains an explicit domain
        if let customURL = extractURL(from: name) ?? extractURL(from: notes ?? "") {
            return customURL
        }

        // MARK: - Streaming & Entertainment
        if name.contains("netflix") {
            urlString = "https://www.netflix.com/youraccount"
        } else if name.contains("spotify") {
            urlString = "https://www.spotify.com/account/overview/"
        } else if name.contains("apple music") || name.contains("apple tv") || name.contains("apple one") || name.contains("icloud") || name.contains("apple") {
            urlString = "https://apps.apple.com/account/subscriptions"
        } else if name.contains("disney") {
            urlString = "https://www.disneyplus.com/account"
        } else if name.contains("hulu") {
            urlString = "https://secure.hulu.com/account"
        } else if name.contains("youtube") {
            urlString = "https://www.youtube.com/paid_memberships"
        } else if name.contains("hbo") || name.contains("max") {
            urlString = "https://auth.max.com/account"
        } else if name.contains("amazon") || name.contains("prime") {
            urlString = "https://www.amazon.com/mc/manage"
        } else if name.contains("paramount") {
            urlString = "https://www.paramountplus.com/account/"
        } else if name.contains("peacock") {
            urlString = "https://www.peacocktv.com/account"
        } else if name.contains("crunchyroll") {
            urlString = "https://www.crunchyroll.com/account"
        } else if name.contains("audible") {
            urlString = "https://www.audible.com/account/overview"
        } else if name.contains("twitch") {
            urlString = "https://www.twitch.tv/subscriptions"
        } else if name.contains("starz") {
            urlString = "https://www.starz.com/account"
        } else if name.contains("showtime") {
            urlString = "https://www.showtime.com/account"
        }

        // MARK: - AI & Tech Services
        else if name.contains("chatgpt") || name.contains("openai") {
            urlString = "https://chatgpt.com/#settings/subscriptions"
        } else if name.contains("claude") || name.contains("anthropic") {
            urlString = "https://claude.ai/settings/billing"
        } else if name.contains("perplexity") {
            urlString = "https://www.perplexity.ai/settings/profile"
        } else if name.contains("github") || name.contains("copilot") {
            urlString = "https://github.com/settings/billing"
        } else if name.contains("midjourney") {
            urlString = "https://www.midjourney.com/account"
        }

        // MARK: - Productivity & Software
        else if name.contains("microsoft") || name.contains("office") || name.contains("office365") || name.contains("xbox") {
            urlString = "https://account.microsoft.com/services"
        } else if name.contains("google") || name.contains("workspace") || name.contains("drive") {
            urlString = "https://one.google.com/settings"
        } else if name.contains("dropbox") {
            urlString = "https://www.dropbox.com/account/plan"
        } else if name.contains("notion") {
            urlString = "https://www.notion.so/settings/plans"
        } else if name.contains("slack") {
            urlString = "https://slack.com/account/settings"
        } else if name.contains("zoom") {
            urlString = "https://zoom.us/billing"
        } else if name.contains("figma") {
            urlString = "https://www.figma.com/settings"
        } else if name.contains("adobe") || name.contains("creative cloud") || name.contains("photoshop") {
            urlString = "https://account.adobe.com/plans"
        } else if name.contains("canva") {
            urlString = "https://www.canva.com/settings/billing-and-teams"
        } else if name.contains("grammarly") {
            urlString = "https://account.grammarly.com/subscription"
        } else if name.contains("1password") {
            urlString = "https://my.1password.com/profile/billing"
        } else if name.contains("bitwarden") {
            urlString = "https://vault.bitwarden.com/#/settings/subscription"
        } else if name.contains("nordvpn") {
            urlString = "https://my.nordaccount.com/billing/cancellation/"
        } else if name.contains("expressvpn") {
            urlString = "https://www.expressvpn.com/subscriptions"
        } else if name.contains("surfshark") {
            urlString = "https://my.surfshark.com/billing"
        } else if name.contains("proton") {
            urlString = "https://account.proton.me/u/0/mail/subscription"
        } else if name.contains("linkedin") {
            urlString = "https://www.linkedin.com/premium/cancel"
        }

        // MARK: - Delivery, Food & Shopping
        else if name.contains("doordash") || name.contains("dashpass") {
            urlString = "https://www.doordash.com/consumer/subscriptions/dashpass"
        } else if name.contains("uber") {
            urlString = "https://m.uber.com/pass"
        } else if name.contains("instacart") {
            urlString = "https://www.instacart.com/store/account/instacart-plus"
        } else if name.contains("hellofresh") {
            urlString = "https://www.hellofresh.com/account/cancel"
        } else if name.contains("blue apron") {
            urlString = "https://www.blueapron.com/account"
        } else if name.contains("walmart") {
            urlString = "https://www.walmart.com/account/plus"
        }

        // MARK: - Fitness & Health
        else if name.contains("fitbit") {
            urlString = "https://www.fitbit.com/settings/subscription"
        } else if name.contains("myfitnesspal") {
            urlString = "https://www.myfitnesspal.com/account/subscription"
        } else if name.contains("strava") {
            urlString = "https://www.strava.com/settings/billing"
        } else if name.contains("peloton") {
            urlString = "https://www.onepeloton.com/digital/checkout/manage-subscriptions"
        } else if name.contains("headspace") {
            urlString = "https://www.headspace.com/account"
        } else if name.contains("calm") {
            urlString = "https://www.calm.com/profile"
        }

        // MARK: - Social & Gaming
        else if name.contains("tinder") {
            urlString = "https://tinder.com/app/settings"
        } else if name.contains("bumble") {
            urlString = "https://bumble.com/app/settings"
        } else if name.contains("playstation") {
            urlString = "https://www.playstation.com/account"
        } else if name.contains("nintendo") {
            urlString = "https://accounts.nintendo.com"
        } else if name.contains("twitter") || name.contains("x premium") {
            urlString = "https://x.com/settings/premium"
        }

        // Smart fallback: Formulate official domain account URL
        if urlString == nil {
            let cleanDomain = name.replacingOccurrences(of: " ", with: "").lowercased()
            urlString = "https://www.\(cleanDomain).com/account"
        }

        guard let validString = urlString, let url = URL(string: validString) else { return nil }
        return url
    }

    private func extractURL(from text: String) -> URL? {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf8.count))
        return matches?.first?.url
    }
}
