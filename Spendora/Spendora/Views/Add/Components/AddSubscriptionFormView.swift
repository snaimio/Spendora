//
//  AddSubscriptionFormView.swift
//

import SwiftUI


// MARK: - AddSubscriptionFormView

/**
 `AddSubscriptionFormView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for addsubscriptionformview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `AddSubscriptionFormView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct AddSubscriptionFormView: View {

    // MARK: - Properties

    @Binding var name: String
    @Binding var cost: String
    @Binding var selectedCategory: String
    @Binding var isYearly: Bool
    @Binding var isOneTime: Bool
    @Binding var linkURL: String
    @Binding var nextBillingDate: Date
    @Binding var selectedPaymentMethod: PaymentMethod
    @Binding var reminderDaysBefore: Int
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        VStack(spacing: 16) {
            PremiumFormField(
                icon: "sparkles",
                title: "Service Name"
            ) {
                TextField("e.g. Netflix, Spotify", text: $name)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .font(.system(.body, design: .rounded))
            }
            
            CostInputField(
                cost: $cost,
                isYearly: isYearly,
                currencySymbol: CurrencyManager.shared.currentCurrency.symbol
            )
            
            CategoryPickerView(selectedCategory: $selectedCategory)
            
            BillingCyclePickerView(isYearly: $isYearly, isOneTime: $isOneTime)
            
            PremiumFormField(
                icon: "link.circle.fill",
                title: "Manage / Website URL"
            ) {
                TextField("https://netflix.com/account", text: $linkURL)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .font(.system(.body, design: .rounded))
            }
            
            PremiumFormField(
                icon: "creditcard.circle.fill",
                title: "Payment Method"
            ) {
                Picker("Payment Method", selection: $selectedPaymentMethod) {
                    ForEach(PaymentMethod.allCases) { method in
                        Label(method.displayName, systemImage: method.icon)
                            .tag(method)
                    }
                }
                .labelsHidden()
                .tint(.brandPrimary)
            }
            
            if !isOneTime {
                PremiumFormField(
                    icon: "calendar.circle.fill",
                    title: "Next Billing"
                ) {
                    DatePicker(
                        "",
                        selection: $nextBillingDate,
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .tint(.brandPrimary)
                }
                
                ReminderPickerView(reminderDaysBefore: $reminderDaysBefore)
            }
        }
    }
}
