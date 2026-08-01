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
    @State private var isOneTime = false
    @State private var linkURL = ""
    @State private var nextBillingDate = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
    @State private var selectedColorHex = "#6C63FF"
    @State private var notes = ""
    @State private var selectedPaymentMethod: PaymentMethod = .creditCard
    @State private var reminderDaysBefore = 3
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var isSaving = false
    @State private var showingQuickAddSheet = false
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    private let colorOptions = AddSubscriptionColorOptions.all
    
    // MARK: - Computed Properties
    var costValue: Double? {
        let sanitized = cost.replacingOccurrences(of: ",", with: ".").trimmingCharacters(in: .whitespacesAndNewlines)
        return Double(sanitized)
    }
    
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (costValue ?? 0) > 0
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    AddSubscriptionHeaderView()
                    
                    // Popular Providers Preset Selector
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Popular Providers")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                            Spacer()
                            Button {
                                generator.impactOccurred()
                                showingQuickAddSheet = true
                            } label: {
                                Text("See All")
                                    .font(.system(.subheadline, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(.brandPrimary)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(SubscriptionPreset.all.prefix(15)) { preset in
                                    Button {
                                        generator.impactOccurred()
                                        applyPreset(preset)
                                    } label: {
                                        HStack(spacing: 8) {
                                            ZStack {
                                                Circle()
                                                    .fill(preset.color.opacity(0.16))
                                                    .frame(width: 28, height: 28)
                                                
                                                Image(systemName: preset.systemIcon)
                                                    .foregroundColor(preset.color)
                                                    .font(.system(size: 13, weight: .semibold))
                                            }
                                            
                                            Text(preset.name)
                                                .font(.system(.subheadline, design: .rounded))
                                                .fontWeight(.semibold)
                                                .foregroundColor(.primary)
                                        }
                                        .padding(.leading, 6)
                                        .padding(.trailing, 14)
                                        .padding(.vertical, 8)
                                        .background(Color.cardBackground)
                                        .cornerRadius(14)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(name == preset.name ? preset.color : Color.secondary.opacity(0.12), lineWidth: name == preset.name ? 2 : 1)
                                        )
                                        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    
                    AddSubscriptionFormView(
                        name: $name,
                        cost: $cost,
                        selectedCategory: $selectedCategory,
                        isYearly: $isYearly,
                        isOneTime: $isOneTime,
                        linkURL: $linkURL,
                        nextBillingDate: $nextBillingDate,
                        selectedPaymentMethod: $selectedPaymentMethod,
                        reminderDaysBefore: $reminderDaysBefore
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
            .background(Color.appBackground.ignoresSafeArea())
            .sheet(isPresented: $showingQuickAddSheet) {
                QuickAddView { preset in
                    applyPreset(preset)
                }
            }
            .navigationTitle("Add Subscription")
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
    
    // MARK: - Preset Helper
    private func applyPreset(_ preset: SubscriptionPreset) {
        name = preset.name
        selectedCategory = preset.category
        selectedColorHex = preset.colorHex
        linkURL = "" // Keep empty so faded example placeholder is shown
    }
    
    // MARK: - Save Function
    private func saveSubscription() {
        guard isValid else {
            errorMessage = "Please enter a valid subscription name and price."
            showingError = true
            return
        }
        
        guard let costValue = costValue else {
            errorMessage = "Please enter a valid numeric cost."
            showingError = true
            return
        }
        
        isSaving = true
        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        var trimmedLink = linkURL.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // If user left link blank, auto-resolve direct management link for known services (e.g. GitHub, ChatGPT, Netflix)
        if trimmedLink.isEmpty, let resolvedURL = CancellationService.shared.getDirectCancellationURL(for: name.trimmingCharacters(in: .whitespacesAndNewlines))?.absoluteString {
            trimmedLink = resolvedURL
        }
        
        let newSubscription = Subscription(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            cost: costValue,
            category: selectedCategory,
            isYearly: isYearly,
            nextBillingDate: nextBillingDate,
            notes: trimmedNotes.isEmpty ? nil : trimmedNotes,
            colorHex: selectedColorHex,
            isTrial: false,
            paymentMethod: selectedPaymentMethod.rawValue,
            currency: CurrencyManager.shared.currentCurrency.code,
            reminderDaysBefore: reminderDaysBefore
        )
        newSubscription.isOneTime = isOneTime
        newSubscription.linkURL = trimmedLink.isEmpty ? nil : trimmedLink
        
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
