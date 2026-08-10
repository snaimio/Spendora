//
//  SubscriptionListView.swift
//  Spendora
//

import SwiftUI
import SwiftData

// MARK: - SubscriptionListView (Apple Native InsetGrouped Portfolio)

struct SubscriptionListView: View {

    // MARK: - Properties

    @Query private var subscriptions: [Subscription]
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    @State private var selectedSubscription: Subscription?
    @State private var sortOption: SortOption = .alphabetical
    @State private var statusFilter: SubscriptionStatusFilter = .active
    @State private var showingAddSheet = false
    
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    var filteredSubscriptions: [Subscription] {
        let sorted = sortSubscriptions(subscriptions)
        if searchText.isEmpty { return sorted }
        return sorted.filter {
            $0.displayName.localizedCaseInsensitiveContains(searchText) ||
            $0.effectiveCategory.localizedCaseInsensitiveContains(searchText)
        }
    }

    var activeSubscriptions: [Subscription] {
        filteredSubscriptions.filter { !$0.isCancelled }
    }

    var cancelledSubscriptions: [Subscription] {
        filteredSubscriptions.filter { $0.isCancelled }
    }
    
    var displayedSubscriptions: [Subscription] {
        switch statusFilter {
        case .active: return activeSubscriptions
        case .cancelled: return cancelledSubscriptions
        case .all: return filteredSubscriptions
        }
    }
    
    var totalMonthly: Double {
        activeSubscriptions.reduce(0) { $0 + $1.monthlyCost }
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Group {
                if displayedSubscriptions.isEmpty && searchText.isEmpty && subscriptions.isEmpty {
                    ContentUnavailableView(
                        "No Subscriptions",
                        systemImage: "creditcard",
                        description: Text("Tap + to add your first subscription")
                    )
                } else {
                    List {
                        // Section: Filter & Summary Controls
                        Section {
                            VStack(spacing: 12) {
                                Picker("Filter", selection: $statusFilter) {
                                    Text("Active (\(activeSubscriptions.count))").tag(SubscriptionStatusFilter.active)
                                    Text("Cancelled (\(cancelledSubscriptions.count))").tag(SubscriptionStatusFilter.cancelled)
                                    Text("All (\(filteredSubscriptions.count))").tag(SubscriptionStatusFilter.all)
                                }
                                .pickerStyle(.segmented)
                                
                                HStack {
                                    Text("\(displayedSubscriptions.count) \(displayedSubscriptions.count == 1 ? "subscription" : "subscriptions")")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    Text("Monthly Total: \(CurrencyManager.shared.format(totalMonthly))")
                                        .font(.caption.weight(.semibold))
                                        .foregroundColor(SpendoraTheme.accent)
                                }
                                
                                SortChipsView(sortOption: $sortOption)
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        
                        // Section: Subscription Rows
                        if statusFilter == .all {
                            if !activeSubscriptions.isEmpty {
                                Section("Active Subscriptions (\(activeSubscriptions.count))") {
                                    ForEach(activeSubscriptions) { subscription in
                                        subscriptionListRow(for: subscription)
                                    }
                                }
                            }
                            
                            if !cancelledSubscriptions.isEmpty {
                                Section("Cancelled & Paused (\(cancelledSubscriptions.count))") {
                                    ForEach(cancelledSubscriptions) { subscription in
                                        subscriptionListRow(for: subscription)
                                            .opacity(0.75)
                                    }
                                }
                            }
                        } else {
                            ForEach(displayedSubscriptions) { subscription in
                                subscriptionListRow(for: subscription)
                                    .opacity(subscription.isCancelled ? 0.75 : 1.0)
                            }
                            
                            if statusFilter == .cancelled && cancelledSubscriptions.count <= 1 {
                                VStack(spacing: 8) {
                                    Image(systemName: "checkmark.seal.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(SpendoraTheme.accent.opacity(0.4))
                                    Text("You're in good shape")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Color(.secondaryLabel))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 40)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Subscriptions")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search subscriptions")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        generator.impactOccurred()
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(SpendoraTheme.accent)
                            .clipShape(Circle())
                    }
                }
            }
            .sheet(item: $selectedSubscription) { subscription in
                SubscriptionDetailView(subscription: subscription)
            }
            .sheet(isPresented: $showingAddSheet) {
                AddSubscriptionView()
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: subscriptions.count)
        }
    }
    
    // MARK: - Row Builder with Native Swipe Actions

    @ViewBuilder
    private func subscriptionListRow(for subscription: Subscription) -> some View {
        SubscriptionRow(subscription: subscription)
            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .contentShape(Rectangle())
            .onTapGesture {
                generator.impactOccurred()
                selectedSubscription = subscription
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    deleteSubscription(subscription)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                Button {
                    generator.impactOccurred()
                    subscription.markAsPaid()
                    try? modelContext.save()
                } label: {
                    Label("Paid", systemImage: "checkmark.circle")
                }
                .tint(SpendoraTheme.accent)
            }
    }

    private func sortSubscriptions(_ subs: [Subscription]) -> [Subscription] {
        switch sortOption {
        case .alphabetical:
            return subs.sorted { $0.displayName < $1.displayName }
        case .cost:
            return subs.sorted { $0.monthlyCost > $1.monthlyCost }
        case .cheapest:
            return subs.sorted { $0.monthlyCost < $1.monthlyCost }
        case .renewalDate:
            return subs.sorted { $0.nextBillingDate < $1.nextBillingDate }
        case .category:
            return subs.sorted { $0.effectiveCategory < $1.effectiveCategory }
        case .recentlyAdded:
            return subs.sorted { $0.createdAt > $1.createdAt }
        }
    }

    private func deleteSubscription(_ subscription: Subscription) {
        NotificationService.shared.cancel(for: subscription)
        modelContext.delete(subscription)
        try? modelContext.save()
    }
}
