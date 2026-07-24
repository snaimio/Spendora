//
//  HomeView.swift
//  Spendora
//

import SwiftUI
import SwiftData
import WidgetKit

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var subscriptions: [Subscription]
    
    @State private var showingAddSheet = false
    @State private var selectedSubscription: Subscription?
    @State private var searchText = ""
    @State private var refreshID = 0
    @State private var sortOption: SortOption = .alphabetical  // ✅ Changed to Alphabetical
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
    
    var subscriptionCount: Int {
        filteredSubscriptions.count
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
                    VStack(spacing: 16) {
                        // Hero Section
                        HeroCardView(
                            totalMonthly: totalMonthly,
                            totalYearly: totalYearly,
                            count: filteredSubscriptions.count,
                            subscriptionCount: subscriptionCount
                        )
                        .opacity(animateHeader ? 1 : 0)
                        .offset(y: animateHeader ? 0 : 20)
                        
                        if !subscriptions.isEmpty {
                            if let next = nextSubscription {
                                NextChargeCardView(subscription: next)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                            
                            // Stats Grid
                            HStack(spacing: 12) {
                                StatCardView(
                                    icon: "calendar",
                                    title: "Yearly",
                                    value: CurrencyManager.shared.format(totalYearly),
                                    colors: [Color(hex: "#FF6B6B"), Color(hex: "#FFE66D")]
                                )
                                
                                StatCardView(
                                    icon: "chart.bar.fill",
                                    title: "Average",
                                    value: CurrencyManager.shared.format(subscriptionCount > 0 ? totalMonthly / Double(subscriptionCount) : 0),
                                    colors: [Color(hex: "#4ECDC4"), Color(hex: "#45B7D1")]
                                )
                            }
                            
                            // Search Bar
                            SearchBarView(searchText: $searchText)
                            
                            // Sort Options
                            SortChipsView(sortOption: $sortOption)
                            
                            // Subscriptions List
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
                    .padding(.bottom, 20)
                }
                .id(refreshID)
                .onAppear {
                    updateWidgetData()
                    withAnimation(.easeOut(duration: 0.6)) {
                        animateHeader = true
                    }
                }
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        generator.impactOccurred()
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.brandPrimary)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
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
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.title2)
                            .foregroundColor(.brandSecondary)
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

// MARK: - Hero Card View
struct HeroCardView: View {
    let totalMonthly: Double
    let totalYearly: Double
    let count: Int
    let subscriptionCount: Int
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#FF6B6B"), Color(hex: "#FFE66D")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 4)
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
            
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("THIS MONTH")
                        .font(.system(.caption, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.textSecondary)
                        .tracking(1.5)
                    
                    Text(CurrencyManager.shared.format(totalMonthly))
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.textPrimary)
                        .contentTransition(.numericText())
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                    
                    if count > 0 {
                        Text("\(count) active \(count == 1 ? "subscription" : "subscriptions")")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.textSecondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                
                Spacer(minLength: 8)
                
                VStack(alignment: .trailing, spacing: 6) {
                    HeroPill(
                        icon: "calendar",
                        label: "Yearly",
                        value: CurrencyManager.shared.format(totalYearly),
                        color: Color(hex: "#4ECDC4")
                    )
                    
                    HeroPill(
                        icon: "chart.line.uptrend.xyaxis",
                        label: "Avg",
                        value: CurrencyManager.shared.format(subscriptionCount > 0 ? totalMonthly / Double(subscriptionCount) : 0),
                        color: Color(hex: "#A29BFE")
                    )
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
        }
        .background(Color.cardBackground)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.06), radius: 15, x: 0, y: 4)
    }
}

struct HeroPill: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundColor(color)
            Text(label)
                .font(.system(.caption2, design: .rounded))
                .foregroundColor(.textSecondary)
            Text(value)
                .font(.system(.caption, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.04), radius: 4)
        )
    }
}

// MARK: - Next Charge Card
struct NextChargeCardView: View {
    let subscription: Subscription
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#FF6B6B"), Color(hex: "#FFE66D")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                
                Image(systemName: "clock.fill")
                    .font(.title3)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text("Next Charge")
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.textSecondary)
                    .tracking(1)
                
                Text(subscription.displayName)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                HStack(spacing: 4) {
                    Text(CurrencyManager.shared.format(subscription.monthlyCost))
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.brandPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    Text("•")
                        .foregroundColor(.textSecondary)
                    
                    Text(subscription.formattedNextBillingDate)
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.textSecondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            Spacer(minLength: 4)
            
            let days = subscription.daysUntilBilling
            if days >= 0 && days <= 7 {
                if days <= 1 {
                    Text(days == 0 ? "Today" : "\(days)d")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "#FF6B6B"), Color(hex: "#FF9A9E")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                } else {
                    Text("\(days)d")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "#FFE66D"), Color(hex: "#F7DC6F")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
        )
    }
}

// MARK: - Stat Card
struct StatCardView: View {
    let icon: String
    let title: String
    let value: String
    let colors: [Color]
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: colors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 32, height: 32)
                
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(.caption2, design: .rounded))
                    .foregroundColor(.textSecondary)
                
                Text(value)
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            
            Spacer(minLength: 4)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
        )
    }
}

// MARK: - Search Bar
struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.textSecondary)
                .font(.subheadline)
            
            TextField("Search subscriptions...", text: $searchText)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.textPrimary)
                .autocorrectionDisabled()
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.textSecondary)
                        .font(.subheadline)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        )
    }
}

// MARK: - Sort Chips
struct SortChipsView: View {
    @Binding var sortOption: SortOption
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            sortOption = option
                        }
                    } label: {
                        Text(option.rawValue)
                            .font(.system(.caption, design: .rounded))
                            .fontWeight(sortOption == option ? .semibold : .regular)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(sortOption == option ?
                                        LinearGradient(
                                            colors: [Color(hex: "#FF6B6B"), Color(hex: "#FFE66D")],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ) :
                                        LinearGradient(
                                            colors: [Color(.secondarySystemBackground), Color(.secondarySystemBackground)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .foregroundColor(sortOption == option ? .white : .textSecondary)
                    }
                }
            }
        }
    }
}

// MARK: - Subscription Card
struct SubscriptionCardView: View {
    let subscription: Subscription
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [categoryColor, categoryColor.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                
                Image(systemName: categoryIcon)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(subscription.displayName)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    if subscription.isUpcoming {
                        Text("Soon")
                            .font(.system(size: 7, weight: .bold, design: .rounded))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(hex: "#FFE66D").opacity(0.2))
                            .foregroundColor(Color(hex: "#FFE66D"))
                            .cornerRadius(6)
                    }
                    
                    if subscription.isTrial && !subscription.trialConvertedToPaid {
                        Text("Trial")
                            .font(.system(size: 7, weight: .bold, design: .rounded))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(hex: "#FF6B6B").opacity(0.15))
                            .foregroundColor(Color(hex: "#FF6B6B"))
                            .cornerRadius(6)
                    }
                }
                
                HStack(spacing: 4) {
                    Text(CurrencyManager.shared.format(subscription.monthlyCost))
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.brandPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    Text("/month")
                        .font(.system(size: 10, weight: .regular, design: .rounded))
                        .foregroundColor(.textSecondary)
                    
                    if subscription.isYearly {
                        Text("• Yearly")
                            .font(.system(size: 9, weight: .regular, design: .rounded))
                            .foregroundColor(.textSecondary)
                    }
                }
                
                HStack(spacing: 3) {
                    Image(systemName: "calendar")
                        .font(.system(size: 7))
                        .foregroundColor(.textSecondary)
                    
                    Text("Next: \(subscription.formattedNextBillingDate)")
                        .font(.system(size: 9, weight: .regular, design: .rounded))
                        .foregroundColor(.textSecondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            Spacer(minLength: 4)
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.textSecondary.opacity(0.3))
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
        )
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

// MARK: - Empty State
struct EmptyStateView: View {
    @State private var pulse = false
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#FF6B6B").opacity(0.1), Color(hex: "#FFE66D").opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .scaleEffect(pulse ? 1.05 : 0.95)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: pulse)
                
                Image(systemName: "creditcard.and.123")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(.brandPrimary)
            }
            
            VStack(spacing: 8) {
                Text("No Subscriptions Yet")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)
                
                Text("Start tracking your subscriptions\nin just a few taps")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
        .onAppear {
            pulse = true
        }
    }
}
