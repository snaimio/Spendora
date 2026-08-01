//
//  NotificationsSection.swift
//

import SwiftUI


// MARK: - NotificationsSection

/**
 `NotificationsSection` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for notificationssection handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `NotificationsSection` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct NotificationsSection: View {

    // MARK: - Properties

    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @State private var notificationTime = Date()
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
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
