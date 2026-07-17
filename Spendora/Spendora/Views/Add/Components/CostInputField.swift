//
//  CostInputField.swift
//  Spendora
//

import SwiftUI

struct CostInputField: View {
    @Binding var cost: String
    let isYearly: Bool
    let currencySymbol: String
    
    var body: some View {
        PremiumFormField(
            icon: "dollarsign.circle.fill",
            title: isYearly ? "Yearly Cost" : "Monthly Cost"
        ) {
            HStack {
                Text(currencySymbol)
                    .foregroundColor(.secondary)
                    .font(.system(.body, design: .rounded))
                TextField("0.00", text: $cost)
                    .keyboardType(.decimalPad)
                    .font(.system(.body, design: .rounded))
            }
        }
    }
}
