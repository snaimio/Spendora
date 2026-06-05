//
//  HomeView.swift
//  Spendora
//

import SwiftUI
import SwiftData

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
                    VStack(spacing: 16) {
                        HStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Monthly")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(String(format: "$%.2f", totalMonthly))
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
                                Text(String(format: "$%.2f", totalYearly))
                                    .font(.system(size: 34, weight: .bold))
                                    .foregroundColor(.primary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        if totalMonthly > 0 {
                            Divider()
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                                Text("You're spending \(String(format: "$%.0f", totalMonthly))/month on subscriptions")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // Analytics Card
                    if !filteredSubscriptions.isEmpty {
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
                                    Text(String(format: "$%.2f", averageMonthlyCost))
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                }
                                Spacer()
                                if let highest = highestCostSubscription {
                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("Highest")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text(highest.displayName)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        Text(String(format: "$%.2f", highest.monthlyCost))
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
                    }
                    
                    // Next Charge Card
                    if let next = nextSubscription {
                        HStack(spacing: 16) {
                            VStack(spacing: 4) {
                                Text(getMonthAbbreviation(for: next.nextBillingDate))
                                    .font(.caption2)
                                    .fontWeight(.medium)
                                    .foregroundColor(.blue)
                                Text(getDayString(for: next.nextBillingDate))
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                            .frame(width: 60, height: 60)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Next Charge")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(next.displayName)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                HStack(spacing: 8) {
                                    Text(String(format: "$%.2f", next.monthlyCost))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("•")
                                        .foregroundColor(.secondary)
                                    Text(getDaysUntil(next.nextBillingDate) == 0 ? "Today" : "In \(getDaysUntil(next.nextBillingDate)) days")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(getDaysUntil(next.nextBillingDate) <= 3 ? .orange : .secondary)
                                }
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .padding(.horizontal)
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
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search by name or category...", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                    }
                    .padding(.horizontal)
                    
                    // Subscriptions List
                    if filteredSubscriptions.isEmpty {
                        VStack(spacing: 20) {
                            Spacer().frame(height: 60)
                            ZStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.1))
                                    .frame(width: 120, height: 120)
                                Image(systemName: "creditcard.and.123")
                                    .font(.system(size: 50))
                                    .foregroundColor(.blue)
                            }
                            Text("No Subscriptions Yet")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Start tracking your subscriptions by tapping the + button above.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredSubscriptions) { subscription in
                                HStack(spacing: 16) {
                                    let category = SubscriptionCategory(rawValue: subscription.category) ?? .other
                                    Circle()
                                        .fill(Color.blue.opacity(0.1))
                                        .frame(width: 50, height: 50)
                                        .overlay {
                                            Image(systemName: category.icon)
                                                .foregroundColor(.blue)
                                                .font(.title3)
                                        }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(subscription.displayName)
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                        
                                        if subscription.isYearly {
                                            Text(String(format: "$%.2f", subscription.cost))
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            + Text("/year")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                            Text("(\(String(format: "$%.2f", subscription.monthlyCost))/month equivalent)")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                        } else {
                                            Text(String(format: "$%.2f", subscription.monthlyCost))
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            + Text("/month")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        HStack(spacing: 4) {
                                            Image(systemName: "calendar")
                                                .font(.caption2)
                                            Text("Next: \(subscription.formattedNextBillingDate)")
                                                .font(.caption)
                                        }
                                        .foregroundColor(subscription.isUpcoming ? .orange : .secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    if subscription.isUpcoming {
                                        Text("Soon")
                                            .font(.caption2)
                                            .fontWeight(.medium)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.orange.opacity(0.2))
                                            .foregroundColor(.orange)
                                            .cornerRadius(8)
                                    }
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
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
            generator.impactOccurred()
        } catch {
            errorMessage = "Failed to delete: \(error.localizedDescription)"
            showingErrorAlert = true
        }
    }
    
    private func getMonthAbbreviation(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date).uppercased()
    }
    
    private func getDayString(for date: Date) -> String {
        let day = Calendar.current.component(.day, from: date)
        return "\(day)"
    }
    
    private func getDaysUntil(_ date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
    }
}
