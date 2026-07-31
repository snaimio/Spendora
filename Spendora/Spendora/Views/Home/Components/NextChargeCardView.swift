/**
 * Main/Core Functions & Purpose:
 * NextChargeCardView component displaying the upcoming subscription payment amount, days remaining countdown badge, and service name.
 */

import SwiftUI

struct NextChargeCardView: View {
    let subscription: Subscription
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#FF6B6B"), Color(hex: "#FFE66D")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                
                Image(systemName: "clock.fill")
                    .font(.title3)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text("Next Charge")
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.textSecondary)
                    .tracking(1)
                
                Text(subscription.displayName)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                HStack(spacing: 4) {
                    Text(CurrencyManager.shared.format(subscription.monthlyCost))
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.brandPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    Text("•")
                        .foregroundColor(.textSecondary)
                    
                    Text(subscription.formattedNextBillingDate)
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.textSecondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            Spacer(minLength: 4)
            
            let days = subscription.daysUntilBilling
            if days >= 0 && days <= 7 {
                if days <= 1 {
                    Text(days == 0 ? "Today" : "\(days)d")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "#FF6B6B"), Color(hex: "#FF9A9E")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                } else {
                    Text("\(days)d")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "#FFE66D"), Color(hex: "#F7DC6F")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
        )
    }
}
