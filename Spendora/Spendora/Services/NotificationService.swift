//
//  NotificationService.swift
//  Spendora
//

import Foundation
import UserNotifications
import UIKit

class NotificationService: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationService()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
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
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        rootVC.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    func schedule(for subscription: Subscription) {
        guard subscription.isValid else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "💳 Upcoming Charge"
        
        let chargeAmount = subscription.isYearly ? subscription.cost : subscription.monthlyCost
        let formattedCost = String(format: "%.2f", chargeAmount)
        let billingText = subscription.isYearly ? "yearly" : "monthly"
        
        content.body = "\(subscription.displayName) will charge $\(formattedCost) in 3 days (\(billingText) billing)"
        content.sound = .default
        content.badge = 1
        
        guard let reminderDate = Calendar.current.date(
            byAdding: .day,
            value: -3,
            to: subscription.nextBillingDate
        ) else { return }
        
        guard reminderDate > Date() else { return }
        
        let triggerComponents = Calendar.current.dateComponents([.year, .month, .day], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: subscription.id.uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    func cancel(for subscription: Subscription) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [subscription.id.uuidString])
    }
    
    func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func isAuthorized(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}
