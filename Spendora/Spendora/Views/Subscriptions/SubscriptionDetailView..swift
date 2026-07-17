//
//  SubscriptionDetailView.swift
//  Spendora
//

import SwiftUI
import SwiftData
import UIKit

struct SubscriptionDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var subscription: Subscription

    @State private var showingDeleteAlert = false
    @State private var showingEditSheet = false

    private let generator = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        NavigationStack {
            List {
                Section("Details") {
                    DetailRow(
                        icon: "tag.fill",
                        title: "Name",
                        value: subscription.displayName
                    )

                    DetailRow(
                        icon: "dollarsign.circle.fill",
                        title: "Cost",
                        value: formatCost()
                    )

                    DetailRow(
                        icon: "calendar.circle.fill",
                        title: "Billing Cycle",
                        value: subscription.isYearly ? "Yearly" : "Monthly"
                    )

                    DetailRow(
                        icon: "calendar.badge.clock",
                        title: "Next Billing",
                        value: subscription.formattedNextBillingDate
                    )

                    DetailRow(
                        icon: "folder.fill",
                        title: "Category",
                        value: subscription.effectiveCategory
                    )

                    if let paymentMethod = subscription.paymentMethod,
                       !paymentMethod.isEmpty {
                        DetailRow(
                            icon: "creditcard.fill",
                            title: "Payment Method",
                            value: paymentMethod
                        )
                    }
                }

                Section("Monthly Breakdown") {
                    HStack {
                        Text("Monthly Cost")
                        Spacer()
                        Text(String(format: "$%.2f", subscription.monthlyCost))
                            .fontWeight(.semibold)
                    }

                    if subscription.isYearly {
                        HStack {
                            Text("Yearly Cost")
                            Spacer()
                            Text(String(format: "$%.2f", subscription.yearlyCost))
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                    }
                }

                Section {
                    Button {
                        openCancellationPage()
                    } label: {
                        HStack {
                            Image(systemName: "safari")
                            Text("Cancel Subscription")

                            Spacer()

                            Image(systemName: "arrow.up.forward.square")
                                .font(.caption)
                        }
                    }
                    .foregroundColor(.red)
                }

                Section {
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Delete Subscription")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Subscription Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        showingEditSheet = true
                    }
                }
            }
            .sheet(isPresented: $showingEditSheet) {
                EditSubscriptionView(subscription: subscription)
            }
            .alert("Delete Subscription", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {}

                Button("Delete", role: .destructive) {
                    deleteSubscription()
                }
            } message: {
                Text("Are you sure you want to delete \(subscription.displayName)?")
            }
        }
    }

    private func formatCost() -> String {
        if subscription.isYearly {
            return String(format: "$%.2f per year", subscription.cost)
        } else {
            return String(format: "$%.2f per month", subscription.monthlyCost)
        }
    }

    private func deleteSubscription() {
        NotificationService.shared.cancel(for: subscription)

        modelContext.delete(subscription)

        do {
            try modelContext.save()
        } catch {
            print("Error deleting subscription: \(error)")
        }

        generator.impactOccurred()
        dismiss()
    }

    private func openCancellationPage() {
        let serviceName = subscription.displayName.lowercased()
        let urlString: String

        if serviceName.contains("netflix") {
            urlString = "https://www.netflix.com/cancelplan"
        } else if serviceName.contains("spotify") {
            urlString = "https://www.spotify.com/account/cancel/"
        } else if serviceName.contains("apple") {
            urlString = "https://appleid.apple.com/account/manage"
        } else if serviceName.contains("disney") {
            urlString = "https://www.disneyplus.com/account"
        } else if serviceName.contains("amazon")
                    || serviceName.contains("prime") {
            urlString = "https://www.amazon.com/gp/css/account/manageprime"
        } else {
            let searchQuery = serviceName
                .replacingOccurrences(of: " ", with: "+")

            urlString = "https://www.google.com/search?q=how+to+cancel+\(searchQuery)"
        }

        guard let url = URL(string: urlString) else {
            return
        }

        UIApplication.shared.open(url)
    }
}

// MARK: - Detail Row

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)

            Text(title)
                .foregroundColor(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Edit Subscription View

struct EditSubscriptionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var subscription: Subscription

    @State private var name: String
    @State private var cost: String
    @State private var selectedCategory: String
    @State private var isYearly: Bool
    @State private var nextBillingDate: Date

    init(subscription: Subscription) {
        self.subscription = subscription

        _name = State(initialValue: subscription.name)
        _cost = State(initialValue: String(subscription.cost))
        _selectedCategory = State(initialValue: subscription.category)
        _isYearly = State(initialValue: subscription.isYearly)
        _nextBillingDate = State(initialValue: subscription.nextBillingDate)
    }

    var isValid: Bool {
        let trimmedName = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmedName.isEmpty else {
            return false
        }

        guard let costValue = Double(cost),
              costValue > 0 else {
            return false
        }

        return true
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Edit Subscription") {
                    TextField("Service Name", text: $name)

                    HStack {
                        Text("$")
                            .foregroundColor(.secondary)

                        TextField("Cost", text: $cost)
                            .keyboardType(.decimalPad)
                    }

                    Picker("Category", selection: $selectedCategory) {
                        ForEach(
                            SubscriptionCategory.allCases,
                            id: \.rawValue
                        ) { category in
                            Text(category.rawValue)
                                .tag(category.rawValue)
                        }
                    }

                    Toggle("Yearly Billing", isOn: $isYearly)

                    DatePicker(
                        "Next Billing Date",
                        selection: $nextBillingDate,
                        in: Date()...,
                        displayedComponents: .date
                    )
                }
            }
            .navigationTitle("Edit Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }

    private func saveChanges() {
        guard let costValue = Double(cost) else {
            return
        }

        subscription.name = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        subscription.cost = costValue
        subscription.category = selectedCategory
        subscription.isYearly = isYearly
        subscription.nextBillingDate = nextBillingDate

        NotificationService.shared.cancel(for: subscription)
        NotificationService.shared.schedule(for: subscription)

        do {
            try modelContext.save()
        } catch {
            print("Error saving changes: \(error)")
            return
        }

        dismiss()
    }
}

// MARK: - Preview

#Preview {
    let sample = Subscription(
        name: "Netflix",
        cost: 15.99,
        isYearly: false,
        nextBillingDate: Date().addingTimeInterval(86400 * 30),
        category: SubscriptionCategory.entertainment.rawValue,
        colorHex: "#FF6B6B"
    )

    return SubscriptionDetailView(subscription: sample)
        .modelContainer(for: Subscription.self, inMemory: true)
}
