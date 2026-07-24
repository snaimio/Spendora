//
//  SubscriptionRow.swift
//  Spendora
//

import SwiftUI

struct SubscriptionRow: View {
    let subscription: Subscription
    
    var body: some View {
        HStack(spacing: 12) {
            // Color indicator
            Circle()
                .fill(Color(hex: subscription.colorHex ?? "#6C63FF"))
                .frame(width: 10, height: 10)
                .padding(.trailing, 4)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(subscription.displayName)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                HStack(spacing: 4) {
                    Text(subscription.effectiveCategory)
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.textSecondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                    
                    if subscription.isYearly {
                        Text("•")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        Text("Yearly")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.textSecondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    }
                    
                    if subscription.isTrial && !subscription.trialConvertedToPaid {
                        Text("•")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        Text("Trial")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.orange)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(CurrencyManager.shared.format(subscription.monthlyCost))
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.brandPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                Text("/month")
                    .font(.system(.caption2, design: .rounded))
                    .foregroundColor(.textSecondary)
            }
            .frame(minWidth: 70, alignment: .trailing)
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.textSecondary.opacity(0.3))
                .padding(.leading, 4)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
        )
        // ✅ No onTapGesture here - handled by parent
    }
}
