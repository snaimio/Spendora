//
//  Constants.swift
//  Spendora
//

import Foundation

struct AppConstants {
    
    // MARK: - Notification Identifiers
    struct Notifications {
        static let subscriptionAdded = NSNotification.Name("SubscriptionAdded")
        static let subscriptionDeleted = NSNotification.Name("SubscriptionDeleted")
        static let subscriptionUpdated = NSNotification.Name("SubscriptionUpdated")
    }
    
    // MARK: - UserDefaults Keys
    struct UserDefaultsKeys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let notificationsEnabled = "notificationsEnabled"
        static let selectedCurrencyCode = "selectedCurrencyCode"
    }
    
    // MARK: - App Info
    struct AppInfo {
        static let appName = "Spendora"
        static let supportEmail = "support@spendora.com"
        static let appStoreURL = "https://apps.apple.com/app/idYOUR_APP_ID"
    }
    
    // MARK: - Date Formats
    struct DateFormats {
        static let display = "MMM d, yyyy"
        static let shortDisplay = "MMM d"
        static let api = "yyyy-MM-dd"
    }
    
    // MARK: - Animation Durations
    struct AnimationDuration {
        static let fast = 0.2
        static let normal = 0.35
        static let slow = 0.5
        static let confetti = 2.0
    }
}
