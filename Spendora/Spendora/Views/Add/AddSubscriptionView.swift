//
//  AddSubscriptionView.swift
//  Spendora
//

import SwiftUI
import SwiftData

struct AddSubscriptionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State
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
    private let colorOptions = AddSubscriptionColorOptions.all
    
    // MARK: - Computed Properties
    var costValue: Double? { Double(cost) }
    
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (costValue ?? 0) > 0 &&
        nextBillingDate > Date()
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    AddSubscriptionHeaderView()
                    
                    AddSubscriptionFormView(
                        name: $name,
                        cost: $cost,
                        selectedCategory: $selectedCategory,
                        isYearly: $isYearly,
                        nextBillingDate: $nextBillingDate,
                        selectedPaymentMethod: $selectedPaymentMethod
                    )
                    
                    AddColorSelectionView(
                        colorOptions: colorOptions,
                        selectedColorHex: $selectedColorHex,
                        generator: generator
                    )
                    
                    AddNotesView(notes: $notes)
                    
                    AddSubscriptionSaveButton(
                        isValid: isValid,
                        isSaving: isSaving,
                        action: saveSubscription
                    )
                }
                .padding(.bottom, 32)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded))
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.semibold)
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

// MARK: - Color Options
struct AddSubscriptionColorOptions {
    static let all: [(name: String, hex: String)] = [
        ("Purple", "#6C63FF"),
        ("Blue", "#007AFF"),
        ("Red", "#FF3B30"),
        ("Orange", "#FF9500"),
        ("Yellow", "#FFCC00"),
        ("Green", "#34C759"),
        ("Teal", "#5AC8FA"),
        ("Pink", "#FF2D55"),
        ("Gray", "#8E8E93")
    ]
}

// MARK: - Preview
#Preview {
    AddSubscriptionView()
}
