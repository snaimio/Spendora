//
//  HomeView.swift
//  Spendora
//

import SwiftUI
import SwiftData
import WidgetKit

// MARK: - SubscriptionStatusFilter Enum

enum SubscriptionStatusFilter: String, CaseIterable, Identifiable {
    case active = "Active"
    case cancelled = "Cancelled"
    case all = "All"
    
    var id: String { rawValue }
}

// MARK: - HomeView

/**
 `HomeView` main executive dashboard adhering to Apple HIG Fintech Industry Standards:
 - Segmented Status Control (Active | Cancelled | All)
 - Machined Steel Spending Gauge Meter & Executive Totals
 - Clean Subscriptions Cards List with high-contrast distinct typography
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
    @State var statusFilter: SubscriptionStatusFilter = .active
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

    var body: some View {
        NavigationStack {
            ZStack {
                SpendoraBrandBackgroundView()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Single Integrated Hero Summary Card (Monthly Spend, Gauge & Next Charge)
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
                            // Search Bar, Sort Chips & Status Segmented Filter
                            VStack(spacing: 12) {
                                SearchBarView(searchText: $searchText)
                                
                                HStack {
                                    // Industry Standard Segmented Status Filter (Active | Cancelled | All)
                                    Picker("Filter", selection: $statusFilter) {
                                        Text("Active (\(activeSubscriptions.count))").tag(SubscriptionStatusFilter.active)
                                        Text("Cancelled (\(cancelledSubscriptions.count))").tag(SubscriptionStatusFilter.cancelled)
                                        Text("All (\(filteredSubscriptions.count))").tag(SubscriptionStatusFilter.all)
                                    }
                                    .pickerStyle(.segmented)
                                }
                                
                                SortChipsView(sortOption: $sortOption)
                            }
                            
                            // DISPLAY CONTENT BASED ON STATUS FILTER
                            switch statusFilter {
                            case .active:
                                activeSubscriptionsSection
                            case .cancelled:
                                cancelledSubscriptionsSection
                            case .all:
                                allSubscriptionsSection
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
    
    // MARK: - Active Subscriptions Section
    private var activeSubscriptionsSection: some View {
        VStack(spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.shield.fill")
                        .foregroundColor(Color(hex: "#10B981"))
                        .font(.headline)
                    Text("Active Subscriptions")
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.textPrimary)
                }
                Spacer()
                Text("\(activeSubscriptions.count) Active")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#047857"))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color(hex: "#10B981").opacity(0.16))
                    .cornerRadius(8)
            }
            .padding(.horizontal, 4)
            
            if activeSubscriptions.isEmpty {
                Text("No active subscriptions found.")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.textSecondary)
                    .padding(.vertical, 20)
            } else {
                ForEach(activeSubscriptions) { subscription in
                    SubscriptionCardView(subscription: subscription)
                        .onTapGesture {
                            generator.impactOccurred()
                            selectedSubscription = subscription
                        }
                }
            }
        }
    }
    
    // MARK: - Cancelled Subscriptions Section
    private var cancelledSubscriptionsSection: some View {
        VStack(spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(hex: "#F97316"))
                        .font(.headline)
                    Text("Cancelled & Paused")
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.textPrimary)
                }
                Spacer()
                Text("\(cancelledSubscriptions.count) Inactive")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#F97316"))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color(hex: "#F97316").opacity(0.14))
                    .cornerRadius(8)
            }
            .padding(.horizontal, 4)
            
            if cancelledSubscriptions.isEmpty {
                Text("No cancelled subscriptions found.")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.textSecondary)
                    .padding(.vertical, 20)
            } else {
                ForEach(cancelledSubscriptions) { subscription in
                    SubscriptionCardView(subscription: subscription)
                        .opacity(0.75)
                        .onTapGesture {
                            generator.impactOccurred()
                            selectedSubscription = subscription
                        }
                }
            }
        }
    }
    
    // MARK: - All Subscriptions Section
    private var allSubscriptionsSection: some View {
        VStack(spacing: 16) {
            if !activeSubscriptions.isEmpty {
                VStack(spacing: 10) {
                    HStack {
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.shield.fill")
                                .foregroundColor(Color(hex: "#10B981"))
                                .font(.headline)
                            Text("Active Subscriptions")
                                .font(.system(.headline, design: .rounded))
                                .foregroundColor(.textPrimary)
                        }
                        Spacer()
                        Text("\(activeSubscriptions.count) Active")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#10B981"))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color(hex: "#10B981").opacity(0.14))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 4)
                    
                    ForEach(activeSubscriptions) { subscription in
                        SubscriptionCardView(subscription: subscription)
                            .onTapGesture {
                                generator.impactOccurred()
                                selectedSubscription = subscription
                            }
                    }
                }
            }
            
            if !cancelledSubscriptions.isEmpty {
                VStack(spacing: 10) {
                    HStack {
                        HStack(spacing: 6) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color(hex: "#F97316"))
                                .font(.headline)
                            Text("Cancelled & Paused")
                                .font(.system(.headline, design: .rounded))
                                .foregroundColor(.textPrimary)
                        }
                        Spacer()
                        Text("\(cancelledSubscriptions.count) Inactive")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#F97316"))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color(hex: "#F97316").opacity(0.14))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 4)
                    .padding(.top, 8)
                    
                    ForEach(cancelledSubscriptions) { subscription in
                        SubscriptionCardView(subscription: subscription)
                            .opacity(0.75)
                            .onTapGesture {
                                generator.impactOccurred()
                                selectedSubscription = subscription
                            }
                    }
                }
            }
        }
    }
}
