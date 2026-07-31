/**
 * Main/Core Functions & Purpose:
 * Catalog of popular pre-configured subscription presets (Netflix, Spotify, Apple, ChatGPT, Amazon Prime, etc.).
 * Provides pre-populated default pricing, category mappings, brand accent colors, and cancellation URLs for quick 1-tap addition.
 */

import Foundation
import SwiftUI

struct SubscriptionPreset: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let category: String
    let cancellationUrl: String?

    var systemIcon: String {
        switch icon {
        case "netflix": return "tv.fill"
        case "spotify": return "music.note"
        case "apple.music": return "music.note.list"
        case "disney": return "star.fill"
        case "hulu": return "play.circle.fill"
        case "youtube": return "play.rectangle.fill"
        case "hbo": return "film.fill"
        case "prime": return "shippingbox.fill"
        case "microsoft": return "building.columns.fill"
        case "google": return "globe"
        case "dropbox": return "folder.fill"
        case "notion": return "rectangle.inset.checked"
        case "fitbit": return "heart.circle.fill"
        case "fitness": return "figure.walk"
        case "amazon": return "cart.fill"
        case "hellofresh": return "leaf.fill"
        case "adobe": return "pencil.circle.fill"
        case "playstation": return "gamecontroller.fill"
        case "xbox": return "gamecontroller.fill"
        default: return "creditcard.fill"
        }
    }
}
