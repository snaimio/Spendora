//
//  SubscriptionRow.swift
//  Spendora
//

import SwiftUI

// MARK: - SubscriptionRow

/**
 `SubscriptionRow` renders a subscription card matching `SubscriptionCardView`'s exact hierarchy:
 1. Subscription Name: Headline (17pt Bold) - LARGEST, PROMINENT & FULL WIDTH
 2. Cost & Cycle: Subheadline (15pt Regular)
 3. Next Billing Date: Caption (13pt Regular)
 4. Status Badge ("Due in X days" / "Paid • Xd left"): Caption2 (12pt Semibold) - ALWAYS ON A NEW ROW!
 */
struct SubscriptionRow: View {

    // MARK: - Properties

    let subscription: Subscription

    private var rowColor: Color {
        UniqueSubscriptionThemeHelper.resolveColor(for: subscription)
    }

    private var rowIcon: String {
        UniqueSubscriptionThemeHelper.resolveIcon(for: subscription)
    }

    // MARK: - Body

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            // Category Color Strip (Left Accent Edge)
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(rowColor)
                .frame(width: 4, height: 68)
            
            // Icon Badge Container (48x48pt)
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [rowColor, rowColor.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                    .shadow(color: rowColor.opacity(0.35), radius: 6, x: 0, y: 3)
                
                Image(systemName: rowIcon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(width: 48)
            
            // Card Content Stack
            VStack(alignment: .leading, spacing: 4) {
                // ROW 1: SUBSCRIPTION NAME (Headline 17pt Bold - LARGEST TEXT)
                HStack(alignment: .center) {
                    Text(subscription.displayName)
                        .font(AppStyles.Typography.headline)
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.textSecondary)
                }
                
                // ROW 2: COST & BILLING CYCLE (Subheadline 15pt Regular)
                HStack(spacing: 4) {
                    Text(CurrencyManager.shared.format(subscription.isOneTime ? subscription.cost : subscription.monthlyCost))
                        .font(AppStyles.Typography.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    if subscription.isOneTime {
                        Text("• Lifetime")
                            .font(AppStyles.Typography.subheadline)
                            .foregroundColor(.brandPurple)
                    } else {
                        Text("/month")
                            .font(AppStyles.Typography.subheadline)
                            .foregroundColor(.textSecondary)
                        
                        if subscription.isYearly {
                            Text("• Yearly")
                                .font(AppStyles.Typography.subheadline)
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
                
                // ROW 3: NEXT BILLING DATE (Caption 13pt Regular)
                if !subscription.isOneTime {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.textSecondary)
                        
                        Text("Next: \(subscription.formattedNextBillingDate)")
                            .font(AppStyles.Typography.caption)
                            .foregroundColor(.textSecondary)
                    }
                } else {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.brandSuccess)
                        
                        Text("One-Time Purchase")
                            .font(AppStyles.Typography.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.brandSuccess)
                    }
                }
                
                // ROW 4: STATUS BADGE ("Due in X Days" / "Paid • Xd left") - ALWAYS ON ITS OWN NEW ROW!
                CountdownChip(daysRemaining: subscription.daysUntilBilling)
                    .padding(.top, 2)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            ZStack {
                Color.cardBackground
                LinearGradient(
                    colors: [rowColor.opacity(0.1), rowColor.opacity(0.02)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        )
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(rowColor.opacity(0.18), lineWidth: 1)
        )
    }
}
