//
//  SubscriptionDetailViewSection.swift
//

/**
 * Main/Core Functions & Purpose:
 * SubscriptionDetailViewSection component displaying the read-only service details, billing dates,
 * cancellation status cards, provider deep-link buttons, and notes.
 */

import SwiftUI
import SwiftData


// MARK: - SubscriptionDetailViewSection

/**
 `SubscriptionDetailViewSection` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for subscriptiondetailviewsection handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `SubscriptionDetailViewSection` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct SubscriptionDetailViewSection: View {

    // MARK: - Properties

    let subscription: Subscription  // subscription property
    let name: String  // name property
    let cost: String  // cost property
    let isYearly: Bool  // isYearly property
    let category: String  // category property
    let paymentMethod: String  // paymentMethod property
    let getCancellationURL: () -> URL?  // getCancellationURL property
    @Binding var showingCancelSheet: Bool
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        Group {
            Section("Service Info") {
                DetailRow(icon: "tag.fill", title: "Name", value: name)
                DetailRow(icon: "dollarsign.circle.fill", title: "Cost", value: subscription.isOneTime ? "$\(cost) (One-Time)" : "$\(cost)/\(isYearly ? "year" : "month")")
                DetailRow(icon: "folder.fill", title: "Category", value: category)
                DetailRow(icon: PaymentMethod.from(paymentMethod).icon, title: "Payment Method", value: PaymentMethod.from(paymentMethod).displayName)
                DetailRow(icon: "repeat.circle.fill", title: "Billing Cycle", value: subscription.isOneTime ? "One-Time (Lifetime)" : (isYearly ? "Yearly" : "Monthly"))
            }
            
            Section("Billing") {
                DetailRow(icon: "calendar", title: "Next Billing Date", value: subscription.formattedNextBillingDate)
                DetailRow(icon: "clock.fill", title: "Days Until Billing", value: "\(subscription.daysUntilBilling) days")
                
                if subscription.isOverdue {
                    DetailRow(icon: "exclamationmark.triangle.fill", title: "Status", value: "Overdue")
                } else if subscription.isUpcoming {
                    DetailRow(icon: "bell.fill", title: "Status", value: "Due Soon")
                } else {
                    DetailRow(icon: "checkmark.circle.fill", title: "Status", value: "Active")
                }
            }
            
            if subscription.isCancelled {
                Section("Cancellation Status") {
                    DetailRow(icon: "checkmark.circle.fill", title: "Status", value: "Cancelled")
                    if let cancellationDate = subscription.cancellationDate {
                        DetailRow(icon: "calendar", title: "Cancelled On", value: cancellationDate.formatted(date: .abbreviated, time: .omitted))
                    }
                    if let reason = subscription.cancellationReason, !reason.isEmpty {
                        DetailRow(icon: "text.bubble.fill", title: "Reason", value: reason)
                    }
                }
            }
            
            Section {
                Button {
                    if let url = getCancellationURL() {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack {
                        Image(systemName: "safari")
                            .foregroundColor(.brandPrimary)
                        Text("Cancel on Provider Website")
                            .foregroundColor(.brandPrimary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                if !subscription.isCancelled {
                    Button {
                        showingCancelSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.orange)
                            Text("Mark as Cancelled")
                                .foregroundColor(.orange)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            } header: {
                Text("Manage Service")
            } footer: {
                Text("Tap 'Cancel on Provider Website' to cancel your subscription with the provider. Use 'Mark as Cancelled' to track it in your app.")
            }
        }
    }
}
