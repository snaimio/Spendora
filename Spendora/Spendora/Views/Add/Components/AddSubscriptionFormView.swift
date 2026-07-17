//
//  AddSubscriptionFormView.swift
//  Spendora
//

import SwiftUI

struct AddSubscriptionFormView: View {
    @Binding var name: String
    @Binding var cost: String
    @Binding var selectedCategory: String
    @Binding var isYearly: Bool
    @Binding var nextBillingDate: Date
    @Binding var selectedPaymentMethod: PaymentMethod
    
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
            
            BillingCyclePickerView(isYearly: $isYearly)
            
            PremiumFormField(
                icon: "calendar.circle.fill",
                title: "Next Billing"
            ) {
                DatePicker(
                    "",
                    selection: $nextBillingDate,
                    in: Date()...,
                    displayedComponents: .date
                )
                .labelsHidden()
                .datePickerStyle(.compact)
            }
        }
    }
}
