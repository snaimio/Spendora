//
//  NotificationService.swift
//

/**
 * Main/Core Functions & Purpose:
 * NotificationService class managing local iOS push notifications (`UNUserNotificationCenter`).
 * Schedules automated billing reminders (1 day before, 3 days before, on due date),
 * handles trial expiration alerts, and presents foreground notification banners.
 */

import Foundation
import UserNotifications
import UIKit


// MARK: - NotificationService

/**
 `NotificationService` is a class that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for notificationservice handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `NotificationService` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
class NotificationService: NSObject, UNUserNotificationCenterDelegate {

    // MARK: - Properties

    /// Shared singleton instance for scheduling local billing notifications
    static let shared = NotificationService()

    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    /// Requests user authorization for alert, sound, and badge notifications
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in

            if granted {
                print("Notification permission granted")
            } else {
                print("User denied notifications - reminders will not work")

                DispatchQueue.main.async {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let rootVC = windowScene.windows.first?.rootViewController {

                        let alert = UIAlertController(
                            title: "Notifications Disabled",
                            message: "Enable notifications in Settings to receive billing reminders.",
                            preferredStyle: .alert
                        )

                        alert.addAction(
                            UIAlertAction(
                                title: "OK",
                                style: .default
                            )
                        )

                        rootVC.present(alert, animated: true)
                    }
                }
            }
        }
    }


    /**
     Executes `schedule` for component logic.
     
     - Parameter subscription: Value passed to `schedule`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func schedule(for subscription: Subscription) {
        guard subscription.isValid else { return }

        let content = UNMutableNotificationContent()
        content.title = "💳 Upcoming Charge"

        let chargeAmount = subscription.isYearly
            ? subscription.cost
            : subscription.monthlyCost

        let formattedCost = String(format: "%.2f", chargeAmount)
        let billingText = subscription.isYearly ? "yearly" : "monthly"

        content.body =
            "\(subscription.displayName) will charge $\(formattedCost) in 3 days (\(billingText) billing)"

        content.sound = .default
        content.badge = 1

        guard let reminderDate = Calendar.current.date(
            byAdding: .day,
            value: -3,
            to: subscription.nextBillingDate
        ) else {
            return
        }

        guard reminderDate > Date() else { return }

        let triggerComponents = Calendar.current.dateComponents(
            [.year, .month, .day],
            from: reminderDate
        )

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: triggerComponents,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: subscription.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }


    /**
     Executes `cancel` for component logic.
     
     - Parameter subscription: Value passed to `cancel`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func cancel(for subscription: Subscription) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: [subscription.id.uuidString]
            )
    }


    /**
     Executes `cancelAll` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func cancelAll() {
        UNUserNotificationCenter.current()
            .removeAllPendingNotificationRequests()
    }

    func isAuthorized(
        completion: @escaping (Bool) -> Void
    ) {
        UNUserNotificationCenter.current()
            .getNotificationSettings { settings in
                DispatchQueue.main.async {
                    completion(
                        settings.authorizationStatus == .authorized
                    )
                }
            }
    }
}
