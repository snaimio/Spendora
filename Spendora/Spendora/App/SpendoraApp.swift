//
//  SpendoraApp.swift
//

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

// MARK: - SpendoraApp

/**
 `SpendoraApp` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for spendoraapp handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `SpendoraApp` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct SpendoraApp: App {

    // MARK: - Properties

    // Persistent flag checking if the user completed initial onboarding
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {  // body property
        WindowGroup {
            // Show onboarding on first launch; otherwise load the main tab bar UI
            Group {
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
            .preferredColorScheme(isDarkMode ? .dark : nil)
        }
    }
    
    // Syncs fallback baseline data to shared App Group for iOS Home Screen Widgets

    /**
     Executes `sendWidgetData` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    func sendWidgetData() {
        let defaults = UserDefaults(suiteName: "group.com.trios2026sn.Spendora")
        defaults?.set(0.0, forKey: "totalMonthly")
        defaults?.set("None", forKey: "nextSubName")
        defaults?.set(Date().timeIntervalSince1970, forKey: "nextSubDate")
        WidgetCenter.shared.reloadAllTimelines()
    }
}

// Main tab bar container holding Dashboard, Subscriptions List, Calendar, and Settings

// MARK: - MainTabView

/**
 `MainTabView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for maintabview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `MainTabView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct MainTabView: View {

    // MARK: - Properties

    @State private var selectedTab = 0
    @Query private var subscriptions: [Subscription]
    

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.shadowColor = UIColor(hex: "#F0EBE3")
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hex: "#A0A0B0")
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hex: "#FF6B6B")
        ]
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(hex: "#A0A0B0")
        
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(hex: "#FF6B6B")
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    /// Main SwiftUI layout body property.
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
        .tint(SpendoraTheme.Colors.coral)
    }
}
