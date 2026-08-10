//
//  SubscriptionDetailViewSection.swift
//  Spendora
//

import SwiftUI
import SwiftData

// MARK: - SubscriptionDetailViewSection

/**
 `SubscriptionDetailViewSection` displays service details, hero gradient badge, billing dates,
 provider direct management, and cancellation actions with Spendora's 60-30-10 color hierarchy.
 */
struct SubscriptionDetailViewSection: View {

    // MARK: - Properties

    let subscription: Subscription
    let name: String
    let cost: String
    let isYearly: Bool
    let category: String
    let paymentMethod: String
    let getCancellationURL: () -> URL?
    @Binding var showingCancelSheet: Bool

    private var categoryColor: Color {
        subscription.categoryEnum.color
    }

    private var categoryIcon: String {
        UniqueSubscriptionThemeHelper.resolveIcon(for: subscription)
    }

    // MARK: - Body

    var body: some View {
        Group {
            // Hero Service Emblem Header Card
            Section {
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [categoryColor, categoryColor.opacity(0.75)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 72, height: 72)
                            .shadow(color: categoryColor.opacity(0.4), radius: 10, x: 0, y: 4)
                        
                        Image(systemName: categoryIcon)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    VStack(spacing: 4) {
                        Text(name)
                            .font(AppStyles.Typography.title)
                            .foregroundColor(.textPrimary)
                        
                        Text(subscription.isOneTime ? "\(CurrencyManager.shared.format(subscription.cost)) • One-Time" : "\(CurrencyManager.shared.format(subscription.monthlyCost))/month")
                            .font(Font.system(size: 18, weight: .semibold, design: .default).monospacedDigit())
                            .foregroundColor(.textPrimary)
                    }
                    
                    // Usage Stars Rating Display
                    HStack(spacing: 4) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= subscription.usageRating ? "star.fill" : "star")
                                .font(.system(size: 14))
                                .foregroundColor(star <= subscription.usageRating ? .yellow : .secondary.opacity(0.3))
                        }
                    }
                    .padding(.top, 2)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            .listRowBackground(Color.clear)
            
            Section("Service Info") {
                DetailRow(icon: "tag.fill", title: "Name", value: name)
                DetailRow(icon: "dollarsign.circle.fill", title: "Cost", value: subscription.isOneTime ? "\(CurrencyManager.shared.format(subscription.cost)) (One-Time)" : "\(CurrencyManager.shared.format(subscription.cost))/\(isYearly ? "year" : "month")")
                DetailRow(icon: "folder.fill", title: "Category", value: category)
                DetailRow(icon: PaymentMethod.from(paymentMethod).icon, title: "Payment Method", value: PaymentMethod.from(paymentMethod).displayName)
                DetailRow(icon: "repeat.circle.fill", title: "Billing Cycle", value: subscription.isOneTime ? "One-Time (Lifetime)" : (isYearly ? "Yearly" : "Monthly"))
            }
            
            Section("Billing") {
                DetailRow(icon: "calendar", title: "Next Billing Date", value: subscription.formattedNextBillingDate)
                DetailRow(icon: "clock.fill", title: "Days Until Billing", value: "\(subscription.daysUntilBilling) days")
                
                if !subscription.isOneTime {
                    HStack {
                        Image(systemName: "creditcard.circle.fill")
                            .foregroundColor(.brandPrimary)
                        Text("Record Payment")
                            .font(AppStyles.Typography.body)
                            .foregroundColor(.textPrimary)
                        Spacer()
                        MarkAsPaidButton(subscription: subscription)
                    }
                    .padding(.vertical, 2)
                }
                
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
                            .foregroundColor(.textTertiary)
                    }
                }
                
                if subscription.isCancelled {
                    Button {
                        subscription.isCancelled = false
                        subscription.cancellationDate = nil
                        subscription.cancellationReason = nil
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.brandPrimary)
                            Text("Reactivate Subscription")
                                .font(AppStyles.Typography.body)
                                .fontWeight(.bold)
                                .foregroundColor(.brandPrimary)
                            Spacer()
                        }
                    }
                } else {
                    Button {
                        showingCancelSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.brandSecondary)
                            Text("Mark as Cancelled")
                                .foregroundColor(.brandSecondary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.textTertiary)
                        }
                    }
                }
            } header: {
                Text("Manage Service")
            } footer: {
                Text(subscription.isCancelled ? "Tap 'Reactivate Subscription' to restore this membership back to active status." : "Tap 'Cancel on Provider Website' to cancel your subscription with the provider. Use 'Mark as Cancelled' to track it in your app.")
            }
        }
    }
}
