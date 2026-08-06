//
//  SubscriptionRow.swift
//

import SwiftUI

// MARK: - SubscriptionRow

/**
 `SubscriptionRow` renders a single subscription row in list view with vibrant brand colors, category badges, and dynamic cost formatting.
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
        HStack(spacing: 14) {
            // Category Color Strip (Left Accent Edge)
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(rowColor)
                .frame(width: 4, height: 52)
            
            // Icon Badge Container
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
            
            // Middle Details: Name, Category, Date
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 6) {
                    Text(subscription.displayName)
                        .font(AppStyles.Typography.body)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    Spacer()
                    
                    CountdownChip(daysRemaining: subscription.daysUntilBilling)
                }
                
                HStack(spacing: 5) {
                    Text(CurrencyManager.shared.format(subscription.isOneTime ? subscription.cost : subscription.monthlyCost))
                        .font(.system(size: 17, weight: .heavy, design: .rounded))
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    if subscription.isOneTime {
                        Text("• Lifetime")
                            .font(AppStyles.Typography.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.brandPurple)
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
                
                if !subscription.isOneTime {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.textSecondary)
                        
                        Text("Next: \(subscription.formattedNextBillingDate)")
                            .font(AppStyles.Typography.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.textSecondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    }
                } else {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.brandTertiary)
                        
                        Text("One-Time Purchase")
                            .font(AppStyles.Typography.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.brandTertiary)
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            // Clickable Chevron Indicator
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.textSecondary)
                .padding(.leading, 2)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            ZStack {
                Color.cardBackground
                LinearGradient(
                    colors: [rowColor.opacity(0.12), rowColor.opacity(0.03)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        )
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(rowColor.opacity(0.22), lineWidth: 1)
        )
    }
}
