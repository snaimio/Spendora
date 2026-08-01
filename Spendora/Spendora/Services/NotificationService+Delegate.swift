//
//  NotificationService+Delegate.swift
//

/**
 * Main/Core Functions & Purpose:
 * Extension for NotificationService providing trial expiration reminders, price increase alerts,
 * and UNUserNotificationCenterDelegate foreground presentation handling.
 */

import Foundation
import UserNotifications


// MARK: - NotificationService Extension

/**
 Extension on `NotificationService` providing utility methods and helpers.
 */
extension NotificationService {
    
    /// Schedules a notification 3 days prior to free trial conversion
    func scheduleTrialReminder(for subscription: Subscription) {
        guard subscription.isTrial,
              let trialEndDate = subscription.trialEndDate,
              !subscription.trialConvertedToPaid
        else {
            return
        }

        guard let reminderDate = Calendar.current.date(
            byAdding: .day,
            value: -3,
            to: trialEndDate
        ),
        reminderDate > Date()
        else {
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "⚠️ Trial Ending Soon"
        content.body = "\(subscription.displayName) free trial ends in 3 days. It will convert to \(String(format: "$%.2f", subscription.monthlyCost))/month."
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents(
                [.year, .month, .day],
                from: reminderDate
            ),
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "trial_\(subscription.id.uuidString)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    /// Triggers immediate alert when a subscription price increase is detected
    func schedulePriceAlert(for subscription: Subscription) {
        guard subscription.priceAlertEnabled,
              let expectedPrice = subscription.expectedPrice,
              subscription.cost > expectedPrice
        else {
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "📈 Price Increase Detected"
        content.body = "\(subscription.displayName) price increased from \(String(format: "$%.2f", expectedPrice)) to \(String(format: "$%.2f", subscription.cost))"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "price_\(subscription.id.uuidString)",
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request)
    }

    /// UNUserNotificationCenterDelegate method displaying banners while app is active in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
}
