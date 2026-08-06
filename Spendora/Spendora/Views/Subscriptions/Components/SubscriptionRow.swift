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
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(rowColor.opacity(0.14))
                    .frame(width: 40, height: 40)
                
                Image(systemName: rowIcon)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(rowColor)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(subscription.displayName)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                HStack(spacing: 4) {
                    Text(subscription.effectiveCategory)
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundColor(.textSecondary)
                    
                    if subscription.isOneTime {
                        Text("•")
                            .foregroundColor(.textSecondary)
                        Text("Lifetime")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(.brandPurple)
                    } else if subscription.isYearly {
                        Text("•")
                            .foregroundColor(.textSecondary)
                        Text("Yearly")
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(.textSecondary)
                    }
                    
                    if subscription.isTrial && !subscription.trialConvertedToPaid {
                        Text("•")
                            .foregroundColor(.textSecondary)
                        Text("Trial")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(.brandAmber)
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(CurrencyManager.shared.format(subscription.isOneTime ? subscription.cost : subscription.monthlyCost))
                    .font(.system(size: 15, weight: .heavy, design: .rounded).monospacedDigit())
                    .foregroundColor(.brandPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                Text(subscription.isOneTime ? "one-time" : "/month")
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(.textSecondary)
            }
            .frame(minWidth: 70, alignment: .trailing)
            
            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.textTertiary)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.secondary.opacity(0.08), lineWidth: 1)
        )
    }
}
