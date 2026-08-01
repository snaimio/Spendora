//
//  Constants.swift
//

import Foundation


// MARK: - AppConstants

/**
 `AppConstants` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for appconstants handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `AppConstants` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct AppConstants {

    // MARK: - Properties


    // MARK: - Notification Identifiers

// MARK: - Notifications

/**
 `Notifications` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for notifications handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `Notifications` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
    struct Notifications {

    // MARK: - Properties

        static let subscriptionAdded = NSNotification.Name("SubscriptionAdded")
        static let subscriptionDeleted = NSNotification.Name("SubscriptionDeleted")
        static let subscriptionUpdated = NSNotification.Name("SubscriptionUpdated")
    }

    // MARK: - UserDefaults Keys

// MARK: - UserDefaultsKeys

/**
 `UserDefaultsKeys` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for userdefaultskeys handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `UserDefaultsKeys` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
    struct UserDefaultsKeys {

    // MARK: - Properties

        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let notificationsEnabled = "notificationsEnabled"
        static let selectedCurrencyCode = "selectedCurrencyCode"
    }

    // MARK: - App Info

// MARK: - AppInfo

/**
 `AppInfo` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for appinfo handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `AppInfo` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
    struct AppInfo {

    // MARK: - Properties

        static let appName = "Spendora"
        static let supportEmail = "support@spendora.app"
        static let appStoreURL = "https://apps.apple.com/app/spendora"
    }

    // MARK: - Date Formats

// MARK: - DateFormats

/**
 `DateFormats` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for dateformats handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `DateFormats` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
    struct DateFormats {

    // MARK: - Properties

        static let display = "MMM d, yyyy"
        static let shortDisplay = "MMM d"
        static let api = "yyyy-MM-dd"
    }

    // MARK: - Animation Durations

// MARK: - AnimationDuration

/**
 `AnimationDuration` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for animationduration handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `AnimationDuration` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
    struct AnimationDuration {

    // MARK: - Properties

        static let fast = 0.2
        static let normal = 0.35
        static let slow = 0.5
        static let confetti = 2.0
    }
}

