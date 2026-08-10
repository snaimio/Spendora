//
//  SubscriptionCardView.swift
//  Spendora
//

import SwiftUI

// MARK: - SubscriptionCardView (Apple Level Design)

/**
 `SubscriptionCardView` implements Apple's exact HIG hierarchy:
 - Name: 20pt Semibold (LARGEST text on card!)
 - Category + Cycle: 15pt Regular
 - Price: 15pt-17pt Semibold with .monospacedDigit()
 - Next date: 13pt Regular
 - "Due in X days": 11pt Semibold (ALWAYS ON ITS OWN DEDICATED NEW ROW!)
 - Elevation 1 Subtle Shadow, Hairline Border & 14pt Corner Radius
 */
struct SubscriptionCardView: View {

    // MARK: - Properties

    let subscription: Subscription

    private var cardColor: Color {
        subscription.categoryEnum.color
    }

    private var cardIcon: String {
        UniqueSubscriptionThemeHelper.resolveIcon(for: subscription)
    }

    // MARK: - Body

    var body: some View {
        HStack(alignment: .top, spacing: AppStyles.Spacing.medium) {
            // Category Icon Badge Container (42x42)
            ZStack {
                Circle()
                    .fill(cardColor.opacity(0.15))
                    .frame(width: 42, height: 42)
                
                Image(systemName: cardIcon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(cardColor)
            }
            .frame(width: 42)
            
            // Content Stack
            VStack(alignment: .leading, spacing: AppStyles.Spacing.element) {
                // ROW 1: SUBSCRIPTION NAME (LARGEST text on card - 20pt Semibold!)
                HStack(alignment: .center) {
                    Text(subscription.displayName)
                        .font(AppStyles.Typography.headline)
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.textTertiary)
                }
                
                // ROW 2: CATEGORY & BILLING CYCLE
                HStack(spacing: 4) {
                    Text(subscription.effectiveCategory)
                        .font(AppStyles.Typography.subheadline)
                        .foregroundColor(.textSecondary)
                    
                    Text("•")
                        .font(AppStyles.Typography.caption)
                        .foregroundColor(.textTertiary)
                    
                    Text(subscription.isOneTime ? "Lifetime" : (subscription.isYearly ? "Yearly" : "Monthly"))
                        .font(AppStyles.Typography.subheadline)
                        .foregroundColor(.textSecondary)
                }
                
                // ROW 3: PRICE (.monospacedDigit) & NEXT BILLING DATE
                HStack(spacing: 4) {
                    Text(CurrencyManager.shared.format(subscription.isOneTime ? subscription.cost : subscription.monthlyCost))
                        .font(Font.system(size: 15, weight: .semibold, design: .default).monospacedDigit())
                        .foregroundColor(.textPrimary)
                    
                    Text(subscription.isOneTime ? "total" : "/month")
                        .font(AppStyles.Typography.caption)
                        .foregroundColor(.textSecondary)
                    
                    if !subscription.isOneTime {
                        Text("•")
                            .font(AppStyles.Typography.caption)
                            .foregroundColor(.textTertiary)
                        
                        Text("Next: \(subscription.formattedNextBillingDate)")
                            .font(AppStyles.Typography.caption)
                            .foregroundColor(.textSecondary)
                            .lineLimit(1)
                    }
                }
                
                // ROW 4: STATUS BADGE (ALWAYS ON ITS OWN DEDICATED NEW ROW!)
                CountdownChip(daysRemaining: subscription.daysUntilBilling, isCancelled: subscription.isCancelled)
                    .padding(.top, 2)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
        .padding(AppStyles.Spacing.cardPadding)
        .appleCard(cornerRadius: AppStyles.Radius.card)
    }
}
