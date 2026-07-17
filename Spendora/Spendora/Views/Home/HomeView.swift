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
    
    // MARK: - Report Navigation
    @State private var showingYearlyReport = false
    @State private var showingChallenges = false
    @State private var showingSavingsScore = false
    @State private var showingAIInsights = false
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - Sorted Subscriptions
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
    
    // MARK: - Filtered Subscriptions
    var filteredSubscriptions: [Subscription] {
        if searchText.isEmpty { return sortedSubscriptions }
        return sortedSubscriptions.filter {
            $0.displayName.localizedCaseInsensitiveContains(searchText) ||
            $0.effectiveCategory.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    // MARK: - Totals
    var totalMonthly: Double {
        filteredSubscriptions.reduce(0) { $0 + $1.monthlyCost }
    }
    
    var totalYearly: Double {
        filteredSubscriptions.reduce(0) { $0 + $1.yearlyCost }
    }
    
    // MARK: - Next Subscription
    var nextSubscription: Subscription? {
        subscriptions
            .filter { !$0.isOverdue }
            .sorted { $0.nextBillingDate < $1.nextBillingDate }
            .first
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Hero Section
                        HeroHeaderView(
                            totalMonthly: totalMonthly,
                            totalYearly: totalYearly,
                            count: filteredSubscriptions.count
                        )
                        
                        // Next Charge Card
                        if let next = nextSubscription {
                            NextChargeCard(subscription: next)
                        }
                        
                        // Quick Stats (uses shared StatCard component)
                        if !filteredSubscriptions.isEmpty {
                            QuickStatsView(
                                count: filteredSubscriptions.count,
                                totalMonthly: totalMonthly,
                                totalYearly: totalYearly
                            )
                        }
                        
                        // Flagged Subscriptions
                        let flagged = subscriptions.filter {
                            $0.usageRating <= 2 && $0.monthlyCost > 5
                        }
                        if !flagged.isEmpty {
                            FlaggedSubscriptionsView(subscriptions: flagged)
                        }
                        
                        // Search & Sort
                        SearchSortView(
                            searchText: $searchText,
                            sortOption: $sortOption
                        )
                        
                        // Subscriptions List
                        if filteredSubscriptions.isEmpty {
                            PremiumEmptyStateView()
                        } else {
                            VStack(spacing: 12) {
                                ForEach(filteredSubscriptions) { subscription in
                                    SubscriptionCard(subscription: subscription)
                                        .onTapGesture {
                                            generator.impactOccurred()
                                            selectedSubscription = subscription
                                        }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
                .id(refreshID)
                .onAppear {
                    updateWidgetData()
                }
                
                // Floating Add Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            generator.impactOccurred()
                            showingAddSheet = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.brandPrimary)
                                .clipShape(Circle())
                                .shadow(color: Color.brandPrimary.opacity(0.4), radius: 8)
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
                    Menu {
                        Button {
                            showingAddSheet = true
                        } label: {
                            Label("Add Subscription", systemImage: "plus")
                        }
                        
                        Divider()
                        
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
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.title2)
                            .foregroundColor(.brandPrimary)
                    }
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
    
    // MARK: - Update Widget
    func updateWidgetData() {
        let total = subscriptions.reduce(0) { $0 + $1.monthlyCost }
        let next = subscriptions
            .filter { !$0.isOverdue }
            .sorted { $0.nextBillingDate < $1.nextBillingDate }
            .first
        
        guard let defaults = UserDefaults(suiteName: "group.com.spendora.app") else {
            return
        }
        
        defaults.set(total, forKey: "totalMonthly")
        defaults.set(next?.displayName ?? "None", forKey: "nextSubName")
        defaults.set(next?.nextBillingDate.timeIntervalSince1970 ?? 0, forKey: "nextSubDate")
        WidgetCenter.shared.reloadAllTimelines()
    }
}

// MARK: - Hero Header View
struct HeroHeaderView: View {
    let totalMonthly: Double
    let totalYearly: Double
    let count: Int
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "chart.pie.fill")
                    .font(.title3)
                    .foregroundColor(.brandPrimary)
                
                Text("Monthly Spend")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.textSecondary)
                    .tracking(2)
            }
            
            Text(String(format: "C$%.2f", totalMonthly))
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundColor(.textPrimary)
                .contentTransition(.numericText())
            
            if count > 0 {
                Text("\(count) active \(count == 1 ? "subscription" : "subscriptions")")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.04), radius: 8)
    }
}

// MARK: - Quick Stats View (Uses Shared StatCard)
struct QuickStatsView: View {
    let count: Int
    let totalMonthly: Double
    let totalYearly: Double
    
    var body: some View {
        HStack(spacing: 12) {
            StatCard(
                icon: "calendar",
                title: "Yearly",
                value: String(format: "C$%.2f", totalYearly),
                color: .brandPrimary
            )
            StatCard(
                icon: "chart.bar.fill",
                title: "Average",
                value: String(format: "C$%.2f", totalMonthly / Double(max(1, count))),
                color: .brandAccent
            )
        }
    }
}

// MARK: - Search & Sort View
struct SearchSortView: View {
    @Binding var searchText: String
    @Binding var sortOption: SortOption
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.textSecondary)
                TextField("Search subscriptions...", text: $searchText)
                    .font(.system(.body, design: .rounded))
            }
            .padding(12)
            .background(Color.cardBackground)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
            
            Picker("Sort by", selection: $sortOption) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

// MARK: - Flagged Subscriptions View
struct FlaggedSubscriptionsView: View {
    let subscriptions: [Subscription]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.brandAccent)
                Text("Consider Cancelling")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
            }
            
            ForEach(subscriptions) { sub in
                HStack {
                    Circle()
                        .fill(Color(hex: sub.colorHex ?? "#6C63FF"))
                        .frame(width: 10, height: 10)
                    
                    Text(sub.displayName)
                        .font(.subheadline)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    Text(String(format: "C$%.2f/mo", sub.monthlyCost))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.brandSecondary)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(Color.brandSecondary.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding()
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.03), radius: 4)
    }
}

// MARK: - Premium Empty State
struct PremiumEmptyStateView: View {
    @State private var bounce = false
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(Color.brandPrimary.opacity(0.08))
                    .frame(width: 120, height: 120)
                
                Circle()
                    .fill(Color.brandPrimary.opacity(0.15))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "creditcard.and.123")
                    .font(.system(size: 44))
                    .foregroundColor(.brandPrimary)
            }
            .scaleEffect(bounce ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: bounce)
            .onAppear { bounce = true }
            
            Text("No Subscriptions Yet")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Text("Tap the + button to start tracking your subscriptions")
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 60)
        .frame(maxWidth: .infinity)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.04), radius: 12, x: 0, y: 4)
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}
