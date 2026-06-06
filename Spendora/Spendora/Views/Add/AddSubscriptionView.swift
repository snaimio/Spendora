//
//  AddSubscriptionView.swift
//  Spendora
//

import SwiftUI
import SwiftData

struct AddSubscriptionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // Basic Info
    @State private var name = ""
    @State private var cost = ""
    @State private var selectedCategory = SubscriptionCategory.other
    @State private var isYearly = false
    @State private var nextBillingDate = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
    
    // Free Trial
    @State private var isTrial = false
    @State private var trialEndDate = Calendar.current.date(byAdding: .day, value: 14, to: Date()) ?? Date()
    
    // Price Alert
    @State private var priceAlertEnabled = false
    @State private var expectedPrice = ""
    
    // Custom Category
    @State private var isCustomCategory = false
    @State private var customCategoryName = ""
    
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var isSaving = false
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    var monthlyEquivalent: Double? {
        guard let costValue = Double(cost), costValue > 0 else { return nil }
        return isYearly ? costValue / 12 : costValue
    }
    
    var isValid: Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return false }
        guard let costValue = Double(cost), costValue > 0 else { return false }
        guard nextBillingDate > Date() else { return false }
        return true
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Subscription Info
                Section("Subscription Info") {
                    TextField("Service Name", text: $name)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                    
                    HStack {
                        Text(CurrencyManager.shared.currentCurrency.symbol)
                            .foregroundColor(.secondary)
                        TextField(isYearly ? "Yearly Cost" : "Monthly Cost", text: $cost)
                            .keyboardType(.decimalPad)
                    }
                    
                    if let monthlyEquivalent = monthlyEquivalent, isValid {
                        Text(isYearly
                             ? "Monthly equivalent: \(CurrencyManager.shared.format(monthlyEquivalent))/month"
                             : "Yearly cost: \(CurrencyManager.shared.format(monthlyEquivalent * 12))/year")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Category Selection (Standard or Custom)
                    if isCustomCategory {
                        TextField("Custom Category Name", text: $customCategoryName)
                            .textInputAutocapitalization(.words)
                        
                        Button("Use Standard Categories") {
                            isCustomCategory = false
                            customCategoryName = ""
                        }
                        .font(.caption)
                    } else {
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(SubscriptionCategory.allCases, id: \.self) { category in
                                Label(category.rawValue, systemImage: category.icon)
                                    .tag(category)
                            }
                        }
                        
                        Button("Add Custom Category") {
                            isCustomCategory = true
                        }
                        .font(.caption)
                    }
                    
                    Toggle("Yearly Billing", isOn: $isYearly)
                    
                    DatePicker("Next Billing Date", selection: $nextBillingDate, in: Date()..., displayedComponents: .date)
                }
                
                // MARK: - Free Trial
                Section("Free Trial") {
                    Toggle("This is a free trial", isOn: $isTrial)
                    
                    if isTrial {
                        DatePicker("Trial End Date", selection: $trialEndDate, in: Date()..., displayedComponents: .date)
                        
                        Text("Will convert to \(isYearly ? "yearly" : "monthly") billing on \(trialEndDate.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                
                // MARK: - Price Alert
                Section("Price Alert") {
                    Toggle("Alert if price increases", isOn: $priceAlertEnabled)
                    
                    if priceAlertEnabled {
                        HStack {
                            Text("Expected price:")
                            TextField("Amount", text: $expectedPrice)
                                .keyboardType(.decimalPad)
                                .frame(width: 100)
                            Text("per \(isYearly ? "year" : "month")")
                                .font(.caption)
                        }
                    }
                }
                
                // MARK: - Save Button
                Section {
                    Button(action: saveSubscription) {
                        if isSaving {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Save Subscription")
                                .frame(maxWidth: .infinity)
                                .fontWeight(.semibold)
                        }
                    }
                    .disabled(!isValid || isSaving)
                }
            }
            .navigationTitle("Add Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func saveSubscription() {
        guard isValid else {
            errorMessage = "Please fill in all fields correctly"
            showingError = true
            return
        }
        
        guard let costValue = Double(cost) else {
            errorMessage = "Please enter a valid cost"
            showingError = true
            return
        }
        
        isSaving = true
        
        let expectedPriceValue = priceAlertEnabled ? Double(expectedPrice) : nil
        let finalCategory: String
        let customCat: String?
        
        if isCustomCategory && !customCategoryName.isEmpty {
            finalCategory = customCategoryName
            customCat = customCategoryName
        } else {
            finalCategory = selectedCategory.rawValue
            customCat = nil
        }
        
        let newSubscription = Subscription(
            name: name.trimmingCharacters(in: .whitespaces),
            cost: costValue,
            isYearly: isYearly,
            nextBillingDate: nextBillingDate,
            category: finalCategory,
            isTrial: isTrial,
            trialEndDate: isTrial ? trialEndDate : nil,
            expectedPrice: expectedPriceValue,
            priceAlertEnabled: priceAlertEnabled,
            customCategory: customCat
        )
        
        do {
            modelContext.insert(newSubscription)
            try modelContext.save()
            
            // Schedule regular notification
            NotificationService.shared.schedule(for: newSubscription)
            
            // Schedule trial notification if applicable
            if isTrial {
                NotificationService.shared.scheduleTrialReminder(for: newSubscription)
            }
            
            generator.impactOccurred()
            dismiss()
        } catch {
            errorMessage = "Failed to save: \(error.localizedDescription)"
            showingError = true
            isSaving = false
        }
    }
}
