//
//  SubscriptionDetailView.swift
//  Spendora
//

import SwiftUI
import SwiftData

struct SubscriptionDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let subscription: Subscription
    
    @State private var name: String
    @State private var cost: String
    @State private var category: String
    @State private var isYearly: Bool
    @State private var nextBillingDate: Date
    @State private var notes: String
    @State private var colorHex: String
    @State private var isTrial: Bool
    @State private var usageRating: Int
    @State private var paymentMethod: String
    
    @State private var showingDeleteAlert = false
    @State private var isSaving = false
    @State private var showingError = false
    @State private var errorMessage = ""
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    init(subscription: Subscription) {
        self.subscription = subscription
        _name = State(initialValue: subscription.name)
        _cost = State(initialValue: String(format: "%.2f", subscription.cost))
        _category = State(initialValue: subscription.category)
        _isYearly = State(initialValue: subscription.isYearly)
        _nextBillingDate = State(initialValue: subscription.nextBillingDate)
        _notes = State(initialValue: subscription.notes ?? "")
        _colorHex = State(initialValue: subscription.colorHex ?? "#6C63FF")
        _isTrial = State(initialValue: subscription.isTrial)
        _usageRating = State(initialValue: subscription.usageRating)
        _paymentMethod = State(initialValue: subscription.paymentMethod ?? "Not Set")
    }
    
    var costValue: Double? { Double(cost) }
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (costValue ?? 0) > 0
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Subscription Info
                Section("Subscription Info") {
                    SubscriptionDetailSection(icon: "tag.fill", title: "Name", value: name)
                    SubscriptionDetailSection(icon: "dollarsign.circle.fill", title: "Cost", value: "$\(cost)/\(isYearly ? "year" : "month")")
                    SubscriptionDetailSection(icon: "folder.fill", title: "Category", value: category)
                    SubscriptionDetailSection(icon: "creditcard.fill", title: "Payment Method", value: paymentMethod)
                    SubscriptionDetailSection(icon: "repeat.circle.fill", title: "Billing Cycle", value: isYearly ? "Yearly" : "Monthly")
                }
                
                // MARK: - Billing
                Section("Billing") {
                    SubscriptionDetailSection(icon: "calendar", title: "Next Billing Date", value: subscription.formattedNextBillingDate)
                    SubscriptionDetailSection(icon: "clock.fill", title: "Days Until Billing", value: "\(subscription.daysUntilBilling) days")
                    
                    if subscription.isOverdue {
                        SubscriptionDetailSection(icon: "exclamationmark.triangle.fill", title: "Status", value: "Overdue", color: .red)
                    } else if subscription.isUpcoming {
                        SubscriptionDetailSection(icon: "bell.fill", title: "Status", value: "Due Soon", color: .orange)
                    } else {
                        SubscriptionDetailSection(icon: "checkmark.circle.fill", title: "Status", value: "Active", color: .green)
                    }
                }
                
                // MARK: - Usage Rating
                Section("Usage Rating") {
                    HStack {
                        Text("How often do you use this?")
                            .font(.system(.body, design: .rounded))
                        Spacer()
                        UsageRatingView(rating: $usageRating, maximumRating: 5) { newRating in
                            subscription.usageRating = newRating
                            try? modelContext.save()
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                // MARK: - Trial Info
                if subscription.isTrial {
                    Section("Trial Information") {
                        SubscriptionDetailSection(icon: "clock.arrow.circlepath", title: "Trial Status", value: subscription.trialStatus)
                        if let trialEndDate = subscription.trialEndDate {
                            SubscriptionDetailSection(icon: "calendar.badge.clock", title: "Trial Ends", value: trialEndDate.formattedAsMonthDayYear)
                        }
                        if subscription.trialWarning {
                            SubscriptionDetailSection(icon: "exclamationmark.triangle.fill", title: "Warning", value: "Trial ending soon!", color: .orange)
                        }
                    }
                }
                
                // MARK: - Notes
                if let notes = subscription.notes, !notes.isEmpty {
                    Section("Notes") {
                        Text(notes)
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
                
                // MARK: - Actions
                Section {
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Delete Subscription")
                                .font(.system(.headline, design: .rounded))
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Subscription Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        generator.impactOccurred()
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded))
                }
            }
            .alert("Delete Subscription", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteSubscription()
                }
            } message: {
                Text("Are you sure you want to delete '\(subscription.displayName)'? This action cannot be undone.")
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func deleteSubscription() {
        NotificationService.shared.cancel(for: subscription)
        modelContext.delete(subscription)
        do {
            try modelContext.save()
            generator.impactOccurred()
            dismiss()
        } catch {
            errorMessage = "Failed to delete: \(error.localizedDescription)"
            showingError = true
        }
    }
}
