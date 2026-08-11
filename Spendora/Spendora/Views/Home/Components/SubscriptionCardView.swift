//
//  SubscriptionCardView.swift
//  Spendora
//

import SwiftUI
import SwiftData

// MARK: - SubscriptionCardView (Apple HIG Card Anatomy with 1-Tap Payment)

struct SubscriptionCardView: View {

    // MARK: - Properties

    let subscription: Subscription
    @Environment(\.modelContext) private var modelContext

    private var categoryColor: Color {
        subscription.isCancelled ? Color(.tertiaryLabel) : subscription.categoryEnum.color
    }

    private var iconBackground: Color {
        subscription.isCancelled ? Color(.secondarySystemFill) : subscription.categoryEnum.color.opacity(0.15)
    }

    private var categoryIcon: String {
        UniqueSubscriptionThemeHelper.resolveIcon(for: subscription)
    }

    // MARK: - Body

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Leading icon container 44x44pt (10pt radius) — Muted if cancelled
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(iconBackground)
                    .frame(width: 44, height: 44)
                
                Image(systemName: categoryIcon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(categoryColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                // Row 1: Name + Trailing Chevron
                HStack {
                    Text(subscription.displayName)
                        .font(.headline)
                        .foregroundColor(Color(.label))
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(Color(.tertiaryLabel))
                }
                
                // Row 2: Category · Billing cycle
                Text("\(subscription.effectiveCategory) · \(subscription.isOneTime ? "Lifetime" : (subscription.isYearly ? "Yearly" : "Monthly"))")
                    .font(.subheadline)
                    .foregroundColor(Color(.secondaryLabel))
                
                // Row 3: Cost cardAmount in Color(.label) + Next billing date
                HStack {
                    Text(CurrencyManager.shared.format(subscription.isOneTime ? subscription.cost : subscription.monthlyCost))
                        .font(SpendoraTheme.cardAmount)
                        .foregroundColor(Color(.label))
                    
                    if !subscription.isOneTime && !subscription.isCancelled {
                        Text("· Next: \(subscription.formattedNextBillingDate)")
                            .font(.caption)
                            .foregroundColor(Color(.secondaryLabel))
                            .lineLimit(1)
                    }
                }
                
                // Row 4: Status Badge & 1-Tap Record Payment Button
                HStack {
                    StatusBadgeView(daysUntil: subscription.daysUntilBilling, isCancelled: subscription.isCancelled)
                    
                    Spacer()
                    
                    if !subscription.isOneTime && !subscription.isCancelled {
                        MarkAsPaidButton(subscription: subscription)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(SpendoraTheme.cardPadding)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous)
                .stroke(Color(.separator), lineWidth: 0.5)
        )
        .contextMenu {
            if !subscription.isOneTime && !subscription.isCancelled {
                Button {
                    if subscription.canUndoPayment {
                        subscription.undoPayment()
                    } else {
                        subscription.markAsPaid()
                    }
                    try? modelContext.save()
                    NotificationService.shared.schedule(for: subscription)
                } label: {
                    if subscription.canUndoPayment {
                        Label("Undo Payment", systemImage: "arrow.uturn.backward.circle")
                    } else {
                        Label("Record Payment", systemImage: "creditcard.circle")
                    }
                }
            }
            
            if let link = subscription.linkURL, let url = URL(string: link) {
                Button {
                    UIApplication.shared.open(url)
                } label: {
                    Label("Manage on Website", systemImage: "safari")
                }
            }
        }
    }
}
