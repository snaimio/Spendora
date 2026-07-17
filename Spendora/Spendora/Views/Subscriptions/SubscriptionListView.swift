//
//  SubscriptionListView.swift
//  Spendora
//
//  Created by Sheikh Naim on 2026-06-19.
//

import SwiftUI
import SwiftData
import WidgetKit

struct SubscriptionListView: View {
    @Query var subscriptions: [Subscription]
    @Environment(\.modelContext) private var modelContext

    @State private var searchText = ""
    @State private var sortOption: SortOption = .alphabetical
    @State private var selectedCategory: String?

    // MARK: - Sorted Subscriptions

    var sortedSubscriptions: [Subscription] {
        switch sortOption {
        case .alphabetical:
            return subscriptions.sorted {
                $0.displayName < $1.displayName
            }

        case .cost:
            return subscriptions.sorted {
                $0.monthlyCost > $1.monthlyCost
            }

        case .cheapest:
            return subscriptions.sorted {
                $0.monthlyCost < $1.monthlyCost
            }

        case .renewalDate:
            return subscriptions.sorted {
                $0.nextBillingDate < $1.nextBillingDate
            }

        case .category:
            return subscriptions.sorted {
                $0.effectiveCategory < $1.effectiveCategory
            }

        default:
            return subscriptions
        }
    }

    // MARK: - Filtered Subscriptions

    var filteredSubscriptions: [Subscription] {
        var result = sortedSubscriptions

        if !searchText.isEmpty {
            result = result.filter {
                $0.displayName.localizedCaseInsensitiveContains(searchText)
                || $0.effectiveCategory.localizedCaseInsensitiveContains(searchText)
            }
        }

        if let category = selectedCategory,
           category != "All" {
            result = result.filter {
                $0.effectiveCategory == category
            }
        }

        return result
    }

    // MARK: - Categories

    var categories: [String] {
        let all = Set(
            subscriptions.map {
                $0.effectiveCategory
            }
        )

        return ["All"] + all.sorted()
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // Search Bar

                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)

                    TextField(
                        "Search subscriptions...",
                        text: $searchText
                    )
                    .textFieldStyle(.plain)

                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(12)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(
                    color: .black.opacity(0.04),
                    radius: 4
                )
                .padding(.horizontal)
                .padding(.top, 8)

                // Sort & Filter

                HStack {
                    Picker(
                        "Sort",
                        selection: $sortOption
                    ) {
                        ForEach(
                            SortOption.allCases,
                            id: \.self
                        ) { option in
                            Text(option.rawValue)
                                .tag(option)
                        }
                    }
                    .pickerStyle(.menu)

                    Spacer()

                    Menu {
                        ForEach(categories, id: \.self) { category in
                            Button {
                                selectedCategory =
                                    category == "All"
                                    ? nil
                                    : category
                            } label: {
                                HStack {
                                    Text(category)

                                    if selectedCategory == category
                                        || (category == "All"
                                            && selectedCategory == nil) {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "line.3.horizontal.decrease.circle")

                            Text(selectedCategory ?? "All")
                                .font(.caption)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)

                // Subscription List

                if filteredSubscriptions.isEmpty {

                    if subscriptions.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "tray")
                                .font(.system(size: 48))
                                .foregroundColor(.secondary)

                            Text("No subscriptions yet")
                                .font(.headline)

                            Text("Tap + to add your first subscription")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 60)

                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 40))
                                .foregroundColor(.secondary)

                            Text("No matches found")
                                .font(.headline)

                            Text("Try adjusting your search")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 60)
                    }

                } else {

                    List {
                        ForEach(filteredSubscriptions) { subscription in
                            NavigationLink(
                                destination: SubscriptionDetailView(
                                    subscription: subscription
                                )
                            ) {
                                SubscriptionCard(
                                    subscription: subscription
                                )
                            }
                        }
                        .onDelete { indexSet in
                            deleteSubscriptions(at: indexSet)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Subscriptions")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            .onChange(of: subscriptions.count) { _, _ in
                updateWidget()
            }
        }
    }

    // MARK: - Delete

    private func deleteSubscriptions(at offsets: IndexSet) {
        for index in offsets {
            let subscription = filteredSubscriptions[index]

            NotificationService.shared.cancel(
                for: subscription
            )

            modelContext.delete(subscription)
        }

        do {
            try modelContext.save()
        } catch {
            print("Error deleting subscriptions: \(error)")
        }

        updateWidget()
    }

    // MARK: - Widget Update

    private func updateWidget() {
        let total = subscriptions.reduce(0) {
            $0 + $1.monthlyCost
        }

        let next = subscriptions
            .filter { !$0.isOverdue }
            .sorted {
                $0.nextBillingDate < $1.nextBillingDate
            }
            .first

        guard let defaults = UserDefaults(
            suiteName: "group.com.spendora.app"
        ) else {
            return
        }

        defaults.set(
            total,
            forKey: "totalMonthly"
        )

        defaults.set(
            next?.displayName ?? "None",
            forKey: "nextSubName"
        )

        defaults.set(
            next?.nextBillingDate.timeIntervalSince1970 ?? 0,
            forKey: "nextSubDate"
        )

        WidgetCenter.shared.reloadAllTimelines()
    }
}

#Preview {
    SubscriptionListView()
}
