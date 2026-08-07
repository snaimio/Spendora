//
//  SubscriptionListView.swift
//

import SwiftUI
import SwiftData


// MARK: - SubscriptionListView

/**
 `SubscriptionListView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for subscriptionlistview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `SubscriptionListView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct SubscriptionListView: View {

    // MARK: - Properties

    @Query private var subscriptions: [Subscription]
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    @State private var selectedSubscription: Subscription?
    @State private var sortOption: SortOption = .alphabetical
    
    var filteredSubscriptions: [Subscription] {  // filteredSubscriptions property
        let sorted = sortSubscriptions(subscriptions)
        if searchText.isEmpty { return sorted }
        return sorted.filter {
            $0.displayName.localizedCaseInsensitiveContains(searchText) ||
            $0.effectiveCategory.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var totalMonthly: Double {  // totalMonthly property
        filteredSubscriptions.reduce(0) { $0 + $1.monthlyCost }
    }
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBarView(searchText: $searchText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                
                HStack {
                    Text("\(filteredSubscriptions.count) subscriptions")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    Text("Total: \(CurrencyManager.shared.format(totalMonthly))/mo")
                        .font(.system(.caption, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.brandPrimary)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                SortChipsView(sortOption: $sortOption)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                
                if filteredSubscriptions.isEmpty {
                    EmptyStateView()
                        .padding(.top, 40)
                } else {
                    List {
                        let active = filteredSubscriptions.filter { !$0.isCancelled }
                        let cancelled = filteredSubscriptions.filter { $0.isCancelled }
                        
                        if !active.isEmpty {
                            Section("Active Subscriptions (\(active.count))") {
                                ForEach(active) { subscription in
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
                            }
                        }
                        
                        if !cancelled.isEmpty {
                            Section("Cancelled & Paused (\(cancelled.count))") {
                                ForEach(cancelled) { subscription in
                                    SubscriptionRow(subscription: subscription)
                                        .opacity(0.8)
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
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("All Subscriptions")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedSubscription) { subscription in
                SubscriptionDetailView(subscription: subscription)
            }
        }
    }
    

    /**
     Executes `sortSubscriptions` for component logic.
     
     - Parameter subs: Value passed to `sortSubscriptions`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
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
    

    /**
     Executes `deleteSubscription` for component logic.
     
     - Parameter subscription: Value passed to `deleteSubscription`.
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    private func deleteSubscription(_ subscription: Subscription) {
        NotificationService.shared.cancel(for: subscription)
        modelContext.delete(subscription)
        try? modelContext.save()
    }
}
