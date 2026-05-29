//
//  AddSubscriptionView.swift
//  Spendora
//

import SwiftUI
import SwiftData

struct AddSubscriptionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var cost = ""
    @State private var selectedCategory = SubscriptionCategory.other
    @State private var isYearly = false
    @State private var nextBillingDate = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
    
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
                Section("Subscription Info") {
                    TextField("Service Name", text: $name)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                    
                    HStack {
                        Text("$")
                            .foregroundColor(.secondary)
                        TextField(isYearly ? "Yearly Cost" : "Monthly Cost", text: $cost)
                            .keyboardType(.decimalPad)
                    }
                    
                    if let monthlyEquivalent = monthlyEquivalent, isValid {
                        Text(isYearly
                             ? "Monthly equivalent: \(monthlyEquivalent, format: .currency(code: "USD"))/month"
                             : "Yearly cost: \((monthlyEquivalent * 12), format: .currency(code: "USD"))/year")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(SubscriptionCategory.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .tag(category)
                        }
                    }
                    
                    Toggle("Yearly Billing", isOn: $isYearly)
                    
                    DatePicker("Next Billing Date", selection: $nextBillingDate, in: Date()..., displayedComponents: .date)
                }
                
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
        
        let newSubscription = Subscription(
            name: name.trimmingCharacters(in: .whitespaces),
            cost: costValue,
            isYearly: isYearly,
            nextBillingDate: nextBillingDate,
            category: selectedCategory.rawValue
        )
        
        do {
            withAnimation {
                modelContext.insert(newSubscription)
            }
            
            try modelContext.save()
            
            NotificationService.shared.schedule(for: newSubscription)
            
            let fetchDescriptor = FetchDescriptor<Subscription>()
            let allSubscriptions = try? modelContext.fetch(fetchDescriptor)
            WidgetSyncService.updateSharedData(subscriptions: allSubscriptions ?? [])
            
            generator.impactOccurred()
            
            dismiss()
        } catch {
            errorMessage = "Failed to save: \(error.localizedDescription)"
            showingError = true
            isSaving = false
        }
    }
}
