//
//  SubscriptionCardView.swift
//  Spendora
//

import SwiftUI

// MARK: - SubscriptionCardView (Apple HIG Typography & Hierarchy)

/**
 `SubscriptionCardView` implements the competitor-best card hierarchy:
 - Name: 20pt Bold (LARGEST text on card!)
 - Category + Cycle: 13pt-15pt Regular
 - Price: 17pt Bold Coral (.brandSecondary)
 - Next Date: 13pt Regular
 - "Due in X days": 12pt Bold (ALWAYS ON ITS OWN DEDICATED ROW!)
 - Elevation 2 Shadow & 16pt Corner Radius
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
            // Category Circular Emblem Container (46x46)
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [cardColor, cardColor.opacity(0.75)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 46, height: 46)
                    .shadow(color: cardColor.opacity(0.35), radius: 5, x: 0, y: 2)
                
                Image(systemName: cardIcon)
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
