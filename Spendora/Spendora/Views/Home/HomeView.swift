//
//  HomeView.swift
//  Spendora
//

import SwiftUI
import SwiftData
import UIKit

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Subscription.nextBillingDate, order: .forward) private var subscriptions: [Subscription]
    
    @State private var showingAddSheet = false
    @State private var selectedSubscription: Subscription?
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    @State private var searchText = ""
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    var filteredSubscriptions: [Subscription] {
        if searchText.isEmpty {
            return subscriptions
        } else {
            return subscriptions.filter {
                $0.displayName.localizedCaseInsensitiveContains(searchText) ||
                $0.category.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var totalMonthly: Double {
        filteredSubscriptions.reduce(0) { $0 + $1.monthlyCost }
    }
    
    var totalYearly: Double {
        filteredSubscriptions.reduce(0) { $0 + $1.yearlyCost }
    }
    
    var nextSubscription: Subscription? {
        filteredSubscriptions
            .filter { $0.nextBillingDate > Date() }
            .sorted { $0.nextBillingDate < $1.nextBillingDate }
            .first
    }
    
    var averageMonthlyCost: Double {
        guard !filteredSubscriptions.isEmpty else { return 0 }
        return totalMonthly / Double(filteredSubscriptions.count)
    }
    
    var highestCostSubscription: Subscription? {
        filteredSubscriptions.max { $0.monthlyCost < $1.monthlyCost }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Total Spending Card
                    TotalSpendingCard(
                        monthlyTotal: totalMonthly,
                        yearlyTotal: totalYearly
                    )
                    
                    // Analytics Card
                    if !filteredSubscriptions.isEmpty {
                        AnalyticsCard(
                            averageCost: averageMonthlyCost,
                            highestSubscription: highestCostSubscription
                        )
                    }
                    
                    // Next Charge Card
                    if let next = nextSubscription {
                        NextChargeCard(subscription: next)
                    }
                    
                    // Subscriptions Header
                    HStack {
                        Text("Your Subscriptions")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text("\(filteredSubscriptions.count) active")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Search Bar
                    SearchBar(text: $searchText)
                        .padding(.bottom, 8)
                    
                    // Subscriptions List
                    if filteredSubscriptions.isEmpty {
                        if searchText.isEmpty {
                            EmptyStateView()
                        } else {
                            NoSearchResultsView(searchText: searchText)
                        }
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
                        .padding(.horizontal)
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
            
            let fetchDescriptor = FetchDescriptor<Subscription>()
            let allSubscriptions = try? modelContext.fetch(fetchDescriptor)
            WidgetSyncService.updateSharedData(subscriptions: allSubscriptions ?? [])
            
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
                    
                    Text(monthlyTotal, format: .currency(code: "USD"))
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
                    
                    Text(yearlyTotal, format: .currency(code: "USD"))
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
                    
                    Text("You're spending \(monthlyTotal, format: .currency(code: "USD"))/month on subscriptions")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .padding(.horizontal)
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
                    Text(averageCost, format: .currency(code: "USD"))
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
                        Text(highest.monthlyCost, format: .currency(code: "USD"))
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .padding(.horizontal)
        .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
    }
}

// MARK: - No Search Results View
struct NoSearchResultsView: View {
    let searchText: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text("No results for \"\(searchText)\"")
                .font(.headline)
            Text("Try a different search term")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}
