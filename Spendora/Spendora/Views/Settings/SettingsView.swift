//
//  SettingsView.swift
//  Spendora
//

import SwiftUI
import SwiftData
import WidgetKit
import UniformTypeIdentifiers
import UIKit

// MARK: - SettingsView (Apple Native Form Screen)

struct SettingsView: View {

    // MARK: - Properties

    @Environment(\.modelContext) var modelContext
    @Query var subscriptions: [Subscription]
    @AppStorage("isDarkMode") private var isDarkMode = false
    
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

    // MARK: - Body

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Brand Header: Above Form as a custom card
                PremiumAppInfoRow()
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                
                // Form: Native iOS Settings Look
                Form {
                    // Section: User Profile
                    Section("User Profile") {
                        Button {
                            showingProfileSheet = true
                        } label: {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(SpendoraTheme.accentTint)
                                        .frame(width: 40, height: 40)
                                    
                                    Text(profileManager.profile.initials)
                                        .font(.headline.weight(.semibold))
                                        .foregroundColor(SpendoraTheme.accentText)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(profileManager.profile.displayName)
                                        .font(.headline)
                                        .foregroundColor(Color(.label))
                                    
                                    Text(profileManager.profile.isGuest ? "Guest Mode (Local)" : profileManager.profile.email)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    
                    // Section: Appearance
                    Section("Appearance") {
                        Toggle(isOn: $isDarkMode) {
                            Label("Dark Mode", systemImage: "moon.fill")
                                .foregroundColor(Color(.label))
                        }
                        .tint(SpendoraTheme.accent)
                    }
                    
                    // Section: Reports & Insights
                    Section("Intelligence") {
                        Button {
                            showingYearlyReport = true
                        } label: {
                            Label("Yearly Executive Summary", systemImage: "calendar")
                                .foregroundColor(Color(.label))
                        }
                        
                        Button {
                            showingChallenges = true
                        } label: {
                            Label("Spending Challenges", systemImage: "trophy")
                                .foregroundColor(Color(.label))
                        }
                        
                        Button {
                            showingSavingsScore = true
                        } label: {
                            Label("Savings Intelligence Score", systemImage: "star")
                                .foregroundColor(Color(.label))
                        }
                        
                        Button {
                            showingAIInsights = true
                        } label: {
                            Label("AI Cost Optimizations", systemImage: "brain.head.profile")
                                .foregroundColor(Color(.label))
                        }
                    }
                    
                    // Section: Preferences
                    Section("Preferences") {
                        CurrencySection()
                        NotificationsSection()
                    }
                    
                    // Section: Data & Backup
                    Section("Data Management") {
                        Button {
                            exportCSV()
                        } label: {
                            Label("Export to CSV", systemImage: "square.and.arrow.up")
                                .foregroundColor(Color(.label))
                        }
                        
                        Button {
                            exportPDF()
                        } label: {
                            Label("Export PDF Report", systemImage: "doc.richtext")
                                .foregroundColor(Color(.label))
                        }
                        
                        Button {
                            exportBackup()
                        } label: {
                            Label("Create Encrypted Backup", systemImage: "arrow.up.doc")
                                .foregroundColor(Color(.label))
                        }
                        
                        Button {
                            showingDocumentPicker = true
                        } label: {
                            Label("Restore from Backup", systemImage: "arrow.down.doc")
                                .foregroundColor(Color(.label))
                        }
                    }
                    
                    // Section: Danger Zone (Reset All Data)
                    Section {
                        Button(role: .destructive) {
                            showingResetAlert = true
                        } label: {
                            Label("Reset All Data", systemImage: "trash")
                        }
                    }
                    
                    // Section: About
                    Section {
                        Button {
                            showingPrivacyPolicy = true
                        } label: {
                            Label("Privacy Policy", systemImage: "hand.raised")
                                .foregroundColor(Color(.label))
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
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
                YearlyReportView(subscriptions: subscriptions)
            }
            .sheet(isPresented: $showingChallenges) {
                ChallengesView(subscriptions: subscriptions)
            }
            .sheet(isPresented: $showingSavingsScore) {
                SavingsScoreView(subscriptions: subscriptions)
            }
            .sheet(isPresented: $showingAIInsights) {
                AIInsightsView(subscriptions: subscriptions)
            }
        }
    }
    
    // MARK: - Actions

    func exportCSV() {
        if let url = ExportService.shared.exportToCSV(subscriptions: subscriptions) {
            shareItems = [url]
            showingShareSheet = true
        }
    }
    
    func exportPDF() {
        let renderer = PDFReportRenderer(subscriptions: subscriptions)
        if let url = renderer.generatePDF() {
            shareItems = [url]
            showingShareSheet = true
        }
    }
    
    func exportBackup() {
        if let url = BackupService.shared.createBackup(subscriptions: subscriptions) {
            shareItems = [url]
            showingShareSheet = true
        }
    }
    
    func resetAllData() {
        for sub in subscriptions {
            NotificationService.shared.cancel(for: sub)
            modelContext.delete(sub)
        }
        try? modelContext.save()
        showingResetConfirmation = true
    }
    
    func shareApp() {
        if let url = URL(string: "https://apps.apple.com/app/spendora") {
            shareItems = [url]
            showingShareSheet = true
        }
    }
}
