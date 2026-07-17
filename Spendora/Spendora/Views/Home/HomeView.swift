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
    
    // MARK: - Report Navigation
    @State private var showingYearlyReport = false
    @State private var showingChallenges = false
    @State private var showingSavingsScore = false
    @State private var showingAIInsights = false
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - Computed Properties
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
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Premium Hero Section
                        PremiumHeroHeaderView(
                            totalMonthly: totalMonthly,
                            totalYearly: totalYearly,
                            count: filteredSubscriptions.count
                        )
                        .opacity(animateHeader ? 1 : 0)
                        .offset(y: animateHeader ? 0 : 20)
                        
                        if !subscriptions.isEmpty {
                            // Next Charge Card (Premium)
                            if let next = nextSubscription {
                                PremiumNextChargeCard(subscription: next)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                            
                            // Quick Stats (Premium) - Uses QuickStatsView
                            QuickStatsView(
                                count: filteredSubscriptions.count,
                                totalMonthly: totalMonthly,
                                totalYearly: totalYearly
                            )
                            
                            // Flagged Subscriptions
                            let flagged = subscriptions.filter {
                                $0.usageRating <= 2 && $0.monthlyCost > 5
                            }
                            if !flagged.isEmpty {
                                PremiumFlaggedSubscriptionsView(subscriptions: flagged)
                            }
                            
                            // Search & Sort
                            PremiumSearchSortView(
                                searchText: $searchText,
                                sortOption: $sortOption
                            )
                            
                            // Subscriptions List
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
                            // Premium Empty State
                            PremiumEmptyStateView()
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
                
                // Floating Add Button (Premium)
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
    
    // MARK: - Update Widget
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

// MARK: - Premium Hero Header View
struct PremiumHeroHeaderView: View {
    let totalMonthly: Double
    let totalYearly: Double
    let count: Int
    
    var body: some View {
        VStack(spacing: 0) {
            // Top gradient bar
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.brandPrimary, .brandSecondary],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 4)
                .cornerRadius(2)
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            
            HStack(alignment: .top, spacing: 20) {
                // Left: Monthly spend
                VStack(alignment: .leading, spacing: 4) {
                    Text("THIS MONTH")
                        .font(.system(.caption, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .tracking(1.5)
                    
                    Text(CurrencyManager.shared.format(totalMonthly))
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .contentTransition(.numericText())
                    
                    if count > 0 {
                        Text("\(count) active \(count == 1 ? "subscription" : "subscriptions")")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Right: Mini stats
                VStack(alignment: .trailing, spacing: 8) {
                    PremiumStatPill(
                        icon: "calendar",
                        label: "Yearly",
                        value: CurrencyManager.shared.format(totalYearly)
                    )
                    
                    PremiumStatPill(
                        icon: "chart.line.uptrend.xyaxis",
                        label: "Avg",
                        value: CurrencyManager.shared.format(count > 0 ? totalMonthly / Double(count) : 0)
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .background(Color(.systemBackground))
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
        .padding(.horizontal, 4)
    }
}

struct PremiumStatPill: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundColor(.brandPrimary)
            Text(label)
                .font(.system(.caption2, design: .rounded))
                .foregroundColor(.secondary)
            Text(value)
                .font(.system(.caption, design: .rounded))
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

// MARK: - Premium Next Charge Card
struct PremiumNextChargeCard: View {
    let subscription: Subscription
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.brandPrimary.opacity(0.12), .brandSecondary.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                
                Image(systemName: "clock.fill")
                    .font(.title3)
                    .foregroundColor(.brandPrimary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Next Charge")
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .tracking(1)
                
                Text(subscription.displayName)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.primary)
                
                HStack(spacing: 6) {
                    Text(CurrencyManager.shared.format(subscription.monthlyCost))
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.bold)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text(subscription.formattedNextBillingDate)
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Days remaining badge
            let days = subscription.daysUntilBilling
            if days >= 0 && days <= 7 {
                BadgeView(
                    text: days == 0 ? "Today" : "\(days)d",
                    color: days <= 1 ? .red : .orange
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [.brandPrimary.opacity(0.2), .brandSecondary.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
}

// MARK: - Premium Flagged Subscriptions View
struct PremiumFlaggedSubscriptionsView: View {
    let subscriptions: [Subscription]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.brandAccent)
                
                Text("Consider Cancelling")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(subscriptions.count)")
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.brandAccent)
                    .cornerRadius(8)
            }
            
            ForEach(subscriptions.prefix(3)) { sub in
                HStack {
                    Circle()
                        .fill(Color(hex: sub.colorHex ?? "#6C63FF"))
                        .frame(width: 8, height: 8)
                    
                    Text(sub.displayName)
                        .font(.system(.subheadline, design: .rounded))
                    
                    Spacer()
                    
                    Text(CurrencyManager.shared.format(sub.monthlyCost) + "/mo")
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.brandSecondary)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(Color.brandSecondary.opacity(0.08))
                .cornerRadius(8)
            }
            
            if subscriptions.count > 3 {
                Text("+ \(subscriptions.count - 3) more")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 4)
    }
}

// MARK: - Premium Search & Sort View
struct PremiumSearchSortView: View {
    @Binding var searchText: String
    @Binding var sortOption: SortOption
    
    var body: some View {
        VStack(spacing: 12) {
            // Search Bar (Premium)
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                
                TextField("Search subscriptions...", text: $searchText)
                    .font(.system(.body, design: .rounded))
                    .autocorrectionDisabled()
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                }
            }
            .padding(14)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
            
            // Sort Picker (Premium)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        SortChip(
                            title: option.rawValue,
                            isSelected: sortOption == option
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                sortOption = option
                            }
                        }
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }
}

struct SortChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.system(.caption, design: .rounded))
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.brandPrimary : Color(.secondarySystemBackground))
                )
                .foregroundColor(isSelected ? .white : .secondary)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Premium Subscription Card
struct PremiumSubscriptionCard: View {
    let subscription: Subscription
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Premium Icon with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                categoryColor.opacity(0.15),
                                categoryColor.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 52, height: 52)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [categoryColor, categoryColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: categoryIcon)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(subscription.displayName)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                    
                    if subscription.isUpcoming {
                        PremiumBadge(text: "Soon", color: .orange)
                    }
                    
                    if subscription.isTrial && !subscription.trialConvertedToPaid {
                        PremiumBadge(text: "Trial", color: .purple)
                    }
                }
                
                HStack(spacing: 6) {
                    Text(CurrencyManager.shared.format(subscription.monthlyCost))
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                    
                    Text("/month")
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    if subscription.isYearly {
                        Text("• Yearly")
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    
                    Text("Next: \(subscription.formattedNextBillingDate)")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary.opacity(0.4))
                
                if subscription.isUpcoming {
                    Text("Due soon")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 2)
        )
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .onTapGesture {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
            withAnimation {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                }
            }
        }
    }
    
    private var categoryIcon: String {
        SubscriptionCategory(rawValue: subscription.category)?.icon ?? "tag.fill"
    }
    
    private var categoryColor: Color {
        switch subscription.category {
        case "Entertainment": return .categoryEntertainment
        case "Productivity": return .categoryProductivity
        case "Health & Fitness": return .categoryHealth
        case "Shopping": return .categoryShopping
        case "Food & Dining": return .categoryFood
        case "Education": return .categoryEducation
        default: return .categoryOther
        }
    }
}

// MARK: - Premium Badge
struct PremiumBadge: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 9, weight: .bold, design: .rounded))
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(8)
    }
}

// MARK: - Badge View (Used in NextChargeCard)
struct BadgeView: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .bold, design: .rounded))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(10)
    }
}

// MARK: - Premium Empty State
struct PremiumEmptyStateView: View {
    @State private var pulse = false
    @State private var rotate = false
    
    var body: some View {
        VStack(spacing: 28) {
            // Premium animated icon
            ZStack {
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.brandPrimary.opacity(0.3), .brandSecondary.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 140, height: 140)
                    .scaleEffect(pulse ? 1.05 : 0.95)
                    .opacity(pulse ? 0.5 : 0.8)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.brandPrimary.opacity(0.12), .brandSecondary.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 110, height: 110)
                
                Image(systemName: "creditcard.and.123")
                    .font(.system(size: 44, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.brandPrimary, .brandSecondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .rotationEffect(.degrees(rotate ? 5 : -5))
                    .offset(y: rotate ? -4 : 4)
            }
            
            VStack(spacing: 12) {
                Text("No Subscriptions Yet")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Start tracking your subscriptions\nin just a few taps")
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                pulse.toggle()
            }
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                rotate.toggle()
            }
        }
    }
}

// MARK: - Premium Floating Add Button
struct PremiumFloatingAddButton: View {
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            action()
        } label: {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.brandPrimary, .brandSecondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .shadow(color: .brandPrimary.opacity(0.4), radius: 12, x: 0, y: 4)
                
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onLongPressGesture(minimumDuration: 0.01) { pressing in
            isPressed = pressing
        } perform: { }
    }
}

// MARK: - Premium Toolbar Menu
struct PremiumToolbarMenu: View {
    let onAdd: () -> Void
    let onYearlyReport: () -> Void
    let onChallenges: () -> Void
    let onSavingsScore: () -> Void
    let onAIInsights: () -> Void
    
    var body: some View {
        Menu {
            Button {
                onAdd()
            } label: {
                Label("Add Subscription", systemImage: "plus")
            }
            
            Divider()
            
            Button {
                onYearlyReport()
            } label: {
                Label("Yearly Report", systemImage: "calendar")
            }
            
            Button {
                onChallenges()
            } label: {
                Label("Challenges", systemImage: "trophy")
            }
            
            Button {
                onSavingsScore()
            } label: {
                Label("Savings Score", systemImage: "star.circle.fill")
            }
            
            Button {
                onAIInsights()
            } label: {
                Label("AI Insights", systemImage: "brain.head.profile")
            }
        } label: {
            Image(systemName: "ellipsis.circle.fill")
                .font(.title2)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.brandPrimary, .brandSecondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
    }
}
