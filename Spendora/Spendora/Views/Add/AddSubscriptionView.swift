//
//  AddSubscriptionView.swift
//

import SwiftUI
import SwiftData


// MARK: - AddSubscriptionView

/**
 `AddSubscriptionView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for addsubscriptionview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `AddSubscriptionView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct AddSubscriptionView: View {

    // MARK: - Properties

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
    var costValue: Double? { Double(cost) }  // costValue property
    
    var isValid: Bool {  // isValid property
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
            category: selectedCategory,
            isYearly: isYearly,
            nextBillingDate: nextBillingDate,
            notes: trimmedNotes.isEmpty ? nil : trimmedNotes,
            colorHex: selectedColorHex,
            isTrial: false,
            trialEndDate: nil,
            expectedPrice: nil,
            priceAlertEnabled: false,
            usageRating: 0,
            customCategory: nil,
            paymentMethod: selectedPaymentMethod.rawValue,
            tags: nil
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

// MARK: - AddSubscriptionColorOptions

/**
 `AddSubscriptionColorOptions` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for addsubscriptioncoloroptions handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `AddSubscriptionColorOptions` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct AddSubscriptionColorOptions {

    // MARK: - Properties

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
