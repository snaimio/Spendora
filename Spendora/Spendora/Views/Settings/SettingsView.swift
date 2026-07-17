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
    
    @State private var showingResetAlert = false
    @State private var showingPrivacyPolicy = false
    @State private var showingResetConfirmation = false
    @State private var showingExportSuccess = false
    @State private var showingOnboarding = false
    @State private var showingDocumentPicker = false
    
    @State private var showingYearlyReport = false
    @State private var showingChallenges = false
    @State private var showingSavingsScore = false
    @State private var showingAIInsights = false
    @State private var showingSpendingChart = false
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: - App Info
                Section {
                    PremiumAppInfoRow()
                }
                
                // MARK: - Appearance
                AppearanceSection()
                
                // MARK: - Reports
                ReportsSection(
                    subscriptions: subscriptions,
                    showingYearlyReport: $showingYearlyReport,
                    showingChallenges: $showingChallenges,
                    showingSavingsScore: $showingSavingsScore,
                    showingAIInsights: $showingAIInsights,
                    showingSpendingChart: $showingSpendingChart
                )
                
                // MARK: - App Tour
                AppTourSection(showingOnboarding: $showingOnboarding)
                
                // MARK: - Currency
                CurrencySection()
                
                // MARK: - Notifications
                NotificationsSection()
                
                // MARK: - Cloud Sync
                Section("Cloud") {
                    CloudSyncView()
                        .listRowInsets(EdgeInsets())
                }
                
                // MARK: - Support
                SupportSection(shareApp: shareApp)
                
                // MARK: - Data
                DataSection(
                    subscriptions: subscriptions,
                    exportCSV: exportCSV,
                    exportPDF: exportPDF,
                    exportBackup: exportBackup,
                    onRestore: { showingDocumentPicker = true },
                    onReset: { showingResetAlert = true }
                )
                
                // MARK: - Legal
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
    
    // MARK: - Private Methods
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
