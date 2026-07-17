//
//  SettingsView.swift
//  Spendora
//

import SwiftUI
import SwiftData
import WidgetKit
import UniformTypeIdentifiers
import UIKit

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var subscriptions: [Subscription]
    @ObservedObject private var currencyManager = CurrencyManager.shared
    
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @State private var showingResetAlert = false
    @State private var showingPrivacyPolicy = false
    @State private var showingResetConfirmation = false
    @State private var showingExportSuccess = false
    @State private var selectedCurrency: Currency = .CAD
    @State private var showingOnboarding = false
    @State private var notificationTime = Date()
    @State private var showingDocumentPicker = false
    
    // MARK: - Report Navigation
    @State private var showingYearlyReport = false
    @State private var showingChallenges = false
    @State private var showingSavingsScore = false
    @State private var showingAIInsights = false
    @State private var showingSpendingChart = false
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: - App Info (Premium)
                Section {
                    PremiumAppInfoRow()
                }
                
                // MARK: - Appearance
                Section("Appearance") {
                    PremiumSettingsRow(
                        icon: "moon.fill",
                        title: "Dark Mode",
                        subtitle: "Match system appearance"
                    ) {
                        Toggle("", isOn: Binding(
                            get: {
                                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                   let window = windowScene.windows.first {
                                    return window.overrideUserInterfaceStyle == .dark
                                }
                                return false
                            },
                            set: { isDark in
                                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                   let window = windowScene.windows.first {
                                    window.overrideUserInterfaceStyle = isDark ? .dark : .light
                                }
                            }
                        ))
                        .toggleStyle(SwitchToggleStyle(tint: .brandPrimary))
                        .labelsHidden()
                    }
                }
                
                // MARK: - Reports (Premium)
                Section("Reports") {
                    PremiumSettingsRow(
                        icon: "calendar",
                        title: "Yearly Report",
                        subtitle: "View annual spending summary"
                    ) {
                        Button {
                            showingYearlyReport = true
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    PremiumSettingsRow(
                        icon: "trophy",
                        title: "Challenges",
                        subtitle: "Complete achievements"
                    ) {
                        Button {
                            showingChallenges = true
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    PremiumSettingsRow(
                        icon: "star.circle.fill",
                        title: "Savings Score",
                        subtitle: "Your financial wellness"
                    ) {
                        Button {
                            showingSavingsScore = true
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    PremiumSettingsRow(
                        icon: "brain.head.profile",
                        title: "AI Insights",
                        subtitle: "Smart spending analysis"
                    ) {
                        Button {
                            showingAIInsights = true
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    PremiumSettingsRow(
                        icon: "chart.bar.fill",
                        title: "Spending Chart",
                        subtitle: "Visual spending breakdown"
                    ) {
                        Button {
                            showingSpendingChart = true
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // MARK: - App Tour
                Section("App") {
                    PremiumSettingsRow(
                        icon: "book.fill",
                        title: "Show Onboarding Tour",
                        subtitle: "Replay the welcome experience"
                    ) {
                        Button {
                            showingOnboarding = true
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // MARK: - Currency (Premium)
                Section {
                    Picker("Select Currency", selection: $selectedCurrency) {
                        ForEach(Currency.allCases, id: \.self) { currency in
                            HStack {
                                Text(currency.symbol)
                                Text(currency.code)
                            }
                            .tag(currency)
                        }
                    }
                    .onChange(of: selectedCurrency) { _, newValue in
                        currencyManager.setCurrency(newValue)
                    }
                    
                    Text("All amounts will be shown in \(currencyManager.currentCurrency.symbol) (\(currencyManager.currentCurrency.code))")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.secondary)
                } header: {
                    Text("Currency")
                } footer: {
                    Text("Change how subscription costs are displayed")
                        .font(.system(.caption, design: .rounded))
                }
                
                // MARK: - Notifications (Premium)
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
                
                // MARK: - Cloud Sync
                Section("Cloud") {
                    CloudSyncView()
                        .listRowInsets(EdgeInsets())
                }
                
                // MARK: - Support (Premium)
                Section("Support") {
                    PremiumSettingsRow(
                        icon: "square.and.arrow.up",
                        title: "Share App",
                        subtitle: "Share Spendora with friends"
                    ) {
                        Button {
                            shareApp()
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    PremiumSettingsRow(
                        icon: "envelope.fill",
                        title: "Contact Support",
                        subtitle: "Help & feedback"
                    ) {
                        Button {
                            if let url = URL(string: "mailto:support@spendora.com") {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // MARK: - Data (Premium)
                Section("Data") {
                    PremiumSettingsRow(
                        icon: "tablecells",
                        title: "Export CSV",
                        subtitle: "Spreadsheet format"
                    ) {
                        Button {
                            exportCSV()
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    PremiumSettingsRow(
                        icon: "doc.text.fill",
                        title: "Export PDF Report",
                        subtitle: "Professional report"
                    ) {
                        Button {
                            exportPDF()
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    PremiumSettingsRow(
                        icon: "arrow.up.doc",
                        title: "Backup Data",
                        subtitle: "JSON backup file"
                    ) {
                        Button {
                            exportBackup()
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    PremiumSettingsRow(
                        icon: "arrow.down.doc",
                        title: "Restore Backup",
                        subtitle: "Import from JSON file"
                    ) {
                        Button {
                            showingDocumentPicker = true
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    PremiumSettingsRow(
                        icon: "trash.fill",
                        title: "Reset All Data",
                        subtitle: "Delete all subscriptions"
                    ) {
                        Button(role: .destructive) {
                            showingResetAlert = true
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .foregroundColor(.red)
                }
                
                // MARK: - Legal (Premium)
                Section("Legal") {
                    PremiumSettingsRow(
                        icon: "lock.doc.fill",
                        title: "Privacy Policy",
                        subtitle: "How we protect your data"
                    ) {
                        Button {
                            showingPrivacyPolicy = true
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    PremiumSettingsRow(
                        icon: "info.circle.fill",
                        title: "Version",
                        subtitle: getAppVersion()
                    ) {
                        EmptyView()
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .onAppear {
                selectedCurrency = currencyManager.currentCurrency
                if let savedTime = UserDefaults.standard.object(forKey: "notificationTime") as? Date {
                    notificationTime = savedTime
                }
            }
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
            .alert("Export Successful", isPresented: $showingExportSuccess) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your data has been exported and shared.")
            }
            .sheet(isPresented: $showingPrivacyPolicy) {
                PrivacyPolicyView()
            }
            .sheet(isPresented: $showingOnboarding) {
                OnboardingSheetView()
            }
            .sheet(isPresented: $showingYearlyReport) {
                NavigationStack {
                    YearlyReportView(subscriptions: subscriptions)
                }
            }
            .sheet(isPresented: $showingChallenges) {
                NavigationStack {
                    ChallengesView(subscriptions: subscriptions)
                }
            }
            .sheet(isPresented: $showingSavingsScore) {
                NavigationStack {
                    SavingsScoreView(subscriptions: subscriptions)
                }
            }
            .sheet(isPresented: $showingAIInsights) {
                NavigationStack {
                    AIInsightsView(subscriptions: subscriptions)
                }
            }
            .sheet(isPresented: $showingSpendingChart) {
                NavigationStack {
                    SpendingChartView(subscriptions: subscriptions)
                }
            }
            .fileImporter(
                isPresented: $showingDocumentPicker,
                allowedContentTypes: [.json],
                allowsMultipleSelection: false
            ) { result in
                do {
                    let url = try result.get().first!
                    importBackup(from: url)
                } catch {
                    print("Failed to select file: \(error)")
                }
            }
        }
    }
    
    private func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
    
    private func shareApp() {
        let appStoreURL = "https://apps.apple.com/app/idYOUR_APP_ID"
        
        let activityVC = UIActivityViewController(
            activityItems: [
                "Check out Spendora! Track your subscriptions easily. \(appStoreURL)"
            ],
            applicationActivities: nil
        )
        
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
            let defaults = UserDefaults(suiteName: "group.com.trios2026sn.Spendora")
            defaults?.removeObject(forKey: "totalMonthly")
            defaults?.removeObject(forKey: "nextSubName")
            defaults?.synchronize()
            WidgetCenter.shared.reloadAllTimelines()
            showingResetConfirmation = true
        } catch {
            print("Failed to reset data: \(error)")
        }
    }
    
    private func exportCSV() {
        guard let fileURL = ExportService.generateCSV(subscriptions: subscriptions) else { return }
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            ExportService.shareCSV(from: rootVC, fileURL: fileURL)
            showingExportSuccess = true
        }
    }
    
    private func exportPDF() {
        guard let fileURL = PDFExportService.generatePDF(subscriptions: subscriptions) else { return }
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            rootVC.present(activityVC, animated: true)
            showingExportSuccess = true
        }
    }
    
    private func exportBackup() {
        guard let url = BackupService.shared.exportBackup(subscriptions: subscriptions) else { return }
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            rootVC.present(activityVC, animated: true)
        }
    }
    
    private func importBackup(from url: URL) {
        do {
            _ = try BackupService.shared.importBackup(from: url, modelContext: modelContext)
            showingResetConfirmation = true
        } catch {
            print("Restore failed: \(error)")
        }
    }
}

// MARK: - Premium App Info Row
struct PremiumAppInfoRow: View {
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [.brandPrimary.opacity(0.12), .brandSecondary.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Image(systemName: "creditcard.and.123")
                    .font(.title2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.brandPrimary, .brandSecondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Spendora")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                
                Text("Version \(getAppVersion())")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Premium badge
            HStack(spacing: 4) {
                Image(systemName: "sparkles")
                    .font(.system(size: 10))
                Text("PRO")
                    .font(.system(.caption2, design: .rounded))
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                LinearGradient(
                    colors: [.brandPrimary, .brandSecondary],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(8)
        }
        .padding(.vertical, 4)
    }
    
    private func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}

// MARK: - Premium Settings Row
struct PremiumSettingsRow<Content: View>: View {
    let icon: String
    let title: String
    let subtitle: String?
    let trailing: Content?
    
    init(icon: String, title: String, subtitle: String? = nil, @ViewBuilder trailing: () -> Content? = { nil }) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.trailing = trailing()
    }
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.brandPrimary)
                .frame(width: 28)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(.body, design: .rounded))
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if let trailing = trailing {
                trailing
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview
#Preview {
    SettingsView()
}
