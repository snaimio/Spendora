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
    @State private var showingCancelSheet = false
    
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
        Section("Service Info") {
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
                    Text(category.rawValue).tag(category.rawValue)
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
    }
    
    // MARK: - View Mode Content
    @ViewBuilder
    private var viewModeContent: some View {
        Section("Service Info") {
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
                DetailRow(icon: "exclamationmark.triangle.fill", title: "Status", value: "Overdue")
            } else if subscription.isUpcoming {
                DetailRow(icon: "bell.fill", title: "Status", value: "Due Soon")
            } else {
                DetailRow(icon: "checkmark.circle.fill", title: "Status", value: "Active")
            }
        }
        
        // MARK: - Cancellation Status
        if subscription.isCancelled {
            Section("Cancellation Status") {
                DetailRow(icon: "checkmark.circle.fill", title: "Status", value: "Cancelled")
                if let cancellationDate = subscription.cancellationDate {
                    DetailRow(icon: "calendar", title: "Cancelled On", value: cancellationDate.formatted(date: .abbreviated, time: .omitted))
                }
                if let reason = subscription.cancellationReason, !reason.isEmpty {
                    DetailRow(icon: "text.bubble.fill", title: "Reason", value: reason)
                }
            }
        }
        
        // MARK: - Manage Service
        Section {
            // Cancel on Provider Website
            Button {
                if let url = getCancellationURL() {
                    UIApplication.shared.open(url)
                }
            } label: {
                HStack {
                    Image(systemName: "safari")
                        .foregroundColor(.brandPrimary)
                    Text("Cancel on Provider Website")
                        .foregroundColor(.brandPrimary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Mark as Cancelled
            if !subscription.isCancelled {
                Button {
                    showingCancelSheet = true
                } label: {
                    HStack {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.orange)
                        Text("Mark as Cancelled")
                            .foregroundColor(.orange)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        } header: {
            Text("Manage Service")
        } footer: {
            Text("Tap 'Cancel on Provider Website' to cancel your subscription with the provider. Use 'Mark as Cancelled' to track it in your app.")
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
                    DetailRow(icon: "exclamationmark.triangle.fill", title: "Warning", value: "Trial ending soon!")
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
    
    // MARK: - Helper Functions
    
    private func getCancellationURL() -> URL? {
        let lowercased = subscription.displayName.lowercased()
        var urlString: String?
        
        // Entertainment
        if lowercased.contains("netflix") {
            urlString = "https://www.netflix.com/cancelplan"
        } else if lowercased.contains("spotify") {
            urlString = "https://www.spotify.com/account/cancel/"
        } else if lowercased.contains("apple") && lowercased.contains("music") {
            urlString = "https://appleid.apple.com/account/manage"
        } else if lowercased.contains("disney") || lowercased.contains("disney+") {
            urlString = "https://www.disneyplus.com/subscription"
        } else if lowercased.contains("hulu") {
            urlString = "https://help.hulu.com/account/cancel"
        } else if lowercased.contains("youtube") || lowercased.contains("youtube premium") {
            urlString = "https://www.youtube.com/paid_memberships"
        } else if lowercased.contains("hbo") || lowercased.contains("max") || lowercased.contains("hbomax") {
            urlString = "https://www.max.com/account"
        } else if lowercased.contains("peacock") {
            urlString = "https://www.peacocktv.com/account"
        } else if lowercased.contains("paramount") || lowercased.contains("paramount+") {
            urlString = "https://www.paramountplus.com/account/"
        } else if lowercased.contains("starz") {
            urlString = "https://www.starz.com/account"
        } else if lowercased.contains("showtime") {
            urlString = "https://www.showtime.com/account"
        } else if lowercased.contains("crunchyroll") {
            urlString = "https://www.crunchyroll.com/account"
        } else if lowercased.contains("audible") {
            urlString = "https://www.audible.com/account"
        }
        // Shopping
        else if lowercased.contains("amazon") || lowercased.contains("prime") {
            urlString = "https://www.amazon.com/gp/css/account/manageprime"
        }
        // Productivity
        else if lowercased.contains("microsoft") || lowercased.contains("office") || lowercased.contains("office365") {
            urlString = "https://account.microsoft.com/services"
        } else if lowercased.contains("google") || lowercased.contains("google workspace") {
            urlString = "https://admin.google.com"
        } else if lowercased.contains("dropbox") {
            urlString = "https://www.dropbox.com/account/plan"
        } else if lowercased.contains("notion") {
            urlString = "https://www.notion.so/settings/plans"
        } else if lowercased.contains("slack") {
            urlString = "https://slack.com/account"
        } else if lowercased.contains("zoom") {
            urlString = "https://zoom.us/account"
        } else if lowercased.contains("figma") {
            urlString = "https://www.figma.com/account"
        }
        // Health & Fitness
        else if lowercased.contains("fitbit") {
            urlString = "https://www.fitbit.com/settings/subscription"
        } else if lowercased.contains("myfitnesspal") {
            urlString = "https://www.myfitnesspal.com/account/subscription"
        } else if lowercased.contains("headspace") {
            urlString = "https://www.headspace.com/account"
        } else if lowercased.contains("calm") {
            urlString = "https://www.calm.com/account"
        } else if lowercased.contains("peloton") {
            urlString = "https://www.peloton.com/account"
        }
        // Food
        else if lowercased.contains("hellofresh") {
            urlString = "https://www.hellofresh.com/account/cancel"
        } else if lowercased.contains("blue apron") {
            urlString = "https://www.blueapron.com/account"
        }
        // Design & Creative
        else if lowercased.contains("adobe") || lowercased.contains("creative cloud") {
            urlString = "https://account.adobe.com/plans"
        } else if lowercased.contains("canva") {
            urlString = "https://www.canva.com/account"
        }
        // Gaming
        else if lowercased.contains("playstation") || lowercased.contains("playstation plus") {
            urlString = "https://www.playstation.com/account"
        } else if lowercased.contains("xbox") || lowercased.contains("xbox game pass") {
            urlString = "https://account.microsoft.com/services"
        } else if lowercased.contains("nintendo") {
            urlString = "https://accounts.nintendo.com"
        }
        // If no match, try a general search URL
        else {
            let searchQuery = subscription.displayName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            urlString = "https://www.google.com/search?q=\(searchQuery)+cancel+subscription"
        }
        
        guard let urlString = urlString else { return nil }
        return URL(string: urlString)
    }
    
    private func resetValues() {
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
    
    private var ratingDescription: String {
        switch usageRating {
        case 5: return "You use this daily - Great value!"
        case 4: return "You use this often - Good value"
        case 3: return "You use this occasionally - Consider if needed"
        case 2: return "You rarely use this - Might be worth cancelling"
        case 1: return "You never use this - Should cancel!"
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
                    .foregroundColor(.textPrimary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
