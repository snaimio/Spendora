//
//  SubscriptionDetailEditSection.swift
//

/**
 * Main/Core Functions & Purpose:
 * SubscriptionDetailEditSection component containing input form fields (Name, Cost, Category, Payment Method, Billing Cycle, Trial End Date, Notes) when editing a subscription.
 */

import SwiftUI
import SwiftData


// MARK: - SubscriptionDetailEditSection

/**
 `SubscriptionDetailEditSection` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for subscriptiondetaileditsection handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `SubscriptionDetailEditSection` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct SubscriptionDetailEditSection: View {

    // MARK: - Properties

    @Environment(\.modelContext) private var modelContext
    let subscription: Subscription  // subscription property
    
    @Binding var name: String
    @Binding var cost: String
    @Binding var category: String
    @Binding var paymentMethod: String
    @Binding var isYearly: Bool
    @Binding var nextBillingDate: Date
    @Binding var reminderDaysBefore: Int
    @Binding var isTrial: Bool
    @Binding var notes: String
    @Binding var usageRating: Int
    @Binding var isSaving: Bool
    
    let isValid: Bool  // isValid property
    let saveChangesAction: () -> Void  // saveChangesAction property
    let ratingDescription: String  // ratingDescription property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        Group {
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
                .tint(.brandPrimary)
                
                Picker("Payment Method", selection: $paymentMethod) {
                    ForEach(PaymentMethod.allCases) { method in
                        Label(method.displayName, systemImage: method.icon)
                            .tag(method.rawValue)
                    }
                }
                .tint(.brandPrimary)
                
                Toggle("Yearly Billing", isOn: $isYearly)
                    .tint(.brandPrimary)
                
                DatePicker("Next Billing Date", selection: $nextBillingDate, displayedComponents: .date)
                    .tint(.brandPrimary)
                
                ReminderPickerView(reminderDaysBefore: $reminderDaysBefore)
                
                Toggle("Free Trial", isOn: $isTrial)
                    .tint(.brandPrimary)
                
                if isTrial {
                    DatePicker("Trial End Date", selection: Binding(
                        get: { subscription.trialEndDate ?? Date() },
                        set: { subscription.trialEndDate = $0 }
                    ), in: Date()..., displayedComponents: .date)
                    .tint(.brandPrimary)
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
            
            Section {
                Button {
                    saveChangesAction()
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
    }
}
