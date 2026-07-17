//
//  NextChargeCard.swift
//  Spendora
//

import SwiftUI

struct NextChargeCard: View {
    let subscription: Subscription
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.brandPrimary.opacity(0.12), .brandSecondary.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                
                Image(systemName: "clock.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.brandPrimary)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Next Charge")
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .tracking(1)
                
                Text(subscription.displayName)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                HStack(spacing: 4) {
                    Text(CurrencyManager.shared.format(subscription.monthlyCost))
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text(subscription.formattedNextBillingDate)
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            }
            
            Spacer(minLength: 8)
            
            // Days remaining badge
            let days = subscription.daysUntilBilling
            if days >= 0 && days <= 7 {
                BadgeView(
                    text: days == 0 ? "Today" : "\(days)d",
                    color: days <= 1 ? .red : .orange
                )
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [.brandPrimary.opacity(0.2), .brandSecondary.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
}
