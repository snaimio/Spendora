//
//  HomeView.swift
//  Spendora
//

import SwiftUI
import SwiftData
import WidgetKit
import UniformTypeIdentifiers

enum SortOption: String, CaseIterable {
    case nextBilling = "Next Billing"
    case cost = "Cost"
    case name = "Name"
    case category = "Category"
    case recentlyAdded = "Recently Added"
    case custom = "Custom Order"
}

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
    @State private var sortOption: SortOption = .nextBilling
    @State private var customOrder: [String] = []
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    var sortedSubscriptions: [Subscription] {
        switch sortOption {
        case .nextBilling:
            return subscriptions.sorted { $0.nextBillingDate < $1.nextBillingDate }
        case .cost:
            return subscriptions.sorted { $0.monthlyCost > $1.monthlyCost }
        case .name:
            return subscriptions.sorted { $0.displayName < $1.displayName }
        case .category:
            return subscriptions.sorted { $0.category < $1.category }
        case .recentlyAdded:
            return subscriptions.sorted { $0.createdAt > $1.createdAt }
        case .custom:
            let ordered = customOrder.compactMap { id in subscriptions.first { $0.id.uuidString == id } }
            let unordered = subscriptions.filter { !customOrder.contains($0.id.uuidString) }
            return ordered + unordered
        }
    }
    
    var filteredSubscriptions: [Subscription] {
        if searchText.isEmpty { return sortedSubscriptions }
        return sortedSubscriptions.filter {
            $0.displayName.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText) ||
            ($0.tags?.contains { $0.localizedCaseInsensitiveContains(searchText) } ?? false)
        }
    }
    
    var totalMonthly: Double {
        filteredSubscriptions.reduce(0) { $0 + $1.monthlyCost }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(hex: "#EEF2FF"),
                        Color(hex: "#F5F3FF"),
                        Color(hex: "#FEF3C7")
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("💰 Monthly Spend")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                                .tracking(2)
                            
                            Text(CurrencyManager.shared.format(totalMonthly))
                                .font(.system(size: 48, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.primaryGradient)
                                .contentTransition(.numericText())
                            
                            if totalMonthly > 0 {
                                Text("\(filteredSubscriptions.count) active subscriptions")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 16)
                        
                        if !filteredSubscriptions.isEmpty {
                            HStack(spacing: 12) {
                                PremiumStatCard(title: "Yearly", value: CurrencyManager.shared.format(totalMonthly * 12), icon: "calendar", color: .brandPrimary)
                                PremiumStatCard(title: "Average", value: CurrencyManager.shared.format(totalMonthly / Double(max(1, filteredSubscriptions.count))), icon: "chart.line.uptrend.xyaxis", color: .brandAccent)
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        if !filteredSubscriptions.isEmpty {
                            SavingsScoreView(subscriptions: filteredSubscriptions)
                        }
                        
                        if !filteredSubscriptions.isEmpty {
                            SpendingChartView(subscriptions: filteredSubscriptions)
                        }
                        
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.secondary)
                                TextField("Search subscriptions...", text: $searchText)
                                    .font(.system(.body, design: .rounded))
                            }
                            .padding(12)
                            .background(Color(.systemBackground))
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
                            
                            Picker("Sort by", selection: $sortOption) {
                                ForEach(SortOption.allCases, id: \.self) { option in
                                    Text(option.rawValue).tag(option)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        .padding(.horizontal, 20)
                        
                        if filteredSubscriptions.isEmpty {
                            PremiumEmptyStateView()
                                .padding(.horizontal, 20)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(filteredSubscriptions) { subscription in
                                    SubscriptionCard(subscription: subscription)
                                        .onTapGesture {
                                            generator.impactOccurred()
                                            selectedSubscription = subscription
                                        }
                                        .onDrag {
                                            NSItemProvider(object: subscription.id.uuidString as NSString)
                                        }
                                        .onDrop(
                                            of: [UTType.text],
                                            delegate: SubscriptionDropDelegate(
                                                items: filteredSubscriptions,
                                                subscription: subscription,
                                                onMove: { fromIndex, toIndex in
                                                    moveSubscription(from: fromIndex, to: toIndex)
                                                }
                                            )
                                        )
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
                    loadCustomOrder()
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
                    Button {
                        generator.impactOccurred()
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Color.primaryGradient)
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
        }
    }
    
    private func loadCustomOrder() {
        if let saved = UserDefaults.standard.stringArray(forKey: "customOrder") {
            customOrder = saved
        }
    }
    
    private func saveCustomOrder() {
        UserDefaults.standard.set(customOrder, forKey: "customOrder")
    }
    
    private func moveSubscription(from: Int, to: Int) {
        guard from != to else { return }
        let item = customOrder.remove(at: from)
        customOrder.insert(item, at: to)
        saveCustomOrder()
        refreshID += 1
    }
    
    private func updateWidgetData() {
        let total = subscriptions.reduce(0) { $0 + $1.monthlyCost }
        let next = subscriptions.sorted { $0.nextBillingDate < $1.nextBillingDate }.first
        let defaults = UserDefaults(suiteName: "group.com.trios2026sn.Spendora")
        defaults?.set(total, forKey: "totalSpending")
        defaults?.set(next?.displayName ?? "None", forKey: "nextSubscription")
        defaults?.synchronize()
        WidgetCenter.shared.reloadAllTimelines()
    }
}

// MARK: - Drop Delegate
struct SubscriptionDropDelegate: DropDelegate {
    let items: [Subscription]
    let subscription: Subscription
    let onMove: (Int, Int) -> Void
    
    func performDrop(info: DropInfo) -> Bool { true }
    func dropUpdated(info: DropInfo) -> DropProposal? { DropProposal(operation: .move) }
    
    func dropEntered(info: DropInfo) {
        guard let fromIndex = items.firstIndex(where: { $0.id == subscription.id }) else { return }
        let toIndex = items.firstIndex(where: { $0.id == subscription.id }) ?? 0
        if fromIndex != toIndex {
            onMove(fromIndex, toIndex)
        }
    }
}

// MARK: - Premium Stat Card
struct PremiumStatCard: View {
    let title: String; let value: String; let icon: String; let color: Color
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(color.opacity(0.12)).frame(width: 40, height: 40)
                Image(systemName: icon).font(.title3).foregroundColor(color)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.caption).foregroundColor(.secondary)
                Text(value).font(.headline).fontWeight(.bold).foregroundColor(.primary)
            }
            Spacer()
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)).shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2))
    }
}

// MARK: - Premium Empty State
struct PremiumEmptyStateView: View {
    @State private var bounce = false
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle().fill(Color.brandPrimary.opacity(0.08)).frame(width: 120, height: 120)
                Circle().fill(Color.brandPrimary.opacity(0.15)).frame(width: 100, height: 100)
                Image(systemName: "sparkles.rectangle.stack").font(.system(size: 44)).foregroundStyle(Color.primaryGradient)
            }
            .scaleEffect(bounce ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: bounce)
            .onAppear { bounce = true }
            Text("No Subscriptions Yet").font(.title2).fontWeight(.bold).foregroundColor(.primary)
            Text("Tap the + button to start tracking your subscriptions").font(.body).foregroundColor(.secondary).multilineTextAlignment(.center)
        }
        .padding(.vertical, 60)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 24).fill(Color(.systemBackground)).shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 4))
    }
}
