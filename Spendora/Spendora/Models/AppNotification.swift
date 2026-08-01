//
//  AppNotification.swift
//

import Foundation

// MARK: - AppNotification Model

struct AppNotification: Identifiable, Codable, Equatable {
    let id: UUID
    let subscriptionId: String
    let title: String
    let body: String
    let date: Date
    var isRead: Bool
    
    init(
        id: UUID = UUID(),
        subscriptionId: String,
        title: String,
        body: String,
        date: Date = Date(),
        isRead: Bool = false
    ) {
        self.id = id
        self.subscriptionId = subscriptionId
        self.title = title
        self.body = body
        self.date = date
        self.isRead = isRead
    }
}
