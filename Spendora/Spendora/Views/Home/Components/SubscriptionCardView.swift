//
//  SubscriptionCardView.swift
//

import SwiftUI

// MARK: - SubscriptionCardView

/**
 `SubscriptionCardView` renders a single subscription card with vibrant brand colors, rounded 20pt glass containers, and glowing icon circles.
 */
struct SubscriptionCardView: View {

    // MARK: - Properties

    let subscription: Subscription

    // MARK: - Body

    var body: some View {
        HStack(spacing: 14) {
            // Category Color Strip (Left Accent Edge)
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(cardColor)
                .frame(width: 4, height: 52)
            
            // App / Service Icon Badge Container
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [cardColor, cardColor.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                    .shadow(color: cardColor.opacity(0.35), radius: 6, x: 0, y: 3)
                
                Image(systemName: cardIcon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(width: 48)
            
            // Middle Details: Name, Price, Date
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
            
            // Clickable Chevron Indicator to Detail & Edit Sheet
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
                    colors: [cardColor.opacity(0.12), cardColor.opacity(0.03)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        )
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(cardColor.opacity(0.22), lineWidth: 1)
        )
    }
    
    // MARK: - Dynamic Icon & Color Resolvers
    private var cardIcon: String {
        UniqueSubscriptionThemeHelper.resolveIcon(for: subscription)
    }
    
    private var cardColor: Color {
        UniqueSubscriptionThemeHelper.resolveColor(for: subscription)
    }
}
