//
//  SettingsView.swift
//  Spendora
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var subscriptions: [Subscription]
    
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showingResetAlert = false
    @State private var showingPrivacyPolicy = false
    @State private var showingResetConfirmation = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Image(systemName: "creditcard.and.123")
                            .font(.title)
                            .foregroundColor(.blue)
                            .frame(width: 50, height: 50)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Spendora")
                                .font(.headline)
                            Text("Version \(getAppVersion())")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Appearance") {
                    HStack {
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .foregroundColor(isDarkMode ? .yellow : .orange)
                        Toggle("Dark Mode", isOn: $isDarkMode)
                            .onChange(of: isDarkMode) { _, newValue in
                                toggleDarkMode(newValue)
                            }
                    }
                }
                
                Section("Notifications") {
                    Toggle("Enable Reminders", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { _, newValue in
                            if newValue {
                                NotificationService.shared.requestPermission()
                            } else {
                                NotificationService.shared.cancelAll()
                            }
                        }
                    
                    Text("You'll receive reminders 3 days before each subscription renews")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button("Open Notification Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    .font(.caption)
                }
                
                Section("Support") {
                    Button {
                        shareApp()
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.blue)
                            Text("Share App")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section("Legal") {
                    Button {
                        showingPrivacyPolicy = true
                    } label: {
                        HStack {
                            Image(systemName: "lock.doc.fill")
                                .foregroundColor(.blue)
                            Text("Privacy Policy")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section("Data") {
                    Button(role: .destructive) {
                        showingResetAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("Reset All Data")
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Reset All Data", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    resetAllData()
                }
            } message: {
                Text("This will delete all your subscriptions. This action cannot be undone.")
            }
            .alert("Success", isPresented: $showingResetConfirmation) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("All data has been reset successfully.")
            }
            .sheet(isPresented: $showingPrivacyPolicy) {
                PrivacyPolicyView()
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
    
    private func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
    
    private func shareApp() {
        let appStoreURL = "https://apps.apple.com/app/idYOUR_APP_ID"
        let activityVC = UIActivityViewController(activityItems: ["Check out Spendora! Track your subscriptions easily. \(appStoreURL)"], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
    
    private func resetAllData() {
        NotificationService.shared.cancelAll()
        
        for subscription in subscriptions {
            modelContext.delete(subscription)
        }
        
        do {
            try modelContext.save()
            showingResetConfirmation = true
        } catch {
            print("Failed to reset data: \(error)")
        }
    }
    
    private func toggleDarkMode(_ isDark: Bool) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        if isDark {
            window.overrideUserInterfaceStyle = .dark
        } else {
            window.overrideUserInterfaceStyle = .light
        }
    }
}

// MARK: - Privacy Policy View
struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Privacy Policy")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Last Updated: \(Date().formatted(date: .long, time: .omitted))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Group {
                        PolicySection(title: "Data Collection", content: "Spendora does not collect any personal data. All subscription information is stored locally on your device.")
                        PolicySection(title: "No Third-Party Sharing", content: "Since we don't collect any data, we don't share any data with third parties.")
                        PolicySection(title: "Notifications", content: "If you enable notifications, they are scheduled locally on your device.")
                        PolicySection(title: "Your Rights", content: "You have complete control over your data. You can delete all data at any time.")
                        PolicySection(title: "Contact", content: "Questions? Email support@spendora.com")
                    }
                }
                .padding()
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct PolicySection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}
