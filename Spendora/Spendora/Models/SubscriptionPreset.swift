//
//  SubscriptionPreset.swift
//

/**
 * Main/Core Functions & Purpose:
 * Catalog of popular pre-configured subscription presets (Netflix, Spotify, Apple, ChatGPT, Amazon Prime, etc.).
 * Provides pre-populated default pricing, category mappings, brand accent colors, and cancellation URLs for quick 1-tap addition.
 */

import Foundation
import SwiftUI


// MARK: - SubscriptionPreset

/**
 `SubscriptionPreset` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for subscriptionpreset handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `SubscriptionPreset` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct SubscriptionPreset: Identifiable {

    // MARK: - Properties

    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let category: String
    let cancellationUrl: String?
    let colorHex: String

    init(
        name: String,
        icon: String,
        color: Color,
        category: String,
        cancellationUrl: String? = nil,
        colorHex: String = "#6C63FF"
    ) {
        self.name = name
        self.icon = icon
        self.color = color
        self.category = category
        self.cancellationUrl = cancellationUrl
        self.colorHex = colorHex
    }

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
        case "notion": return "doc.text.fill"
        case "fitbit": return "heart.circle.fill"
        case "fitness": return "figure.run"
        case "amazon": return "cart.fill"
        case "hellofresh": return "leaf.fill"
        case "adobe": return "pencil.circle.fill"
        case "playstation", "xbox", "nintendo", "gaming": return "gamecontroller.fill"
        case "openai", "anthropic", "gemini", "ai", "sparkles": return "sparkles"
        case "cursor", "copilot", "code": return "chevron.left.forwardslash.chevron.right"
        case "cloud": return "cloud.fill"
        case "news": return "newspaper.fill"
        case "food", "bag": return "bag.fill"
        case "lock", "security": return "lock.shield.fill"
        case "learn", "education": return "book.fill"
        case "car": return "car.fill"
        default: return "creditcard.fill"
        }
    }
}
