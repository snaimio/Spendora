//
//  SubscriptionRow.swift
//  Spendora
//

import SwiftUI

// MARK: - SubscriptionRow

/**
 `SubscriptionRow` renders a subscription card matching `SubscriptionCardView`'s Spendora Teal brand typography and color hierarchy.
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
        HStack(alignment: .top, spacing: 14) {
            // Category Circular Emblem Badge Container (46x46pt)
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
            
            // Card Content Stack
            VStack(alignment: .leading, spacing: 4) {
                // ROW 1: SUBSCRIPTION NAME
                HStack(alignment: .center) {
                    Text(subscription.displayName)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.textSecondary)
                }
                
                // ROW 2: PRICE & BILLING CYCLE (Coral #FF6B6B)
                HStack(spacing: 4) {
                    Text(CurrencyManager.shared.format(subscription.isOneTime ? subscription.cost : subscription.monthlyCost))
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#FF6B6B"))
                    
                    if subscription.isOneTime {
                        Text("• Lifetime")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(hex: "#FFD93D"))
                    } else {
                        Text("/month")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(.textSecondary)
                        
                        if subscription.isYearly {
                            Text("• Yearly")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
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
                            .font(.system(size: 13, weight: .regular, design: .rounded))
                            .foregroundColor(.textSecondary)
                    }
                } else {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(hex: "#00D4AA"))
                        
                        Text("One-Time Purchase")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#00D4AA"))
                    }
                }
                
                // ROW 4: STATUS BADGE
                CountdownChip(daysRemaining: subscription.daysUntilBilling, isCancelled: subscription.isCancelled)
                    .padding(.top, 2)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .spendora3DCard(cornerRadius: 18)
    }
}
