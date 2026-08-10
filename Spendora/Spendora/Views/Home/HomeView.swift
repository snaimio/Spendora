//
//  HomeView.swift
//  Spendora
//

import SwiftUI
import SwiftData
import WidgetKit

// MARK: - HomeView (Apple Native HIG Dashboard)

struct HomeView: View {

    // MARK: - Properties

    @Environment(\.modelContext) var modelContext
    @Query var subscriptions: [Subscription]
    
    @State var searchText = ""
    @State var showingAddSheet = false
    @State var selectedSubscription: Subscription?
    @State var refreshID = UUID()
    
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
            ScrollView {
                VStack(spacing: SpendoraTheme.sectionSpacing) {
                    // A. Hero Spend Card (Monthly Spend, Gauge & Next Charge)
                    HeroCardView(
                        totalMonthly: totalMonthly,
                        totalYearly: totalYearly,
                        count: activeSubscriptions.count,
                        subscriptionCount: activeSubscriptions.count,
                        nextSubscription: nextSubscription
                    )
                    
                    if !subscriptions.isEmpty {
                        // Segmented Filter & Sort Controls
                        VStack(spacing: 12) {
                            Picker("Filter", selection: $statusFilter) {
                                Text("Active (\(activeSubscriptions.count))").tag(SubscriptionStatusFilter.active)
                                Text("Cancelled (\(cancelledSubscriptions.count))").tag(SubscriptionStatusFilter.cancelled)
                                Text("All (\(filteredSubscriptions.count))").tag(SubscriptionStatusFilter.all)
                            }
                            .pickerStyle(.segmented)
                            
                            SortChipsView(sortOption: $sortOption)
                        }
                        
                        // C. Subscription List (LazyVStack(spacing: 8))
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
                .padding(.horizontal, SpendoraTheme.cardPadding)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .navigationTitle("Spendora")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        generator.impactOccurred()
                        showingNotificationCenter = true
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bell")
                                .font(.system(size: 17, weight: .semibold))
                            
                            if notificationCenterService.unreadCount > 0 {
                                Circle()
                                    .fill(Color(.systemRed))
                                    .frame(width: 8, height: 8)
                                    .offset(x: 2, y: -2)
                            }
                        }
                    }
                    .tint(SpendoraTheme.accent)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 12) {
                        Button {
                            generator.impactOccurred()
                            showingAddSheet = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 17, weight: .bold))
                        }
                        .tint(SpendoraTheme.accent)
                        
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
                                Label("Savings Score", systemImage: "star")
                            }
                            
                            Button {
                                showingAIInsights = true
                            } label: {
                                Label("AI Insights", systemImage: "brain.head.profile")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.system(size: 17))
                        }
                        .tint(SpendoraTheme.accent)
                        
                        Button {
                            showingProfileSheet = true
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(SpendoraTheme.accentTint)
                                    .frame(width: 32, height: 32)
                                
                                Text(profileManager.profile.initials)
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(SpendoraTheme.accentText)
                            }
                        }
                    }
                }
            }
            .sheet(item: $selectedSubscription) { subscription in
                SubscriptionDetailView(subscription: subscription)
            }
            .sheet(isPresented: $showingAddSheet) {
                AddSubscriptionView()
            }
            .sheet(isPresented: $showingNotificationCenter) {
                NotificationCenterSheet()
            }
            .sheet(isPresented: $showingProfileSheet) {
                ProfileView()
            }
            .sheet(isPresented: $showingYearlyReport) {
                YearlyReportView(subscriptions: subscriptions)
            }
            .sheet(isPresented: $showingChallenges) {
                ChallengesView(subscriptions: subscriptions)
            }
            .sheet(isPresented: $showingSavingsScore) {
                SavingsScoreView(subscriptions: subscriptions)
            }
            .sheet(isPresented: $showingAIInsights) {
                AIInsightsView(subscriptions: subscriptions)
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: subscriptions.count)
        }
    }
    
    // MARK: - Section Builders (LazyVStack(spacing: 8))

    private var activeSubscriptionsSection: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Active Subscriptions")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(Color(.label))
                
                Spacer()
                
                Text("\(activeSubscriptions.count)")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(SpendoraTheme.accent)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(SpendoraTheme.accentTint)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 2)
            .padding(.bottom, 2)
            
            ForEach(activeSubscriptions) { subscription in
                SubscriptionCardView(subscription: subscription)
                    .onTapGesture {
                        generator.impactOccurred()
                        selectedSubscription = subscription
                    }
            }
        }
    }

    private var cancelledSubscriptionsSection: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Cancelled & Paused")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(Color(.label))
                
                Spacer()
                
                Text("\(cancelledSubscriptions.count)")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(Color(.secondaryLabel))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color(.tertiarySystemBackground))
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 2)
            .padding(.bottom, 2)
            
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

    private var allSubscriptionsSection: some View {
        VStack(spacing: 16) {
            if !activeSubscriptions.isEmpty {
                activeSubscriptionsSection
            }
            if !cancelledSubscriptions.isEmpty {
                cancelledSubscriptionsSection
            }
        }
    }
}
