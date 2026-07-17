//
//  HomeView.swift
//  Spendora
//

import SwiftUI
import SwiftData
import WidgetKit
import UIKit

enum SortOption: String, CaseIterable {
    case alphabetical = "Alphabetical"
    case cost = "Most Expensive"
    case cheapest = "Cheapest"
    case renewalDate = "Renewal Date"
    case category = "Category"
    case recentlyAdded = "Recently Added"
}

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var subscriptions: [Subscription]
    
    @State private var showingAddSheet = false
    @State private var selectedSubscription: Subscription?
    @State private var searchText = ""
    @State private var refreshID = 0
    @State private var sortOption: SortOption = .renewalDate
    @State private var animateHeader = false
    
    @State private var showingYearlyReport = false
    @State private var showingChallenges = false
    @State private var showingSavingsScore = false
    @State private var showingAIInsights = false
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    var sortedSubscriptions: [Subscription] {
        switch sortOption {
        case .alphabetical:
            return subscriptions.sorted { $0.displayName < $1.displayName }
        case .cost:
            return subscriptions.sorted { $0.monthlyCost > $1.monthlyCost }
        case .cheapest:
            return subscriptions.sorted { $0.monthlyCost < $1.monthlyCost }
        case .renewalDate:
            return subscriptions.sorted { $0.nextBillingDate < $1.nextBillingDate }
        case .category:
            return subscriptions.sorted { $0.effectiveCategory < $1.effectiveCategory }
        case .recentlyAdded:
            return subscriptions.sorted { $0.createdAt > $1.createdAt }
        }
    }
    
    var filteredSubscriptions: [Subscription] {
        if searchText.isEmpty { return sortedSubscriptions }
        return sortedSubscriptions.filter {
            $0.displayName.localizedCaseInsensitiveContains(searchText) ||
            $0.effectiveCategory.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var totalMonthly: Double {
        filteredSubscriptions.reduce(0) { $0 + $1.monthlyCost }
    }
    
    var totalYearly: Double {
        filteredSubscriptions.reduce(0) { $0 + $1.yearlyCost }
    }
    
    var nextSubscription: Subscription? {
        subscriptions
            .filter { !$0.isOverdue }
            .sorted { $0.nextBillingDate < $1.nextBillingDate }
            .first
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        HeroHeaderView(
                            totalMonthly: totalMonthly,
                            totalYearly: totalYearly,
                            count: filteredSubscriptions.count
                        )
                        .opacity(animateHeader ? 1 : 0)
                        .offset(y: animateHeader ? 0 : 20)
                        
                        if !subscriptions.isEmpty {
                            if let next = nextSubscription {
                                PremiumNextChargeCard(subscription: next)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                            
                            QuickStatsView(
                                count: filteredSubscriptions.count,
                                totalMonthly: totalMonthly,
                                totalYearly: totalYearly
                            )
                            
                            let flagged = subscriptions.filter {
                                $0.usageRating <= 2 && $0.monthlyCost > 5
                            }
                            if !flagged.isEmpty {
                                FlaggedSubscriptionsView(subscriptions: flagged)
                            }
                            
                            PremiumSearchSortView(
                                searchText: $searchText,
                                sortOption: $sortOption
                            )
                            
                            VStack(spacing: 12) {
                                ForEach(filteredSubscriptions) { subscription in
                                    PremiumSubscriptionCard(subscription: subscription)
                                        .onTapGesture {
                                            generator.impactOccurred()
                                            selectedSubscription = subscription
                                        }
                                }
                            }
                        } else {
                            DelightfulEmptyState()
                                .padding(.top, 40)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
                .id(refreshID)
                .onAppear {
                    updateWidgetData()
                    withAnimation(.easeOut(duration: 0.6)) {
                        animateHeader = true
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        PremiumFloatingAddButton {
                            generator.impactOccurred()
                            showingAddSheet = true
                        }
                        .padding(.trailing, 24)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    PremiumToolbarMenu(
                        onAdd: { showingAddSheet = true },
                        onYearlyReport: { showingYearlyReport = true },
                        onChallenges: { showingChallenges = true },
                        onSavingsScore: { showingSavingsScore = true },
                        onAIInsights: { showingAIInsights = true }
                    )
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                NavigationStack {
                    AddSubscriptionView()
                }
                .onDisappear {
                    refreshID += 1
                    updateWidgetData()
                }
            }
            .sheet(item: $selectedSubscription) { subscription in
                SubscriptionDetailView(subscription: subscription)
                    .onDisappear {
                        updateWidgetData()
                    }
            }
            .sheet(isPresented: $showingYearlyReport) {
                NavigationStack {
                    YearlyReportView(subscriptions: filteredSubscriptions)
                }
            }
            .sheet(isPresented: $showingChallenges) {
                NavigationStack {
                    ChallengesView(subscriptions: filteredSubscriptions)
                }
            }
            .sheet(isPresented: $showingSavingsScore) {
                NavigationStack {
                    SavingsScoreView(subscriptions: filteredSubscriptions)
                }
            }
            .sheet(isPresented: $showingAIInsights) {
                NavigationStack {
                    AIInsightsView(subscriptions: filteredSubscriptions)
                }
            }
            .onChange(of: subscriptions.count) { _, _ in
                updateWidgetData()
            }
        }
    }
    
    func updateWidgetData() {
        let total = subscriptions.reduce(0) { $0 + $1.monthlyCost }
        let next = subscriptions
            .filter { !$0.isOverdue }
            .sorted { $0.nextBillingDate < $1.nextBillingDate }
            .first
        
        guard let defaults = UserDefaults(suiteName: "group.com.trios2026sn.Spendora") else {
            return
        }
        
        defaults.set(total, forKey: "totalMonthly")
        defaults.set(next?.displayName ?? "None", forKey: "nextSubName")
        defaults.set(next?.nextBillingDate.timeIntervalSince1970 ?? 0, forKey: "nextSubDate")
        WidgetCenter.shared.reloadAllTimelines()
    }
}
