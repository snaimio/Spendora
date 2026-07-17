//
//  SubscriptionRow.swift
//  Spendora
//

import SwiftUI

struct SubscriptionRow: View {
    let subscription: Subscription
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(hex: subscription.colorHex ?? "#6C63FF"))
                .frame(width: 10, height: 10)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(subscription.displayName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 4) {
                    Text(subscription.effectiveCategory)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if subscription.isYearly {
                        Text("•")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Yearly")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if subscription.isTrial && !subscription.trialConvertedToPaid {
                        Text("•")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Trial")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(CurrencyManager.shared.format(subscription.monthlyCost))
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("/month")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.03), radius: 4)
    }
}
