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

// MARK: - Content View (Main App)
struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var selectedTab = 0
    @Query private var subscriptions: [Subscription]
    
    var body: some View {
        if hasCompletedOnboarding {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(0)
                
                SubscriptionCalendarView(subscriptions: subscriptions)
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                    }
                    .tag(1)
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(2)
            }
            .accentColor(.brandPrimary)
        } else {
            PremiumOnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
        }
    }
}
