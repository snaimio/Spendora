//
//  NotificationCenterService.swift
//

import Foundation
import UserNotifications
import Combine

// MARK: - NotificationCenterService

class NotificationCenterService: ObservableObject {
    static let shared = NotificationCenterService()
    
    @Published var notifications: [AppNotification] = [] {
        didSet {
            saveNotifications()
        }
    }
    
    var unreadCount: Int {
        notifications.filter { !$0.isRead }.count
    }
    
    private let storageKey = "spendora_notification_history_log"
    
    private init() {
        loadNotifications()
    }
    
    private func loadNotifications() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([AppNotification].self, from: data) {
            self.notifications = decoded
        }
    }
    
    private func saveNotifications() {
        if let encoded = try? JSONEncoder().encode(notifications) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    func addNotification(title: String, body: String, subscriptionId: String) {
        let newNotification = AppNotification(
            subscriptionId: subscriptionId,
            title: title,
            body: body,
            date: Date(),
            isRead: false
        )
        // Insert at beginning for reverse-chronological order
        notifications.insert(newNotification, at: 0)
    }
    
    func markAsRead(id: UUID) {
        if let index = notifications.firstIndex(where: { $0.id == id }) {
            notifications[index].isRead = true
        }
        updateAppBadge()
    }
    
    func markAllAsRead() {
        for index in notifications.indices {
            notifications[index].isRead = true
        }
        updateAppBadge()
    }
    
    func clearNotification(id: UUID) {
        notifications.removeAll { $0.id == id }
        updateAppBadge()
    }
    
    func clearAll() {
        notifications.removeAll()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        updateAppBadge()
    }
    
    private func updateAppBadge() {
        let count = unreadCount
        UNUserNotificationCenter.current().setBadgeCount(count) { _ in }
    }
}
