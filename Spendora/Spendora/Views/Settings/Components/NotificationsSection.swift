//
//  NotificationsSection.swift
//  Spendora
//

import SwiftUI

struct NotificationsSection: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @State private var notificationTime = Date()
    
    var body: some View {
        Section("Notifications") {
            PremiumSettingsRow(
                icon: "bell.fill",
                title: "Enable Reminders",
                subtitle: "Get notified 3 days before renewal"
            ) {
                Toggle("", isOn: $notificationsEnabled)
                    .toggleStyle(SwitchToggleStyle(tint: .brandPrimary))
                    .labelsHidden()
                    .onChange(of: notificationsEnabled) { _, newValue in
                        if newValue {
                            NotificationService.shared.requestPermission()
                        } else {
                            NotificationService.shared.cancelAll()
                        }
                    }
            }
            
            Button("Open Notification Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .font(.system(.caption, design: .rounded))
            .foregroundColor(.brandPrimary)
            
            HStack {
                Text("Reminder Time")
                    .font(.system(.body, design: .rounded))
                Spacer()
                DatePicker("", selection: $notificationTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .onChange(of: notificationTime) { _, newTime in
                        UserDefaults.standard.set(newTime, forKey: "notificationTime")
                    }
            }
        }
        .onAppear {
            if let savedTime = UserDefaults.standard.object(forKey: "notificationTime") as? Date {
                notificationTime = savedTime
            }
        }
    }
}
