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
    @State private var isEditing = false
    
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
                if isEditing {
                    // MARK: - EDIT MODE
                    Section("Subscription Info") {
                        TextField("Service Name", text: $name)
                            .font(.system(.body, design: .rounded))
                        
                        HStack {
                            Text(CurrencyManager.shared.currentCurrency.symbol)
                                .foregroundColor(.textSecondary)
                            TextField("Cost", text: $cost)
                                .keyboardType(.decimalPad)
                                .font(.system(.body, design: .rounded))
                        }
                        
                        Picker("Category", selection: $category) {
                            ForEach(SubscriptionCategory.allCases, id: \.rawValue) { category in
                                Label(category.rawValue, systemImage: category.icon)
                                    .tag(category.rawValue)
                            }
                        }
                        
                        Picker("Payment Method", selection: $paymentMethod) {
                            ForEach(PaymentMethod.allCases, id: \.self) { method in
                                Text(method.rawValue).tag(method.rawValue)
                            }
                        }
                        
                        Toggle("Yearly Billing", isOn: $isYearly)
                        
                        DatePicker("Next Billing Date", selection: $nextBillingDate, in: Date()..., displayedComponents: .date)
                        
                        Toggle("Free Trial", isOn: $isTrial)
                        
                        if isTrial {
                            DatePicker("Trial End Date", selection: Binding(
                                get: { subscription.trialEndDate ?? Date() },
                                set: { subscription.trialEndDate = $0 }
                            ), in: Date()..., displayedComponents: .date)
                        }
                    }
                    
                    Section("Notes") {
                        TextField("Add notes...", text: $notes, axis: .vertical)
                            .lineLimit(3...6)
                            .font(.system(.body, design: .rounded))
                    }
                    
                    Section("Usage Rating") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("How often do you use this?")
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.textPrimary)
                            
                            UsageRatingView(rating: $usageRating, maximumRating: 5) { newRating in
                                subscription.usageRating = newRating
                                try? modelContext.save()
                            }
                            
                            if usageRating > 0 {
                                Text(ratingDescription)
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundColor(.textSecondary)
                                    .padding(.top, 4)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    
                    // Save Button
                    Section {
                        Button {
                            saveChanges()
                        } label: {
                            if isSaving {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                            } else {
                                Text("Save Changes")
                                    .frame(maxWidth: .infinity)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                        }
                        .disabled(!isValid || isSaving)
                        .listRowBackground(
                            LinearGradient(
                                colors: [Color(hex: "#FF6B6B"), Color(hex: "#FFE66D")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    }
                    
                } else {
                    // MARK: - VIEW MODE
                    Section("Subscription Info") {
                        DetailRow(icon: "tag.fill", title: "Name", value: name)
                        DetailRow(icon: "dollarsign.circle.fill", title: "Cost", value: "$\(cost)/\(isYearly ? "year" : "month")")
                        DetailRow(icon: "folder.fill", title: "Category", value: category)
                        DetailRow(icon: "creditcard.fill", title: "Payment Method", value: paymentMethod)
                        DetailRow(icon: "repeat.circle.fill", title: "Billing Cycle", value: isYearly ? "Yearly" : "Monthly")
                    }
                    
                    Section("Billing") {
                        DetailRow(icon: "calendar", title: "Next Billing Date", value: subscription.formattedNextBillingDate)
                        DetailRow(icon: "clock.fill", title: "Days Until Billing", value: "\(subscription.daysUntilBilling) days")
                        
                        if subscription.isOverdue {
                            DetailRow(icon: "exclamationmark.triangle.fill", title: "Status", value: "Overdue", color: .red)
                        } else if subscription.isUpcoming {
                            DetailRow(icon: "bell.fill", title: "Status", value: "Due Soon", color: .orange)
                        } else {
                            DetailRow(icon: "checkmark.circle.fill", title: "Status", value: "Active", color: .green)
                        }
                    }
                    
                    Section("Usage Rating") {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("How often do you use this?")
                                    .font(.system(.body, design: .rounded))
                                    .foregroundColor(.textPrimary)
                                Spacer()
                                UsageRatingView(rating: $usageRating, maximumRating: 5) { newRating in
                                    subscription.usageRating = newRating
                                    try? modelContext.save()
                                }
                            }
                            
                            if usageRating > 0 {
                                Text(ratingDescription)
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundColor(.textSecondary)
                                    .padding(.top, 4)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    
                    if subscription.isTrial {
                        Section("Trial Information") {
                            DetailRow(icon: "clock.arrow.circlepath", title: "Trial Status", value: subscription.trialStatus)
                            if let trialEndDate = subscription.trialEndDate {
                                DetailRow(icon: "calendar.badge.clock", title: "Trial Ends", value: trialEndDate.formattedAsMonthDayYear)
                            }
                            if subscription.trialWarning {
                                DetailRow(icon: "exclamationmark.triangle.fill", title: "Warning", value: "Trial ending soon!", color: .orange)
                            }
                        }
                    }
                    
                    if let notes = subscription.notes, !notes.isEmpty {
                        Section("Notes") {
                            Text(notes)
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
                
                // MARK: - Delete Button
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
            .navigationTitle(isEditing ? "Edit Subscription" : "Subscription Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isEditing {
                        Button("Cancel") {
                            isEditing = false
                            // Reset values
                            name = subscription.name
                            cost = String(format: "%.2f", subscription.cost)
                            category = subscription.category
                            isYearly = subscription.isYearly
                            nextBillingDate = subscription.nextBillingDate
                            notes = subscription.notes ?? ""
                            colorHex = subscription.colorHex ?? "#6C63FF"
                            isTrial = subscription.isTrial
                            usageRating = subscription.usageRating
                            paymentMethod = subscription.paymentMethod ?? "Not Set"
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
                
                // ✅ Fixed Done Button Color
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
    
    private var ratingDescription: String {
        switch usageRating {
        case 5: return "⭐️ You use this daily - Great value!"
        case 4: return "👍 You use this often - Good value"
        case 3: return "📊 You use this occasionally - Consider if needed"
        case 2: return "⚠️ You rarely use this - Might be worth cancelling"
        case 1: return "❌ You never use this - Should cancel!"
        default: return ""
        }
    }
    
    private func saveChanges() {
        guard isValid else {
            errorMessage = "Please fill in all fields correctly"
            showingError = true
            return
        }
        
        guard let costValue = costValue else {
            errorMessage = "Please enter a valid cost"
            showingError = true
            return
        }
        
        isSaving = true
        
        subscription.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        subscription.cost = costValue
        subscription.category = category
        subscription.isYearly = isYearly
        subscription.nextBillingDate = nextBillingDate
        subscription.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : notes
        subscription.colorHex = colorHex
        subscription.isTrial = isTrial
        subscription.usageRating = usageRating
        subscription.paymentMethod = paymentMethod
        
        do {
            try modelContext.save()
            isSaving = false
            generator.impactOccurred()
            isEditing = false
        } catch {
            errorMessage = "Failed to save: \(error.localizedDescription)"
            showingError = true
            isSaving = false
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

// MARK: - Detail Row
struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    var color: Color = .primary
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(.brandPrimary)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.textSecondary)
                Text(value)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(color)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
