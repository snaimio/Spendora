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
                            count: activeSubscriptions.count,
                            subscriptionCount: activeSubscriptions.count,
                            nextSubscription: nextSubscription
                        )
                        .opacity(animateHeader ? 1 : 0)
                        .offset(y: animateHeader ? 0 : 8)
                        
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
                    .padding(.bottom, 32)
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
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(SpendoraTheme.Colors.coral)
                            
                            if notificationCenterService.unreadCount > 0 {
                                Circle()
                                    .fill(SpendoraTheme.Colors.danger)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 2, y: -2)
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 10) {
                        // Coral Gradient + Button Pill
                        Button {
                            generator.impactOccurred()
                            showingAddSheet = true
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "plus")
                                    .font(.system(size: 13, weight: .bold))
                                Text("Add")
                                    .font(.system(size: 13, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(SpendoraTheme.Colors.coralGradient)
                            .clipShape(Capsule())
                            .shadow(color: SpendoraTheme.Colors.coral.opacity(0.3), radius: 4, y: 2)
                        }
                        
                        Menu {
                            Button {
                                DispatchQueue.main.async {
                                    showingYearlyReport = true
                                }
                            } label: {
                                Label("Yearly Report", systemImage: "calendar")
                            }
                            
                            Button {
                                DispatchQueue.main.async {
                                    showingChallenges = true
                                }
                            } label: {
                                Label("Challenges", systemImage: "trophy")
                            }
                            
                            Button {
                                DispatchQueue.main.async {
                                    showingSavingsScore = true
                                }
                            } label: {
                                Label("Savings Score", systemImage: "star.circle.fill")
                            }
                            
                            Button {
                                DispatchQueue.main.async {
                                    showingAIInsights = true
                                }
                            } label: {
                                Label("AI Insights", systemImage: "brain.head.profile")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(SpendoraTheme.Colors.coralWarm)
                        }
                        
                        // Profile Avatar Button (Warm Coral)
                        Button {
                            generator.impactOccurred()
                            showingProfileSheet = true
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(SpendoraTheme.Colors.coralGradient)
                                    .frame(width: 32, height: 32)
                                
                                Text(profileManager.profile.initials)
                                    .font(.system(size: 12, weight: .bold))
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
                        .foregroundColor(Color(hex: "#00D4AA"))
                        .font(.headline)
                    Text("Active Subscriptions")
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.textPrimary)
                }
                Spacer()
                Text("\(activeSubscriptions.count) Active")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#00D4AA"))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color(hex: "#00D4AA").opacity(0.16))
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
                                .foregroundColor(.brandPrimary)
                                .font(.headline)
                            Text("Active Subscriptions")
                                .font(.system(.headline, design: .rounded))
                                .foregroundColor(.textPrimary)
                        }
                        Spacer()
                        Text("\(activeSubscriptions.count) Active")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(.brandPrimary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.brandPrimary.opacity(0.14))
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
                                .foregroundColor(.brandSecondary)
                                .font(.headline)
                            Text("Cancelled & Paused")
                                .font(.system(.headline, design: .rounded))
                                .foregroundColor(.textPrimary)
                        }
                        Spacer()
                        Text("\(cancelledSubscriptions.count) Inactive")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(.brandSecondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.brandSecondary.opacity(0.14))
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
