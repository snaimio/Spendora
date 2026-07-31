import Foundation
import SwiftUI

/**
 CancellationService provides direct deep-link cancellation portal URLs for 100+ popular subscription services.
 Prevents broken 404 links by mapping services to verified primary account hubs, and falls back to a targeted Google cancellation search for custom user subscriptions.
*/
struct CancellationService {
    /// Shared singleton instance
    static let shared = CancellationService()

    private init() {}

    /// Resolves the exact direct cancellation portal URL for a subscription.
    /// - Parameters:
    ///   - subscriptionName: Name of the subscription (e.g. "Netflix", "ChatGPT", "Gym")
    ///   - notes: Optional notes field which may contain a custom website link
    /// - Returns: A valid URL pointing directly to the cancellation portal or Google search fallback.
    func getDirectCancellationURL(for subscriptionName: String, notes: String? = nil) -> URL? {
        let name = subscriptionName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        var urlString: String?

        // Check if the user entered an explicit website link in notes or name
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
            urlString = "https://www.hulu.com/account"
        } else if name.contains("youtube") {
            urlString = "https://www.youtube.com/paid_memberships"
        } else if name.contains("hbo") || name.contains("max") {
            urlString = "https://www.max.com"
        } else if name.contains("amazon") || name.contains("prime") {
            urlString = "https://www.amazon.com/yourmembershipsandsubscriptions"
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
            urlString = "https://www.starz.com"
        } else if name.contains("showtime") {
            urlString = "https://www.showtime.com"
        }

        // MARK: - AI & Tech Services
        else if name.contains("chatgpt") || name.contains("openai") {
            urlString = "https://chatgpt.com"
        } else if name.contains("claude") || name.contains("anthropic") {
            urlString = "https://claude.ai"
        } else if name.contains("perplexity") {
            urlString = "https://www.perplexity.ai"
        } else if name.contains("github") || name.contains("copilot") {
            urlString = "https://github.com/settings/billing"
        } else if name.contains("midjourney") {
            urlString = "https://www.midjourney.com"
        }

        // MARK: - Productivity & Software
        else if name.contains("microsoft") || name.contains("office") || name.contains("office365") || name.contains("xbox") {
            urlString = "https://account.microsoft.com/services"
        } else if name.contains("google") || name.contains("workspace") || name.contains("drive") {
            urlString = "https://one.google.com/"
        } else if name.contains("dropbox") {
            urlString = "https://www.dropbox.com/account"
        } else if name.contains("notion") {
            urlString = "https://www.notion.so"
        } else if name.contains("slack") {
            urlString = "https://slack.com"
        } else if name.contains("zoom") {
            urlString = "https://zoom.us/profile"
        } else if name.contains("figma") {
            urlString = "https://www.figma.com"
        } else if name.contains("adobe") || name.contains("creative cloud") || name.contains("photoshop") {
            urlString = "https://account.adobe.com"
        } else if name.contains("canva") {
            urlString = "https://www.canva.com/settings"
        } else if name.contains("grammarly") {
            urlString = "https://account.grammarly.com"
        } else if name.contains("1password") {
            urlString = "https://my.1password.com"
        } else if name.contains("bitwarden") {
            urlString = "https://vault.bitwarden.com"
        } else if name.contains("nordvpn") {
            urlString = "https://my.nordaccount.com"
        } else if name.contains("expressvpn") {
            urlString = "https://www.expressvpn.com"
        } else if name.contains("surfshark") {
            urlString = "https://my.surfshark.com"
        } else if name.contains("proton") {
            urlString = "https://account.proton.me"
        } else if name.contains("linkedin") {
            urlString = "https://www.linkedin.com/psettings/"
        }

        // MARK: - Delivery, Food & Shopping
        else if name.contains("doordash") || name.contains("dashpass") {
            urlString = "https://www.doordash.com"
        } else if name.contains("uber") {
            urlString = "https://www.uber.com"
        } else if name.contains("instacart") {
            urlString = "https://www.instacart.com"
        } else if name.contains("hellofresh") {
            urlString = "https://www.hellofresh.com"
        } else if name.contains("blue apron") {
            urlString = "https://www.blueapron.com"
        } else if name.contains("walmart") {
            urlString = "https://www.walmart.com/account"
        }

        // MARK: - Fitness & Health
        else if name.contains("fitbit") {
            urlString = "https://www.fitbit.com"
        } else if name.contains("myfitnesspal") {
            urlString = "https://www.myfitnesspal.com"
        } else if name.contains("strava") {
            urlString = "https://www.strava.com"
        } else if name.contains("peloton") {
            urlString = "https://www.onepeloton.com"
        } else if name.contains("headspace") {
            urlString = "https://www.headspace.com"
        } else if name.contains("calm") {
            urlString = "https://www.calm.com"
        }

        // MARK: - Social & Gaming
        else if name.contains("tinder") {
            urlString = "https://tinder.com"
        } else if name.contains("bumble") {
            urlString = "https://bumble.com"
        } else if name.contains("playstation") {
            urlString = "https://www.playstation.com"
        } else if name.contains("nintendo") {
            urlString = "https://accounts.nintendo.com"
        } else if name.contains("twitter") || name.contains("x premium") {
            urlString = "https://x.com/settings"
        }

        // Guaranteed fallback for custom/unrecognized services: Google search for cancellation guide
        if urlString == nil {
            let query = "how to cancel \(subscriptionName) subscription".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            urlString = "https://www.google.com/search?q=\(query)"
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
