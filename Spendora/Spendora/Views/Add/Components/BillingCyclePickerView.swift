//
//  BillingCyclePickerView.swift
//

import SwiftUI

// MARK: - BillingCycleType Enum

enum BillingCycleType: String, CaseIterable, Identifiable {
    case monthly = "Monthly"
    case yearly = "Yearly"
    case oneTime = "One-Time"

    var id: String { rawValue }
}

// MARK: - BillingCyclePickerView

struct BillingCyclePickerView: View {
    @Binding var isYearly: Bool
    @Binding var isOneTime: Bool

    var selectedCycle: BillingCycleType {
        if isOneTime { return .oneTime }
        return isYearly ? .yearly : .monthly
    }

    var body: some View {
        PremiumFormField(
            icon: "repeat.circle.fill",
            title: "Billing Cycle",
            iconColor: .brandPrimary
        ) {
            Picker("", selection: Binding(
                get: { selectedCycle },
                set: { newCycle in
                    switch newCycle {
                    case .monthly:
                        isYearly = false
                        isOneTime = false
                    case .yearly:
                        isYearly = true
                        isOneTime = false
                    case .oneTime:
                        isYearly = false
                        isOneTime = true
                    }
                }
            )) {
                ForEach(BillingCycleType.allCases) { cycle in
                    Text(cycle.rawValue).tag(cycle)
                }
            }
            .pickerStyle(.segmented)
            .tint(.brandPrimary)
            .frame(maxWidth: 240)
        }
    }
}
