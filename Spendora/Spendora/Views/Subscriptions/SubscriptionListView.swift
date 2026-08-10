//
//  SubscriptionListView.swift
//  Spendora
//

import SwiftUI
import SwiftData

// MARK: - SubscriptionListView (Golden UX Portfolio Screen)

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
    let notificationGenerator = UINotificationFeedbackGenerator()
    
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
            ZStack {
                SpendoraBrandBackgroundView()
                
                VStack(spacing: 0) {
                    // Search Bar: #FFF0EE background, 14pt radius, 16pt padding horizontal
                    SearchBarView(searchText: $searchText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    
                    // Segmented Control: Active (4) | Cancelled (1) | All (5)
                    Picker("Filter", selection: $statusFilter) {
                        Text("Active (\(activeSubscriptions.count))").tag(SubscriptionStatusFilter.active)
                        Text("Cancelled (\(cancelledSubscriptions.count))").tag(SubscriptionStatusFilter.cancelled)
                        Text("All (\(filteredSubscriptions.count))").tag(SubscriptionStatusFilter.all)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 6)
                    
                    // Summary Row: "X subscriptions" left 13pt secondary, "Monthly Total: C$XX.XX" right 13pt bold coral
                    HStack {
                        Text("\(displayedSubscriptions.count) \(displayedSubscriptions.count == 1 ? "subscription" : "subscriptions")")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(SpendoraTheme.Colors.textSecondary)
                        
                        Spacer()
                        
                        Text("Monthly Total: \(CurrencyManager.shared.format(totalMonthly))")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(SpendoraTheme.Colors.coral)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    
                    // Sort Pills (Horizontal scroll, no wrapping, active coral gradient)
                    SortChipsView(sortOption: $sortOption)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                    
                    // Empty State or List
                    if displayedSubscriptions.isEmpty {
                        EmptyStateView()
                            .padding(.top, 24)
                    } else {
                        List {
                            if statusFilter == .all {
                                if !activeSubscriptions.isEmpty {
                                    Section {
                                        ForEach(activeSubscriptions) { subscription in
                                            subscriptionListRow(for: subscription)
                                        }
                                    } header: {
                                        Text("Active Subscriptions (\(activeSubscriptions.count))")
                                            .font(.system(size: 11, weight: .semibold))
                                            .foregroundColor(SpendoraTheme.Colors.coralWarm)
                                            .textCase(.uppercase)
                                    }
                                }
                                
                                if !cancelledSubscriptions.isEmpty {
                                    Section {
                                        ForEach(cancelledSubscriptions) { subscription in
                                            subscriptionListRow(for: subscription)
                                                .opacity(0.75)
                                        }
                                    } header: {
                                        Text("Cancelled & Paused (\(cancelledSubscriptions.count))")
                                            .font(.system(size: 11, weight: .semibold))
                                            .foregroundColor(SpendoraTheme.Colors.cancelled)
                                            .textCase(.uppercase)
                                    }
                                }
                            } else {
                                ForEach(displayedSubscriptions) { subscription in
                                    subscriptionListRow(for: subscription)
                                        .opacity(subscription.isCancelled ? 0.75 : 1.0)
                                }
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationTitle("Subscriptions")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        generator.impactOccurred()
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(SpendoraTheme.Colors.coral)
                    }
                }
            }
            .sheet(item: $selectedSubscription) { subscription in
                SubscriptionDetailView(subscription: subscription)
            }
            .sheet(isPresented: $showingAddSheet) {
                AddSubscriptionView()
            }
        }
    }
    
    // MARK: - Row Builder with Swipe Actions & Haptics

    @ViewBuilder
    private func subscriptionListRow(for subscription: Subscription) -> some View {
        SubscriptionRow(subscription: subscription)
            .listRowInsets(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .contentShape(Rectangle())
            .onTapGesture {
                generator.impactOccurred()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    selectedSubscription = subscription
                }
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                // Swipe left: reveals coral delete background with trash.fill white 20pt
                Button(role: .destructive) {
                    deleteSubscription(subscription)
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                }
                .tint(SpendoraTheme.Colors.danger)
            }
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                // Swipe right: reveals mint mark-as-paid background
                Button {
                    generator.impactOccurred()
                    subscription.markAsPaid()
                    try? modelContext.save()
                } label: {
                    Label("Mark Paid", systemImage: "checkmark.circle.fill")
                }
                .tint(SpendoraTheme.Colors.success)
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
        notificationGenerator.notificationOccurred(.warning)
        NotificationService.shared.cancel(for: subscription)
        modelContext.delete(subscription)
        try? modelContext.save()
    }
}
