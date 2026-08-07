//
//  SubscriptionRow.swift
//  Spendora
//

import SwiftUI

// MARK: - SubscriptionRow

/**
 `SubscriptionRow` renders a subscription card matching `SubscriptionCardView`'s adaptive aesthetic:
 - Pure White card background in Light Mode / Machined Slate in Dark Mode (`Color.cardBackground`)
 - High-contrast text legibility in both modes (`.textPrimary` and `.textSecondary`)
 - Polished Brass Circular Icon Container with logo emblem (#D4AF37)
 - Gold Outline Accent Stroke (#D4AF37)
 - 1. Subscription Name: Headline (17pt Bold) - LARGEST, PROMINENT & FULL WIDTH
 - 2. Cost & Cycle: Subheadline (15pt Regular)
 - 3. Next Billing Date: Caption (13pt Regular)
 - 4. Status Badge ("Due in X days" / "Paid • Xd left"): Caption2 (12pt Semibold) - ALWAYS ON A NEW ROW!
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
            // Gold Circular Emblem Badge Container (46x46pt)
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#D4AF37"), Color(hex: "#B8860B")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 46, height: 46)
                    .shadow(color: Color(hex: "#D4AF37").opacity(0.3), radius: 5, x: 0, y: 2)
                
                Image(systemName: rowIcon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "#0F0F1A"))
            }
            .frame(width: 46)
            
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
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#D4AF37"))
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
                        
                        Text("Renewal: \(subscription.formattedNextBillingDate)")
                            .font(AppStyles.Typography.caption)
                            .foregroundColor(.textSecondary)
                    }
                } else {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(hex: "#D4AF37"))
                        
                        Text("One-Time Purchase")
                            .font(AppStyles.Typography.caption)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#D4AF37"))
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
        .background(Color.cardBackground)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color(hex: "#D4AF37").opacity(0.3), lineWidth: 1.2)
        )
    }
}
