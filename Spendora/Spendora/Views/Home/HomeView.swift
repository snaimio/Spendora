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
    @State private var showConfetti = false
    @State private var showingShareSheet = false
    @State private var shareImage: UIImage?
    @State private var refreshID = 0
    @State private var forceRefresh = false
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    var sortedSubscriptions: [Subscription] {
        subscriptions.sorted { $0.nextBillingDate < $1.nextBillingDate }
    }
    
    var filteredSubscriptions: [Subscription] {
        if searchText.isEmpty { return sortedSubscriptions }
        return sortedSubscriptions.filter {
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
    
    var topCategory: String {
        let grouped = Dictionary(grouping: filteredSubscriptions) { $0.category }
        let totals = grouped.map { ($0.key, $0.value.reduce(0) { $0 + $1.monthlyCost }) }
        return totals.max { $0.1 < $1.1 }?.0 ?? "None"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedGradientBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Hero Section
                        VStack(spacing: 12) {
                            Text("MONTHLY SPEND")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                                .tracking(2)
                            
                            AnimatedNumber(value: totalMonthly)
                                .font(.system(size: 56, weight: .bold))
                                .foregroundStyle(Color.brandPrimary)
                            
                            if totalMonthly > 0 {
                                Text("across \(filteredSubscriptions.count) subscriptions")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.top, 20)
                        
                        // Quick Stats Row
                        if !filteredSubscriptions.isEmpty {
                            HStack(spacing: 16) {
                                QuickStatCard(
                                    title: "Yearly",
                                    value: totalYearly,
                                    icon: "calendar",
                                    color: Color.brandSecondary
                                )
                                
                                QuickStatCard(
                                    title: "Average",
                                    value: filteredSubscriptions.isEmpty ? 0 : totalMonthly / Double(filteredSubscriptions.count),
                                    icon: "chart.line.uptrend.xyaxis",
                                    color: Color.brandAccent
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Charts
                        if !filteredSubscriptions.isEmpty {
                            SpendingChartView(subscriptions: filteredSubscriptions)
                                .padding(.horizontal, 20)
                        }
                        
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                            TextField("Search subscriptions...", text: $searchText)
                                .textFieldStyle(.plain)
                        }
                        .padding(12)
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                        
                        // Subscriptions List
                        if filteredSubscriptions.isEmpty {
                            DelightfulEmptyState()
                                .padding(.horizontal, 20)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredSubscriptions) { subscription in
                                    Button {
                                        print("🟡 TAPPED subscription: \(subscription.displayName)")
                                        generator.impactOccurred()
                                        selectedSubscription = subscription
                                    } label: {
                                        SubscriptionCard(subscription: subscription)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.vertical, 20)
                }
                .id(refreshID)
                .id(forceRefresh)
                .onAppear {
                    print("📊 HomeView appeared, subscriptions count: \(subscriptions.count)")
                    updateWidgetData()
                }
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("SubscriptionAdded"))) { _ in
                    forceRefresh.toggle()
                    refreshID += 1
                    updateWidgetData()
                }
            }
            .navigationTitle("Spendora")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            generator.impactOccurred()
                            showingAddSheet = true
                        } label: {
                            Label("Add Subscription", systemImage: "plus")
                        }
                        
                        if !filteredSubscriptions.isEmpty {
                            Button {
                                generator.impactOccurred()
                                generateAndShareReport()
                            } label: {
                                Label("Share Spending Report", systemImage: "square.and.arrow.up")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Color.brandPrimary)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddSubscriptionView()
                    .onDisappear {
                        refreshID += 1
                        forceRefresh.toggle()
                        updateWidgetData()
                    }
            }
            .sheet(item: $selectedSubscription) { subscription in
                SubscriptionDetailView(subscription: subscription)
                    .onDisappear {
                        updateWidgetData()
                    }
            }
            .sheet(isPresented: $showingShareSheet) {
                if let image = shareImage {
                    ShareSheet(items: [image])
                }
            }
            .overlay {
                if showConfetti {
                    ConfettiView {
                        showConfetti = false
                    }
                }
            }
        }
    }
    
    // MARK: - Widget Data Sync
    private func updateWidgetData() {
        let total = subscriptions.reduce(0) { $0 + $1.monthlyCost }
        let next = subscriptions.sorted { $0.nextBillingDate < $1.nextBillingDate }.first
        
        let defaults = UserDefaults(suiteName: "group.com.trios2026sn.Spendora")
        defaults?.set(total, forKey: "totalSpending")
        defaults?.set(next?.displayName ?? "None", forKey: "nextSubscription")
        defaults?.synchronize()
        
        WidgetCenter.shared.reloadAllTimelines()
        print("🔄 Widget data updated - Total: \(total), Next: \(next?.displayName ?? "None")")
    }
    
    private func generateAndShareReport() {
        let renderer = ImageRenderer(content: ShareableReportCard(
            totalMonthly: totalMonthly,
            totalYearly: totalYearly,
            subscriptionCount: filteredSubscriptions.count,
            topCategory: topCategory,
            topCategoryAmount: getTopCategoryAmount()
        ))
        
        if let image = renderer.uiImage {
            shareImage = image
            showingShareSheet = true
        }
    }
    
    private func getTopCategoryAmount() -> Double {
        let grouped = Dictionary(grouping: filteredSubscriptions) { $0.category }
        let totals = grouped.map { ($0.key, $0.value.reduce(0) { $0 + $1.monthlyCost }) }
        return totals.max { $0.1 < $1.1 }?.1 ?? 0
    }
}
