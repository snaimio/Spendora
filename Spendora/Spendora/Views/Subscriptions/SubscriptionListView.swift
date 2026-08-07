//
//  SubscriptionListView.swift
//  Spendora
//

import SwiftUI
import SwiftData

// MARK: - SubscriptionListView

/**
 `SubscriptionListView` presents the complete subscription portfolio with Apple HIG Segmented Controls:
 - Segmented Filter (Active | Cancelled | All)
 - Search & Multi-criteria Sort Chips (Alphabetical, Cost, Renewal Date, Category)
 - Direct Swipe-to-Edit & Swipe-to-Delete actions
 */
struct SubscriptionListView: View {

    // MARK: - Properties

    @Query private var subscriptions: [Subscription]
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    @State private var selectedSubscription: Subscription?
    @State private var sortOption: SortOption = .alphabetical
    @State private var statusFilter: SubscriptionStatusFilter = .active
    
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
            VStack(spacing: 0) {
                SearchBarView(searchText: $searchText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                
                // Segmented Status Filter
                Picker("Filter", selection: $statusFilter) {
                    Text("Active (\(activeSubscriptions.count))").tag(SubscriptionStatusFilter.active)
                    Text("Cancelled (\(cancelledSubscriptions.count))").tag(SubscriptionStatusFilter.cancelled)
                    Text("All (\(filteredSubscriptions.count))").tag(SubscriptionStatusFilter.all)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 12)
                .padding(.bottom, 6)
                
                HStack {
                    Text("\(displayedSubscriptions.count) subscriptions")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    Text("Monthly Run-Rate: \(CurrencyManager.shared.format(totalMonthly))")
                        .font(.system(.caption, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.brandPrimary)
                }
                .padding(.horizontal)
                .padding(.vertical, 6)
                
                SortChipsView(sortOption: $sortOption)
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                
                if displayedSubscriptions.isEmpty {
                    EmptyStateView()
                        .padding(.top, 40)
                } else {
                    List {
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
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Portfolio")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedSubscription) { subscription in
                SubscriptionDetailView(subscription: subscription)
            }
        }
    }
    
    @ViewBuilder
    private func subscriptionListRow(for subscription: Subscription) -> some View {
        SubscriptionRow(subscription: subscription)
            .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
            .listRowBackground(Color.clear)
            .contentShape(Rectangle())
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
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                Button {
                    selectedSubscription = subscription
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                .tint(.blue)
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
