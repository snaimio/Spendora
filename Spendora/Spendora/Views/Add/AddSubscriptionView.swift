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
    @State private var selectedCategory: String = SubscriptionCategory.other.rawValue
    @State private var isYearly = false
    @State private var nextBillingDate = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
    @State private var selectedColorHex = "#6C63FF"
    @State private var notes = ""
    @State private var selectedPaymentMethod: PaymentMethod = .creditCard
    
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var isSaving = false
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - Color Options
    let colorOptions: [(name: String, hex: String)] = [
        ("Purple", "#6C63FF"),
        ("Blue", "#007AFF"),
        ("Red", "#FF3B30"),
        ("Orange", "#FF9500"),
        ("Yellow", "#FFCC00"),
        ("Green", "#34C759"),
        ("Teal", "#5AC8FA"),
        ("Pink", "#FF2D55")
    ]
    
    // MARK: - Computed Properties
    var costValue: Double? {
        Double(cost)
    }
    
    var monthlyEquivalent: Double? {
        guard let costValue = costValue, costValue > 0 else { return nil }
        return isYearly ? costValue / 12 : costValue
    }
    
    var isValid: Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return false }
        guard let costValue = costValue, costValue > 0 else { return false }
        guard nextBillingDate > Date() else { return false }
        return true
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Subscription Info
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
                             ? "Monthly equivalent: $\(String(format: "%.2f", monthlyEquivalent))/month"
                             : "Yearly cost: $\(String(format: "%.2f", monthlyEquivalent * 12))/year")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Category Picker
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(SubscriptionCategory.allCases, id: \.rawValue) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .tag(category.rawValue)
                        }
                    }
                    
                    // Color Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Color")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 8) {
                            ForEach(colorOptions, id: \.hex) { color in
                                Circle()
                                    .fill(Color(hex: color.hex))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Circle()
                                            .stroke(Color(.systemBackground), lineWidth: selectedColorHex == color.hex ? 3 : 0)
                                            .shadow(radius: 2)
                                    )
                                    .onTapGesture {
                                        selectedColorHex = color.hex
                                        generator.impactOccurred()
                                    }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                    
                    // Payment Method
                    Picker("Payment Method", selection: $selectedPaymentMethod) {
                        ForEach(PaymentMethod.allCases, id: \.self) { method in
                            Text(method.rawValue).tag(method)
                        }
                    }
                    
                    Toggle("Yearly Billing", isOn: $isYearly)
                    
                    DatePicker("Next Billing Date", selection: $nextBillingDate, in: Date()..., displayedComponents: .date)
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
                    .foregroundColor(isValid ? .brandPrimary : .gray)
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
    
    // MARK: - Save Function
    private func saveSubscription() {
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
        
        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let newSubscription = Subscription(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            cost: costValue,
            isYearly: isYearly,
            nextBillingDate: nextBillingDate,
            category: selectedCategory,
            notes: trimmedNotes.isEmpty ? nil : trimmedNotes,
            isTrial: false,
            trialEndDate: nil,
            expectedPrice: nil,
            priceAlertEnabled: false,
            customCategory: nil,
            paymentMethod: selectedPaymentMethod.rawValue,
            tags: nil,
            colorHex: selectedColorHex,
            usageRating: 0
        )
        
        modelContext.insert(newSubscription)
        
        do {
            try modelContext.save()
            isSaving = false
            
            // Schedule notification
            NotificationService.shared.schedule(for: newSubscription)
            
            generator.impactOccurred()
            
            dismiss()
        } catch {
            errorMessage = "Failed to save: \(error.localizedDescription)"
            showingError = true
            isSaving = false
        }
    }
}

// MARK: - Preview
#Preview {
    AddSubscriptionView()
}
