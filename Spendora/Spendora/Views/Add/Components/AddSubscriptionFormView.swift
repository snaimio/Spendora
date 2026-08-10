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
    @Binding var isUserEditedLink: Bool
    @Binding var nextBillingDate: Date
    @Binding var selectedPaymentMethod: PaymentMethod
    @Binding var reminderDaysBefore: Int
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        VStack(spacing: 16) {
            PremiumFormField(
                icon: "sparkles",
                title: "Service Name",
                iconColor: .brandPurple
            ) {
                TextField("e.g. Netflix, Spotify, GitHub", text: $name)
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
                title: "Manage & Cancel Link",
                iconColor: .brandAccent
            ) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        TextField(text: $linkURL, prompt: Text("https://provider.com/account").foregroundColor(.secondary)) {
                            Text("Manage & Cancel Link")
                        }
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(SpendoraTheme.accent)
                        .tint(SpendoraTheme.accent)
                        .onChange(of: linkURL) { _, newValue in
                            if !newValue.isEmpty {
                                isUserEditedLink = true
                            }
                        }
                        
                        if !linkURL.isEmpty {
                            Button {
                                linkURL = ""
                                isUserEditedLink = true
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                        }
                    }
                    
                    if !linkURL.isEmpty && !isUserEditedLink {
                        HStack(spacing: 3) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 9))
                                .foregroundColor(.secondary)
                            Text("Auto-linked 1-tap cancellation portal")
                                .font(.system(size: 10, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                    } else {
                        Text("Auto-links official cancellation portal when typing service name")
                            .font(.system(size: 10, design: .rounded))
                            .foregroundColor(.secondary.opacity(0.8))
                    }
                }
            }
            
            PremiumFormField(
                icon: "creditcard.circle.fill",
                title: "Payment Method",
                iconColor: .brandAmber
            ) {
                Picker("Payment Method", selection: $selectedPaymentMethod) {
                    ForEach(PaymentMethod.allCases) { method in
                        Label(method.displayName, systemImage: method.icon)
                            .tag(method)
                    }
                }
                .labelsHidden()
                .tint(Color(.label))
            }
            
            if !isOneTime {
                PremiumFormField(
                    icon: "calendar.circle.fill",
                    title: "Next Billing",
                    iconColor: .brandTertiary
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
