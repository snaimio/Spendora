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
    let name: String  // name property
    let icon: String  // icon property
    let color: Color  // color property
    let category: String  // category property
    let cancellationUrl: String?  // cancellationUrl property

    var systemIcon: String {  // systemIcon property
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
