//
//  HomeView.swift
//  Spendora
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Subscription.nextBillingDate, order: .forward) private var subscriptions: [Subscription]
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    @State private var showingAddSheet = false
    @State private var selectedSubscription: Subscription?
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    @State private var searchText = ""

    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    private var sidePadding: CGFloat {
        horizontalSizeClass == .regular ? 32 : 0
    }

    var filteredSubscriptions: [Subscription] {
        if searchText.isEmpty {
            return subscriptions
        }
        return subscriptions.filter {
            $0.displayName.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
        }
    }

    var totalMonthly: Double {
        filteredSubscriptions.reduce(0) { $0 + $1.monthlyCost }
    }
    
    var totalYearly: Double {
        filteredSubscriptions.reduce(0) { $0 + $1.yearlyCost }
    }
    
    var averageMonthlyCost: Double {
        guard !filteredSubscriptions.isEmpty else { return 0 }
        return totalMonthly / Double(filteredSubscriptions.count)
    }
    
    var highestCostSubscription: Subscription? {
        filteredSubscriptions.max { $0.monthlyCost < $1.monthlyCost }
    }
    
    var nextSubscription: Subscription? {
        filteredSubscriptions
            .filter { $0.nextBillingDate > Date() }
            .sorted { $0.nextBillingDate < $1.nextBillingDate }
            .first
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Total Spending Card
                    TotalSpendingCard(monthlyTotal: totalMonthly, yearlyTotal: totalYearly)
                        .padding(.horizontal, sidePadding)

                    // MARK: - Analytics Card
                    if !filteredSubscriptions.isEmpty {
                        AnalyticsCard(
                            averageCost: averageMonthlyCost,
                            highestSubscription: highestCostSubscription
                        )
                        .padding(.horizontal, sidePadding)
                    }

                    // MARK: - Spending Chart
                    if !filteredSubscriptions.isEmpty {
                        SpendingChartView(subscriptions: filteredSubscriptions)
                            .padding(.horizontal, sidePadding)
                    }

                    // MARK: - AI Insights
                    if !filteredSubscriptions.isEmpty {
                        AIInsightsView(subscriptions: filteredSubscriptions)
                            .padding(.horizontal, sidePadding)
                    }

                    // MARK: - Next Charge Card
                    if let next = nextSubscription {
                        NextChargeCard(subscription: next)
                            .padding(.horizontal, sidePadding)
                    }

                    // MARK: - Subscriptions Header
                    HStack {
                        Text("Your Subscriptions")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(filteredSubscriptions.count) active")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, sidePadding)
                    .padding(.top, 8)

                    // MARK: - Search Bar
                    SearchBar(text: $searchText)
                        .padding(.horizontal, sidePadding)

                    // MARK: - Subscriptions List
                    if filteredSubscriptions.isEmpty {
                        EmptyStateView()
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredSubscriptions) { subscription in
                                SubscriptionCard(subscription: subscription)
                                    .onTapGesture {
                                        selectedSubscription = subscription
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            deleteSubscription(subscription)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                        Button {
                                            selectedSubscription = subscription
                                        } label: {
                                            Label("Details", systemImage: "info.circle")
                                        }
                                        .tint(.blue)
                                    }
                            }
                        }
                        .padding(.horizontal, sidePadding)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Spendora")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        generator.impactOccurred()
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddSubscriptionView()
            }
            .sheet(item: $selectedSubscription) { subscription in
                SubscriptionDetailView(subscription: subscription)
            }
            .alert("Error", isPresented: $showingErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func deleteSubscription(_ subscription: Subscription) {
        do {
            NotificationService.shared.cancel(for: subscription)
            modelContext.delete(subscription)
            try modelContext.save()
            generator.impactOccurred()
        } catch {
            errorMessage = "Failed to delete: \(error.localizedDescription)"
            showingErrorAlert = true
        }
    }
}

// MARK: - Total Spending Card
struct TotalSpendingCard: View {
    let monthlyTotal: Double
    let yearlyTotal: Double
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Monthly")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(CurrencyManager.shared.format(monthlyTotal))
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    .frame(height: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Yearly")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(CurrencyManager.shared.format(yearlyTotal))
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if monthlyTotal > 0 {
                Divider()
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text("You're spending \(CurrencyManager.shared.format(monthlyTotal))/month on subscriptions")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Analytics Card
struct AnalyticsCard: View {
    let averageCost: Double
    let highestSubscription: Subscription?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(.blue)
                Text("Insights")
                    .font(.headline)
            }
            Divider()
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Average Monthly")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(CurrencyManager.shared.format(averageCost))
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                Spacer()
                if let highest = highestSubscription {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Highest")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(highest.displayName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text(CurrencyManager.shared.format(highest.monthlyCost))
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
    }
}
