//
//  SubscriptionRow.swift
//  Spendora
//

import SwiftUI

// MARK: - SubscriptionRow (Apple HIG Row Component)

struct SubscriptionRow: View {

    // MARK: - Properties

    let subscription: Subscription

    private var categoryColor: Color {
        subscription.categoryEnum.color
    }

    private var categoryIcon: String {
        UniqueSubscriptionThemeHelper.resolveIcon(for: subscription)
    }

    // MARK: - Body

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Leading icon container 44x44pt (10pt radius)
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(categoryColor.opacity(0.15))
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
                    .foregroundColor(.secondary)
                
                // Row 3: Cost cardAmount in Color(.label) + Next billing date
                HStack {
                    Text(CurrencyManager.shared.format(subscription.isOneTime ? subscription.cost : subscription.monthlyCost))
                        .font(SpendoraTheme.cardAmount)
                        .foregroundColor(Color(.label))
                    
                    if !subscription.isOneTime {
                        Text("· Next: \(subscription.formattedNextBillingDate)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                
                // Row 4: Status Badge
                StatusBadgeView(daysUntil: subscription.daysUntilBilling, isCancelled: subscription.isCancelled)
                    .padding(.top, 2)
            }
        }
        .padding(SpendoraTheme.cardPadding)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous))
    }
}
