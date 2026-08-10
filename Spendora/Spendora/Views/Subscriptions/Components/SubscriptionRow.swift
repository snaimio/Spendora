//
//  SubscriptionRow.swift
//  Spendora
//

import SwiftUI

// MARK: - SubscriptionRow (Apple HIG Hierarchy)

/**
 `SubscriptionRow` renders a subscription list row matching `SubscriptionCardView`'s Apple HIG hierarchy:
 - Name: 20pt Bold (LARGEST text on card!)
 - Price: 17pt Bold Coral (.brandSecondary)
 - Status Badge: Dedicated NEW ROW!
 - Corner Radius: 16pt (AppStyles.Radius.card)
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
            // Category Emblem Badge Container (46x46)
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [rowColor, rowColor.opacity(0.75)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 46, height: 46)
                    .shadow(color: rowColor.opacity(0.35), radius: 5, x: 0, y: 2)
                
                Image(systemName: rowIcon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(width: 46)
            
            // Content Stack
            VStack(alignment: .leading, spacing: AppStyles.Spacing.element) {
                // ROW 1: SUBSCRIPTION NAME (LARGEST text on card - 20pt Bold!)
                HStack(alignment: .center) {
                    Text(subscription.displayName)
                        .font(AppStyles.Typography.headline)
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.textTertiary)
                }
                
                // ROW 2: PRICE & BILLING CYCLE (Price: 17pt Bold Coral Red)
                HStack(spacing: 4) {
                    Text(CurrencyManager.shared.format(subscription.isOneTime ? subscription.cost : subscription.monthlyCost))
                        .font(Font.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.brandSecondary)
                    
                    if subscription.isOneTime {
                        Text("• Lifetime")
                            .font(AppStyles.Typography.captionBold)
                            .foregroundColor(.brandAccent)
                    } else {
                        Text("/month")
                            .font(AppStyles.Typography.caption)
                            .foregroundColor(.textSecondary)
                        
                        if subscription.isYearly {
                            Text("• Yearly")
                                .font(AppStyles.Typography.caption)
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
                
                // ROW 3: NEXT BILLING DATE
                if !subscription.isOneTime {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.textSecondary)
                        
                        Text("Renewal: \(subscription.formattedNextBillingDate)")
                            .font(AppStyles.Typography.caption)
                            .foregroundColor(.textSecondary)
                            .lineLimit(1)
                    }
                } else {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.brandPrimary)
                        
                        Text("One-Time Purchase")
                            .font(AppStyles.Typography.captionBold)
                            .foregroundColor(.brandPrimary)
                    }
                }
                
                // ROW 4: STATUS BADGE (ALWAYS ON ITS OWN DEDICATED NEW ROW!)
                CountdownChip(daysRemaining: subscription.daysUntilBilling, isCancelled: subscription.isCancelled)
                    .padding(.top, 2)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, AppStyles.Spacing.cardPadding)
        .padding(.vertical, 14)
        .spendora3DCard(cornerRadius: AppStyles.Radius.card)
    }
}
