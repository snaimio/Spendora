//
//  SubscriptionDetailEditSection.swift
//  Spendora
//
//  Capstone 2026 - Mobile Application Development
//  Author: Sheikh Naim
//

/**
 * Main/Core Functions & Purpose:
 * SubscriptionDetailEditSection component containing input form fields (Name, Cost, Category, Payment Method, Billing Cycle, Trial End Date, Notes) when editing a subscription.
 */

import SwiftUI
import SwiftData

struct SubscriptionDetailEditSection: View {
    @Environment(\.modelContext) private var modelContext
    let subscription: Subscription
    
    @Binding var name: String
    @Binding var cost: String
    @Binding var category: String
    @Binding var paymentMethod: String
    @Binding var isYearly: Bool
    @Binding var nextBillingDate: Date
    @Binding var isTrial: Bool
    @Binding var notes: String
    @Binding var usageRating: Int
    @Binding var isSaving: Bool
    
    let isValid: Bool
    let saveChangesAction: () -> Void
    let ratingDescription: String
    
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
                
                Picker("Payment Method", selection: $paymentMethod) {
                    ForEach(PaymentMethod.allCases) { method in
                        Label(method.displayName, systemImage: method.icon)
                            .tag(method.rawValue)
                    }
                }
                
                Toggle("Yearly Billing", isOn: $isYearly)
                
                DatePicker("Next Billing Date", selection: $nextBillingDate, in: Date()..., displayedComponents: .date)
                
                Toggle("Free Trial", isOn: $isTrial)
                
                if isTrial {
                    DatePicker("Trial End Date", selection: Binding(
                        get: { subscription.trialEndDate ?? Date() },
                        set: { subscription.trialEndDate = $0 }
                    ), in: Date()..., displayedComponents: .date)
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
