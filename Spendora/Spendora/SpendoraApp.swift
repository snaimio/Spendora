//
//  SpendoraApp.swift
//  Spendora
//

import SwiftUI
import SwiftData

@main
struct SpendoraApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Subscription.self)
    }
}

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        if hasCompletedOnboarding {
            MainTabView()
        } else {
            PremiumOnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
        }
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    @State private var selectedTab = 0
    @Query private var subscriptions: [Subscription]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            SubscriptionCalendarView(subscriptions: subscriptions)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(2)
        }
        .accentColor(.brandPrimary)
    }
}
