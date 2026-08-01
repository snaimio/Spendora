//
//  NotificationCenterSheet.swift
//

import SwiftUI
import UserNotifications

// MARK: - NotificationCenterSheet

struct NotificationCenterSheet: View {
    @ObservedObject var service = NotificationCenterService.shared
    @Environment(\.dismiss) private var dismiss
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        NavigationStack {
            Group {
                if service.notifications.isEmpty {
                    emptyNotificationsState
                } else {
                    notificationListContent
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.brandPrimary)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if !service.notifications.isEmpty {
                        Menu {
                            Button {
                                generator.impactOccurred()
                                service.markAllAsRead()
                            } label: {
                                Label("Mark All as Read", systemImage: "checkmark.circle")
                            }
                            
                            Button(role: .destructive) {
                                generator.impactOccurred()
                                service.clearAll()
                            } label: {
                                Label("Clear All", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.title3)
                                .foregroundColor(.brandPrimary)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Notification List
    private var notificationListContent: some View {
        List {
            Section {
                ForEach(service.notifications) { item in
                    NotificationRowCard(item: item) {
                        generator.impactOccurred()
                        service.markAsRead(id: item.id)
                    } onDelete: {
                        generator.impactOccurred()
                        withAnimation {
                            service.clearNotification(id: item.id)
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let item = service.notifications[index]
                        service.clearNotification(id: item.id)
                    }
                }
            } header: {
                HStack {
                    Text("Activity History")
                    Spacer()
                    if service.unreadCount > 0 {
                        Text("\(service.unreadCount) unread")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.brandPrimary.opacity(0.15))
                            .foregroundColor(.brandPrimary)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    // MARK: - Empty State
    private var emptyNotificationsState: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.brandPrimary.opacity(0.12))
                    .frame(width: 90, height: 90)
                Image(systemName: "bell.slash.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.brandPrimary)
            }
            
            VStack(spacing: 8) {
                Text("No Notifications Yet")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("You're all caught up! Billing reminders and price alerts will appear here when generated.")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

// MARK: - NotificationRowCard

struct NotificationRowCard: View {
    let item: AppNotification
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    Circle()
                        .fill(item.isRead ? Color.gray.opacity(0.15) : Color.brandPrimary.opacity(0.2))
                        .frame(width: 42, height: 42)
                    Image(systemName: item.isRead ? "bell" : "bell.fill")
                        .font(.headline)
                        .foregroundColor(item.isRead ? .gray : .brandPrimary)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(item.title)
                            .font(.system(.headline, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(item.date, style: .relative)
                            .font(.system(.caption2, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    
                    Text(item.body)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                if !item.isRead {
                    Circle()
                        .fill(Color.brandPrimary)
                        .frame(width: 8, height: 8)
                        .padding(.top, 6)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
            
            if !item.isRead {
                Button {
                    onTap()
                } label: {
                    Label("Read", systemImage: "checkmark.circle")
                }
                .tint(.brandPrimary)
            }
        }
    }
}
