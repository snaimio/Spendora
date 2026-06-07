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
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Subscription.nextBillingDate, order: .forward) private var subscriptions: [Subscription]
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var selectedTab = 0
    
    var body: some View {
        if hasCompletedOnboarding {
            TabView(selection: $selectedTab) {
                // Tab 1: Home (Subscriptions List)
                HomeView()
                    .tabItem {
                        Label("Subscriptions", systemImage: "list.bullet")
                    }
                    .tag(0)
                
                // Tab 2: Calendar View
                SubscriptionCalendarView(subscriptions: subscriptions)
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                    }
                    .tag(1)
                
                // Tab 3: Settings
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(2)
            }
        } else {
            OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
        }
    }
}

// MARK: - Onboarding View
struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "creditcard.and.123")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Welcome to Spendora")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Take control of your subscriptions")
                .font(.title3)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 20) {
                OnboardingFeature(
                    icon: "plus.circle.fill",
                    title: "Track Everything",
                    description: "Add all your subscriptions in one place"
                )
                
                OnboardingFeature(
                    icon: "bell.fill",
                    title: "Smart Reminders",
                    description: "Get notified 3 days before each charge"
                )
                
                OnboardingFeature(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Insights",
                    description: "See your total monthly and yearly spending"
                )
                
                OnboardingFeature(
                    icon: "calendar",
                    title: "Calendar View",
                    description: "See all your billing dates at a glance"
                )
            }
            .padding(.horizontal, 32)
            
            Spacer()
            
            Button(action: {
                NotificationService.shared.requestPermission()
                hasCompletedOnboarding = true
            }) {
                Text("Get Started")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct OnboardingFeature: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}
