//
//  SubscriptionDetailView.swift
//  Spendora
//
//  Capstone 2026 - Mobile Application Development
//  Author: Sheikh Naim
//

/**
 * Main/Core Functions & Purpose:
 * SubscriptionDetailView screen managing subscription details, editing, and cancellation.
 * Displays billing history metrics, usage value ratings (1-5 stars), price alert settings,
 * trial expiration countdowns, and direct deep-link "Cancel on Provider Website" integration.
 */

import SwiftUI
import SwiftData

struct SubscriptionDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    let subscription: Subscription
    
    // Editable subscription fields
    @State var name: String
    @State var cost: String
    @State var category: String
    @State var isYearly: Bool
    @State var nextBillingDate: Date
    @State var notes: String
    @State var colorHex: String
    @State var isTrial: Bool
    @State var usageRating: Int
    @State var paymentMethod: String
    
    @State var showingDeleteAlert = false
    @State var isSaving = false
    @State var showingError = false
    @State var errorMessage = ""
    @State var isEditing = false
    @State var showingCancelSheet = false
    
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
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
                if isEditing {
                    editModeContent
                } else {
                    viewModeContent
                }
                
                // MARK: - Remove from App
                Section {
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Remove from App")
                                .font(.system(.headline, design: .rounded))
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                } footer: {
                    Text("This only removes the record from your app. It does NOT cancel your subscription with the provider.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle(isEditing ? "Edit Service" : "Service Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isEditing {
                        Button("Cancel") {
                            isEditing = false
                            resetValues()
                        }
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.brandPrimary)
                    } else {
                        Button("Edit") {
                            isEditing = true
                        }
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.brandPrimary)
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        generator.impactOccurred()
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.brandPrimary)
                }
            }
            .alert("Remove from App", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Remove", role: .destructive) {
                    deleteSubscription()
                }
            } message: {
                Text("This will only remove '\(subscription.displayName)' from your app. Your subscription with the provider will NOT be cancelled.")
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .sheet(isPresented: $showingCancelSheet) {
                CancelSubscriptionView(subscription: subscription)
            }
        }
    }
    
    // MARK: - Edit Mode Content
    @ViewBuilder
    private var editModeContent: some View {
        SubscriptionDetailEditSection(
            subscription: subscription,
            name: $name,
            cost: $cost,
            category: $category,
            paymentMethod: $paymentMethod,
            isYearly: $isYearly,
            nextBillingDate: $nextBillingDate,
            isTrial: $isTrial,
            notes: $notes,
            usageRating: $usageRating,
            isSaving: $isSaving,
            isValid: isValid,
            saveChangesAction: saveChanges,
            ratingDescription: ratingDescription
        )
    }
    
    // MARK: - View Mode Content
    @ViewBuilder
    private var viewModeContent: some View {
        SubscriptionDetailViewSection(
            subscription: subscription,
            name: name,
            cost: cost,
            isYearly: isYearly,
            category: category,
            paymentMethod: paymentMethod,
            getCancellationURL: getCancellationURL,
            showingCancelSheet: $showingCancelSheet
        )
    }
}
