//
//  SettingsView.swift
//  Spendora
//
//  Capstone 2026 - Mobile Application Development
//  Author: Sheikh Naim
//

/**
 * Main/Core Functions & Purpose:
 * SettingsView screen presenting configuration options for user profile management,
 * global currency conversion, appearance theme selection, notification alerts, iCloud Sync & Backup,
 * data export (CSV/PDF), and Capstone project information.
 */

import SwiftUI
import SwiftData
import WidgetKit
import UniformTypeIdentifiers
import UIKit

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var subscriptions: [Subscription]
    
    // UI presentation states
    @State private var showingResetAlert = false
    @State private var showingPrivacyPolicy = false
    @State private var showingResetConfirmation = false
    @State private var showingExportSuccess = false
    @State private var showingOnboarding = false
    @State private var showingDocumentPicker = false
    @State private var showingShareSheet = false
    @State private var shareItems: [Any] = []
    
    @State private var showingYearlyReport = false
    @State private var showingChallenges = false
    @State private var showingSavingsScore = false
    @State private var showingAIInsights = false
    @State private var showingSpendingChart = false
    
    @ObservedObject private var profileManager = UserProfileManager.shared
    @State private var showingProfileSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    PremiumAppInfoRow()
                }
                
                Section("User Profile") {
                    Button {
                        showingProfileSheet = true
                    } label: {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(hex: profileManager.profile.avatarColorHex),
                                                Color(hex: profileManager.profile.avatarColorHex).opacity(0.6)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 44, height: 44)
                                
                                Text(profileManager.profile.initials)
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(profileManager.profile.displayName)
                                    .font(.system(.headline, design: .rounded))
                                    .foregroundColor(.textPrimary)
                                
                                HStack(spacing: 4) {
                                    Image(systemName: profileManager.profile.provider.icon)
                                        .font(.caption2)
                                    Text(profileManager.profile.isGuest ? "Guest Mode (Local)" : profileManager.profile.email)
                                        .font(.system(.caption, design: .rounded))
                                }
                                .foregroundColor(.textSecondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                AppearanceSection()
                
                ReportsSection(
                    subscriptions: subscriptions,
                    showingYearlyReport: $showingYearlyReport,
                    showingChallenges: $showingChallenges,
                    showingSavingsScore: $showingSavingsScore,
                    showingAIInsights: $showingAIInsights,
                    showingSpendingChart: $showingSpendingChart
                )
                
                AppTourSection(showingOnboarding: $showingOnboarding)
                
                CurrencySection()
                
                NotificationsSection()
                
                Section("Cloud") {
                    CloudSyncView()
                        .listRowInsets(EdgeInsets())
                }
                
                SupportSection(shareApp: shareApp)
                
                Section("Export & Backup") {
                    // Export CSV
                    Button {
                        exportCSV()
                    } label: {
                        HStack {
                            Image(systemName: "tablecells")
                                .foregroundColor(.brandPrimary)
                                .frame(width: 28)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Export CSV")
                                    .font(.system(.body, design: .rounded))
                                Text("Spreadsheet format")
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Export PDF
                    Button {
                        exportPDF()
                    } label: {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.brandPrimary)
                                .frame(width: 28)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Export PDF Report")
                                    .font(.system(.body, design: .rounded))
                                Text("Professional report")
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Backup
                    Button {
                        exportBackup()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.up.doc")
                                .foregroundColor(.brandPrimary)
                                .frame(width: 28)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Backup Data")
                                    .font(.system(.body, design: .rounded))
                                Text("JSON backup file")
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Restore
                    Button {
                        showingDocumentPicker = true
                    } label: {
                        HStack {
                            Image(systemName: "arrow.down.doc")
                                .foregroundColor(.brandPrimary)
                                .frame(width: 28)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Restore Backup")
                                    .font(.system(.body, design: .rounded))
                                Text("Import from JSON file")
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Reset
                    Button(role: .destructive) {
                        showingResetAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.red)
                                .frame(width: 28)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Reset All Data")
                                    .font(.system(.body, design: .rounded))
                                    .foregroundColor(.red)
                                Text("Delete all subscriptions")
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                LegalSection(showingPrivacyPolicy: $showingPrivacyPolicy)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .alert("Reset All Data", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    resetAllData()
                }
            } message: {
                Text("This will delete all your subscriptions. This action cannot be undone.")
            }
            .sheet(isPresented: $showingProfileSheet) {
                ProfileView()
            }
            .alert("Success", isPresented: $showingResetConfirmation) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("All data has been reset successfully.")
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(items: shareItems)
            }
            .sheet(isPresented: $showingPrivacyPolicy) {
                PrivacyPolicyView()
            }
            .sheet(isPresented: $showingOnboarding) {
                PremiumOnboardingView(hasCompletedOnboarding: $showingOnboarding)
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
    
    private func shareApp() {
        let appStoreURL = AppConstants.AppInfo.appStoreURL
        
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
    
    // MARK: - Export Functions
    
    private func exportCSV() {
        let csvString = ExportService.generateCSVString(subscriptions: subscriptions)
        
        let tempDir = FileManager.default.temporaryDirectory
        let fileName = "Spendora_Export_\(Date().timeIntervalSince1970).csv"
        let fileURL = tempDir.appendingPathComponent(fileName)
        
        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            shareItems = [fileURL]
            showingShareSheet = true
            showingExportSuccess = true
        } catch {
            print("Error creating CSV file: \(error)")
        }
    }
    
    private func exportPDF() {
        guard let fileURL = PDFExportService.generatePDF(subscriptions: subscriptions) else {
            print("Failed to generate PDF")
            return
        }
        shareItems = [fileURL]
        showingShareSheet = true
        showingExportSuccess = true
    }
    
    private func exportBackup() {
        guard let fileURL = BackupService.shared.exportBackup(subscriptions: subscriptions) else {
            print("Failed to generate backup")
            return
        }
        shareItems = [fileURL]
        showingShareSheet = true
    }
    
    private func importBackup(from url: URL) {
        do {
            let count = try BackupService.shared.importBackup(from: url, modelContext: modelContext)
            showingResetConfirmation = true
            print("Imported \(count) subscriptions")
        } catch {
            print("Restore failed: \(error)")
        }
    }
}
