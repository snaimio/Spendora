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
    @Environment(\.modelContext) var modelContext
    @Query var subscriptions: [Subscription]
    
    // UI presentation states
    @State var showingResetAlert = false
    @State var showingPrivacyPolicy = false
    @State var showingResetConfirmation = false
    @State var showingExportSuccess = false
    @State var showingOnboarding = false
    @State var showingDocumentPicker = false
    @State var showingShareSheet = false
    @State var shareItems: [Any] = []
    
    @State var showingYearlyReport = false
    @State var showingChallenges = false
    @State var showingSavingsScore = false
    @State var showingAIInsights = false
    @State var showingSpendingChart = false
    
    @ObservedObject var profileManager = UserProfileManager.shared
    @State var showingProfileSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    PremiumAppInfoRow()
                }
                
                Section("User Profile") {
                    SettingsUserProfileRow {
                        showingProfileSheet = true
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
                
                SettingsDataManagementSection(
                    exportCSV: exportCSV,
                    exportPDF: exportPDF,
                    exportBackup: exportBackup,
                    importBackup: { showingDocumentPicker = true },
                    resetData: { showingResetAlert = true }
                )
                
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
}
