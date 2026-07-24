//
//  SubscriptionListView.swift
//  Spendora
//

import SwiftUI
import SwiftData

struct SubscriptionListView: View {
    @Query private var subscriptions: [Subscription]
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    @State private var selectedSubscription: Subscription?
    @State private var sortOption: SortOption = .alphabetical
    
    var filteredSubscriptions: [Subscription] {
        let sorted = sortSubscriptions(subscriptions)
        if searchText.isEmpty { return sorted }
        return sorted.filter {
            $0.displayName.localizedCaseInsensitiveContains(searchText) ||
            $0.effectiveCategory.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var totalMonthly: Double {
        filteredSubscriptions.reduce(0) { $0 + $1.monthlyCost }
    }
    
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
                        ForEach(filteredSubscriptions) { subscription in
                            SubscriptionRow(subscription: subscription)
                                .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                                .listRowBackground(Color.clear)
                                // ✅ Make the whole row tappable
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedSubscription = subscription
                                }
                                // ✅ Swipe actions
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
                    .listStyle(.plain)
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
