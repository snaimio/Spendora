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
        guard !trimmedName.isEmpty else {
            print("🔴 Validation failed: name is empty")
            return false
        }
        guard let costValue = Double(cost), costValue > 0 else {
            print("🔴 Validation failed: cost invalid - '\(cost)'")
            return false
        }
        guard nextBillingDate > Date() else {
            print("🔴 Validation failed: date not in future - \(nextBillingDate)")
            return false
        }
        print("🟢 Validation passed - name: \(name), cost: \(costValue), date: \(nextBillingDate)")
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
                        .onChange(of: name) { _, newValue in
                            print("Name changed to: '\(newValue)'")
                        }
                    
                    HStack {
                        Text(CurrencyManager.shared.currentCurrency.symbol)
                            .foregroundColor(.secondary)
                        TextField(isYearly ? "Yearly Cost" : "Monthly Cost", text: $cost)
                            .keyboardType(.decimalPad)
                            .onChange(of: cost) { _, newValue in
                                print("Cost changed to: '\(newValue)'")
                            }
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
                
                // MARK: - Save Button Section
                Section {
                    HStack {
                        Spacer()
                        Button {
                            print("🟡 SAVE BUTTON TAPPED")
                            saveSubscription()
                        } label: {
                            if isSaving {
                                ProgressView()
                            } else {
                                Text("Save Subscription")
                                    .fontWeight(.semibold)
                            }
                        }
                        .disabled(!isValid || isSaving)
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                        Spacer()
                    }
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
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
        print("🔵 saveSubscription called")
        print("🔵 name: \(name)")
        print("🔵 cost: \(cost)")
        print("🔵 isYearly: \(isYearly)")
        print("🔵 nextBillingDate: \(nextBillingDate)")
        
        guard isValid else {
            print("🔴 isValid failed - returning early")
            errorMessage = "Please fill in all fields correctly"
            showingError = true
            return
        }
        
        guard let costValue = Double(cost) else {
            print("🔴 cost conversion failed for: \(cost)")
            errorMessage = "Please enter a valid cost"
            showingError = true
            return
        }
        
        print("🟢 costValue: \(costValue)")
        print("🟢 selectedCategory: \(selectedCategory)")
        print("🟢 isTrial: \(isTrial)")
        print("🟢 priceAlertEnabled: \(priceAlertEnabled)")
        
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
        
        print("🟢 Subscription created: \(newSubscription.displayName)")
        
        // Insert and save
        modelContext.insert(newSubscription)
        print("🟢 Inserted into modelContext")
        
        do {
            try modelContext.save()
            print("🟢✅ Save successful!")
            
            NotificationService.shared.schedule(for: newSubscription)
            print("🟢 Notification scheduled")
            
            if isTrial {
                NotificationService.shared.scheduleTrialReminder(for: newSubscription)
                print("🟢 Trial reminder scheduled")
            }
            
            generator.impactOccurred()
            print("🟢 Haptic feedback sent")
            
            // Post notification to refresh HomeView
            NotificationCenter.default.post(name: NSNotification.Name("SubscriptionAdded"), object: nil)
            print("🟢 Refresh notification posted")
            
            dismiss()
            print("🟢 View dismissed")
        } catch {
            print("🔴❌ SAVE FAILED: \(error.localizedDescription)")
            errorMessage = "Failed to save: \(error.localizedDescription)"
            showingError = true
            isSaving = false
        }
    }
}
