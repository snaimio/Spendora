//
//  SpendoraApp.swift
//  Spendora
//

import SwiftUI
import SwiftData
import WidgetKit

@main
struct SpendoraApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            if !hasCompletedOnboarding {
                PremiumOnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            } else {
                MainTabView()
                    .modelContainer(for: Subscription.self)
                    .onAppear {
                        NotificationService.shared.requestPermission()
                        sendWidgetData()
                    }
            }
        }
    }
    
    func sendWidgetData() {
    
        let defaults = UserDefaults(suiteName: "group.com.trios2026sn.Spendora")
        defaults?.set(0.0, forKey: "totalMonthly")
        defaults?.set("None", forKey: "nextSubName")
        defaults?.set(Date().timeIntervalSince1970, forKey: "nextSubDate")
        WidgetCenter.shared.reloadAllTimelines()
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    @State private var selectedTab = 0
    @Query private var subscriptions: [Subscription]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Dashboard
            HomeView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
                .tag(0)
            
            // Tab 2: Subscriptions
            SubscriptionListView()
                .tabItem {
                    Label("Subscriptions", systemImage: "list.bullet")
                }
                .tag(1)
            
            // Tab 3: Calendar
            SubscriptionCalendarView(subscriptions: subscriptions)
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(2)
            
            // Tab 4: Settings
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(3)
        }
        .accentColor(.brandPrimary)
        .sheet(isPresented: Binding(
            get: { selectedTab == 4 },
            set: { if !$0 { selectedTab = 0 } }
        )) {
            NavigationStack {
                AddSubscriptionView()
            }
        }
    }
}
