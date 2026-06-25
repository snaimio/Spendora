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
    
    // Payment Method
    @State private var selectedPaymentMethod: PaymentMethod = .creditCard
    
    // Tags
    @State private var tagsInput = ""
    @State private var tags: [String] = []
    
    // Color Picker
    @State private var selectedColor: Color = .brandPrimary
    
    // Notes
    @State private var notes = ""
    
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
                // MARK: - Quick Select Presets
                Section("Quick Select") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(SubscriptionPreset.all) { preset in
                                Button {
                                    fillFromPreset(preset)
                                } label: {
                                    VStack(spacing: 8) {
                                        ZStack {
                                            Circle()
                                                .fill(preset.color.opacity(0.2))
                                                .frame(width: 60, height: 60)
                                            
                                            Image(systemName: preset.systemIcon)
                                                .font(.title2)
                                                .foregroundColor(preset.color)
                                        }
                                        
                                        Text(preset.name)
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
                                    .frame(width: 70)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
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
                    
                    // Category
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
                    
                    // Color Picker
                    ColorPicker("Subscription Color", selection: $selectedColor, supportsOpacity: false)
                    
                    // Payment Method
                    Picker("Payment Method", selection: $selectedPaymentMethod) {
                        ForEach(PaymentMethod.allCases, id: \.self) { method in
                            Text(method.rawValue).tag(method)
                        }
                    }
                    
                    Toggle("Yearly Billing", isOn: $isYearly)
                    
                    DatePicker("Next Billing Date", selection: $nextBillingDate, in: Date()..., displayedComponents: .date)
                }
                
                // MARK: - Tags
                Section("Tags") {
                    TextField("Add tags (comma separated)", text: $tagsInput)
                        .onChange(of: tagsInput) { _, newValue in
                            tags = newValue.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
                        }
                    
                    if !tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(tags, id: \.self) { tag in
                                    Text("#\(tag)")
                                        .font(.caption)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(Color.brandPrimary.opacity(0.1))
                                        .foregroundColor(.brandPrimary)
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
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
                
                // MARK: - Notes
                Section("Notes") {
                    TextField("Add notes (optional)", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
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
    
    private func fillFromPreset(_ preset: SubscriptionPreset) {
        name = preset.name
        selectedCategory = SubscriptionCategory(rawValue: preset.category) ?? .other
        selectedColor = preset.color
        generator.impactOccurred()
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
            notes: notes.isEmpty ? nil : notes,
            isTrial: isTrial,
            trialEndDate: isTrial ? trialEndDate : nil,
            expectedPrice: expectedPriceValue,
            priceAlertEnabled: priceAlertEnabled,
            customCategory: customCat,
            paymentMethod: selectedPaymentMethod.rawValue,
            tags: tags.isEmpty ? nil : tags,
            colorHex: selectedColor.toHex()
        )
        
        modelContext.insert(newSubscription)
        
        do {
            try modelContext.save()
            
            NotificationService.shared.schedule(for: newSubscription)
            
            if isTrial {
                NotificationService.shared.scheduleTrialReminder(for: newSubscription)
            }
            
            generator.impactOccurred()
            
            NotificationCenter.default.post(name: NSNotification.Name("SubscriptionAdded"), object: nil)
            
            dismiss()
        } catch {
            errorMessage = "Failed to save: \(error.localizedDescription)"
            showingError = true
            isSaving = false
        }
    }
}

extension Color {
    func toHex() -> String {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return String(format: "%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
    }
}
