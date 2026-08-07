//
//  SubscriptionCardView.swift
//  Spendora
//

import SwiftUI

// MARK: - SubscriptionCardView

/**
 `SubscriptionCardView` implements Spendora's distinct typography & color hierarchy:
 - 1. SUBSCRIPTION NAME TITLE: Distinct 19pt Bold Rounded Font (.textPrimary High Contrast)
 - 2. PRICE ($XX.XX): Distinct 16pt Heavy Black Font in Signature Gold/Brass (#D4AF37)
 - 3. CYCLE & DATES: Muted 13pt Regular Font (.textSecondary)
 - 4. STATUS BADGE ("Due in X days" / "Paid • Xd left"): Standalone NEW ROW!
 */
struct SubscriptionCardView: View {

    // MARK: - Properties

    let subscription: Subscription

    private var cardColor: Color {
        UniqueSubscriptionThemeHelper.resolveColor(for: subscription)
    }

    private var cardIcon: String {
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
                
                Image(systemName: cardIcon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "#0F0F1A"))
            }
            .frame(width: 46)
            
            // Card Content Stack
            VStack(alignment: .leading, spacing: 4) {
                // ROW 1: SUBSCRIPTION NAME (Distinct 19pt Bold Rounded Font, .textPrimary Color)
                HStack(alignment: .center) {
                    Text(subscription.displayName)
                        .font(.system(size: 19, weight: .bold, design: .rounded))
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.textSecondary)
                }
                
                // ROW 2: PRICE & BILLING CYCLE (Price: Distinct 16pt Heavy Black Coral Font!)
                HStack(spacing: 4) {
                    Text(CurrencyManager.shared.format(subscription.isOneTime ? subscription.cost : subscription.monthlyCost))
                        .font(.system(size: 16, weight: .black, design: .rounded))
                        .foregroundColor(Color(hex: "#FF6B6B"))
                    
                    if subscription.isOneTime {
                        Text("• Lifetime")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(hex: "#D4AF37"))
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
                
                // ROW 3: NEXT BILLING DATE (Muted 13pt Regular Font)
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
                            .foregroundColor(Color(hex: "#D4AF37"))
                        
                        Text("One-Time Purchase")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
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
