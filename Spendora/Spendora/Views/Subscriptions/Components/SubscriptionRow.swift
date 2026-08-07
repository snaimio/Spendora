//
//  SubscriptionRow.swift
//  Spendora
//

import SwiftUI

// MARK: - SubscriptionRow

/**
 `SubscriptionRow` renders a subscription card matching `SubscriptionCardView`'s exact brushed gunmetal aesthetic:
 - Machined Gunmetal Gradient Surface (#2B2D32 → #1A1B1E)
 - Polished Brass Circular Icon Container with logo emblem
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
                    .shadow(color: Color(hex: "#D4AF37").opacity(0.35), radius: 6, x: 0, y: 3)
                
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
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(hex: "#94A3B8"))
                }
                
                // ROW 2: COST & BILLING CYCLE (Subheadline 15pt Regular)
                HStack(spacing: 4) {
                    Text(CurrencyManager.shared.format(subscription.isOneTime ? subscription.cost : subscription.monthlyCost))
                        .font(AppStyles.Typography.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    if subscription.isOneTime {
                        Text("• Lifetime")
                            .font(AppStyles.Typography.subheadline)
                            .foregroundColor(Color(hex: "#D4AF37"))
                    } else {
                        Text("/month")
                            .font(AppStyles.Typography.subheadline)
                            .foregroundColor(Color(hex: "#CBD5E1"))
                        
                        if subscription.isYearly {
                            Text("• Yearly")
                                .font(AppStyles.Typography.subheadline)
                                .foregroundColor(Color(hex: "#CBD5E1"))
                        }
                    }
                }
                
                // ROW 3: NEXT BILLING DATE (Caption 13pt Regular)
                if !subscription.isOneTime {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Color(hex: "#94A3B8"))
                        
                        Text("Renewal: \(subscription.formattedNextBillingDate)")
                            .font(AppStyles.Typography.caption)
                            .foregroundColor(Color(hex: "#CBD5E1"))
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
        .background(
            ZStack {
                // Machined Gunmetal Surface
                LinearGradient(
                    colors: [Color(hex: "#2B2D32"), Color(hex: "#1A1B1E")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        )
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.4), radius: 10, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [Color(hex: "#D4AF37").opacity(0.4), Color(hex: "#D4AF37").opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.2
                )
        )
    }
}
