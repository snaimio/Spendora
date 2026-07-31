/**
 * Main/Core Functions & Purpose:
 * Entry point for the Spendora iOS application.
 * Initializes the SwiftData model container for Subscription objects, manages the onboarding check via AppStorage,
 * configures notification permissions, and sets up the primary bottom TabView navigation structure.
 */

import SwiftUI
import SwiftData
import WidgetKit

@main
struct SpendoraApp: App {
    // Persistent flag checking if the user completed initial onboarding
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            // Show onboarding on first launch; otherwise load the main tab bar UI
            if !hasCompletedOnboarding {
                PremiumOnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            } else {
                MainTabView()
                    .modelContainer(for: Subscription.self) // Attaches local SwiftData SQLite database
                    .onAppear {
                        // Request notification permissions for upcoming bill alerts
                        NotificationService.shared.requestPermission()
                        sendWidgetData()
                    }
            }
        }
    }
    
    // Syncs fallback baseline data to shared App Group for iOS Home Screen Widgets
    func sendWidgetData() {
        let defaults = UserDefaults(suiteName: "group.com.trios2026sn.Spendora")
        defaults?.set(0.0, forKey: "totalMonthly")
        defaults?.set("None", forKey: "nextSubName")
        defaults?.set(Date().timeIntervalSince1970, forKey: "nextSubDate")
        WidgetCenter.shared.reloadAllTimelines()
    }
}

// Main tab bar container holding Dashboard, Subscriptions List, Calendar, and Settings
struct MainTabView: View {
    @State private var selectedTab = 0
    @Query private var subscriptions: [Subscription]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
                .tag(0)
            
            SubscriptionListView()
                .tabItem {
                    Label("Subscriptions", systemImage: "list.bullet")
                }
                .tag(1)
            
            SubscriptionCalendarView(subscriptions: subscriptions)
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(3)
        }
        .accentColor(.brandPrimary)
    }
}
