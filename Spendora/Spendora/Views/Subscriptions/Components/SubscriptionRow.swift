//
//  SubscriptionRow.swift
//  Spendora
//

import SwiftUI

// MARK: - SubscriptionRow (Apple Level Design)

/**
 `SubscriptionRow` renders a subscription list row matching Apple's HIG specifications:
 - Name: 20pt Semibold (LARGEST text on card)
 - Category & Cycle: 15pt Regular
 - Price: 15pt-17pt Semibold with .monospacedDigit()
 - Status Badge: Dedicated NEW ROW
 - Corner Radius: 14pt
 */
struct SubscriptionRow: View {

    // MARK: - Properties

    let subscription: Subscription

    private var rowColor: Color {
        subscription.categoryEnum.color
    }

    private var rowIcon: String {
        UniqueSubscriptionThemeHelper.resolveIcon(for: subscription)
    }

    // MARK: - Body

    var body: some View {
        HStack(alignment: .top, spacing: AppStyles.Spacing.medium) {
            // Category Icon Badge Container (42x42)
            ZStack {
                Circle()
                    .fill(rowColor.opacity(0.15))
                    .frame(width: 42, height: 42)
                
                Image(systemName: rowIcon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(rowColor)
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
