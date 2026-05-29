//
//  SpendoraApp.swift
//  Spendora
//

import SwiftUI
import SwiftData

@main
struct SpendoraApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
            } else {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            }
        }
        .modelContainer(for: Subscription.self)
    }
}

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Subscriptions", systemImage: "list.bullet")
                }
                .tag(0)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(1)
        }
    }
}

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
