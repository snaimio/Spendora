//
//  HomeView.swift
//

/**
 * Main/Core Functions & Purpose:
 * HomeView main dashboard view of the Spendora app.
 * Displays overall monthly/yearly spend totals, upcoming charge cards, search & sort controls,
 * subscription cards list, quick actions toolbar menu (Yearly Report, Challenges, Savings Score, AI Insights),
 * and user profile avatar header.
 */

import SwiftUI
import SwiftData
import WidgetKit


// MARK: - HomeView

/**
 `HomeView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for homeview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `HomeView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct HomeView: View {

    // MARK: - Properties

    @Environment(\.modelContext) var modelContext
    @Query var subscriptions: [Subscription]
    
    // UI state management
    @State var showingAddSheet = false
    @State var selectedSubscription: Subscription?
    @State var searchText = ""
    @State var refreshID = 0
    @State var sortOption: SortOption = .alphabetical
    @State var animateHeader = false
    
    @ObservedObject var profileManager = UserProfileManager.shared
    @State var showingProfileSheet = false
    
    @State var showingYearlyReport = false
    @State var showingChallenges = false
    @State var showingSavingsScore = false
    @State var showingAIInsights = false
    @State var showingNotificationCenter = false
    @ObservedObject var notificationCenterService = NotificationCenterService.shared
    
    let generator = UIImpactFeedbackGenerator(style: .medium)
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Single Integrated Hero Summary Card (Monthly Spend, Stats & Next Charge)
                        HeroCardView(
                            totalMonthly: totalMonthly,
                            totalYearly: totalYearly,
                            count: filteredSubscriptions.count,
                            subscriptionCount: subscriptionCount,
                            nextSubscription: nextSubscription
                        )
                        .opacity(animateHeader ? 1 : 0)
                        .offset(y: animateHeader ? 0 : 12)
                        
                        if !subscriptions.isEmpty {
                            // Search Bar & Sort Chips
                            VStack(spacing: 12) {
                                SearchBarView(searchText: $searchText)
                                SortChipsView(sortOption: $sortOption)
                            }
                            
                            // Subscriptions List Header
                            HStack {
                                Text("Subscriptions")
                                    .font(.system(.headline, design: .rounded))
                                    .foregroundColor(.textPrimary)
                                Spacer()
                                Text("\(filteredSubscriptions.count) Active")
                                    .font(.system(.caption, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(.textSecondary)
                            }
                            .padding(.horizontal, 4)
                            .padding(.top, 4)
                            
                            // Subscriptions Cards List
                            VStack(spacing: 12) {
                                ForEach(filteredSubscriptions) { subscription in
                                    SubscriptionCardView(subscription: subscription)
                                        .onTapGesture {
                                            generator.impactOccurred()
                                            selectedSubscription = subscription
                                        }
                                }
                            }
                        } else {
                            EmptyStateView()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }
                .id(refreshID)
                .onAppear {
                    updateWidgetData()
                    NotificationCenterService.shared.syncWithSystemNotifications()
                    withAnimation(.easeOut(duration: 0.6)) {
                        animateHeader = true
                    }
                }
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        generator.impactOccurred()
                        showingNotificationCenter = true
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.brandPrimary)
                            
                            if notificationCenterService.unreadCount > 0 {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 2, y: -2)
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 12) {
                        Button {
                            generator.impactOccurred()
                            showingAddSheet = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                                .foregroundColor(.brandPrimary)
                        }
                        
                        Menu {
                            Button {
                                showingYearlyReport = true
                            } label: {
                                Label("Yearly Report", systemImage: "calendar")
                            }
                            
                            Button {
                                showingChallenges = true
                            } label: {
                                Label("Challenges", systemImage: "trophy")
                            }
                            
                            Button {
                                showingSavingsScore = true
                            } label: {
                                Label("Savings Score", systemImage: "star.circle.fill")
                            }
                            
                            Button {
                                showingAIInsights = true
                            } label: {
                                Label("AI Insights", systemImage: "brain.head.profile")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.title3)
                                .foregroundColor(.brandSecondary)
                        }
                        
                        // Profile Avatar Button
                        Button {
                            generator.impactOccurred()
                            showingProfileSheet = true
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(hex: profileManager.profile.avatarColorHex),
                                                Color(hex: profileManager.profile.avatarColorHex).opacity(0.7)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 30, height: 30)
                                
                                Text(profileManager.profile.initials)
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .background(homeSheetModifiers)
            .onChange(of: subscriptions.count) { _, _ in
                updateWidgetData()
            }
        }
    }
}
