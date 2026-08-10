//
//  SpendoraApp.swift
//  Spendora
//

import SwiftUI
import SwiftData
import WidgetKit

@main
struct SpendoraApp: App {

    // MARK: - Properties

    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            Group {
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
            .preferredColorScheme(isDarkMode ? .dark : nil)
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

// MARK: - MainTabView (Native Apple TabView with Emerald Tint)

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
        .tint(SpendoraTheme.accent)
    }
}
