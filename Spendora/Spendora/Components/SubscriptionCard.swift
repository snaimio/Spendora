//
//  SubscriptionCard.swift
//  Spendora
//

import SwiftUI

struct SubscriptionCard: View {
    let subscription: Subscription
    
    var body: some View {
        HStack(spacing: 16) {
            let category = SubscriptionCategory(rawValue: subscription.category) ?? .other
            Circle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 50, height: 50)
                .overlay {
                    Image(systemName: category.icon)
                        .foregroundColor(.blue)
                        .font(.title3)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(subscription.displayName)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                if subscription.isYearly {
                    Text(subscription.cost, format: .currency(code: "USD"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    + Text("/year")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text("(\(subscription.monthlyCost, format: .currency(code: "USD"))/month equivalent)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                } else {
                    Text(subscription.monthlyCost, format: .currency(code: "USD"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    + Text("/month")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption2)
                    Text("Next: \(subscription.formattedNextBillingDate)")
                        .font(.caption)
                }
                .foregroundColor(subscription.isUpcoming ? .orange : .secondary)
            }
            
            Spacer()
            
            if subscription.isUpcoming {
                Text("Soon")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.2))
                    .foregroundColor(.orange)
                    .cornerRadius(8)
                    .accessibilityLabel("Upcoming charge")
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(subscription.displayName), \(subscription.isYearly ? "\(subscription.cost) dollars per year" : "\(subscription.monthlyCost) dollars per month"), next billing \(subscription.formattedNextBillingDate)")
        .accessibilityHint("Swipe left for delete options, tap for details")
    }
}
