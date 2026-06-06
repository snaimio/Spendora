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
                .fill(Color(.systemBlue).opacity(0.1))
                .frame(width: 50, height: 50)
                .overlay {
                    Image(systemName: category.icon)
                        .foregroundColor(Color(.systemBlue))
                        .font(.title3)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(subscription.displayName)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                if subscription.isYearly {
                    Text(String(format: "$%.2f", subscription.cost))
                        .font(.subheadline)
                        .foregroundColor(Color(.secondaryLabel))
                    + Text("/year")
                        .font(.caption2)
                        .foregroundColor(Color(.secondaryLabel))
                    
                    Text("(\(String(format: "$%.2f", subscription.monthlyCost))/month equivalent)")
                        .font(.caption2)
                        .foregroundColor(Color(.secondaryLabel))
                } else {
                    Text(String(format: "$%.2f", subscription.monthlyCost))
                        .font(.subheadline)
                        .foregroundColor(Color(.secondaryLabel))
                    + Text("/month")
                        .font(.caption2)
                        .foregroundColor(Color(.secondaryLabel))
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption2)
                    Text("Next: \(subscription.formattedNextBillingDate)")
                        .font(.caption)
                }
                .foregroundColor(subscription.isUpcoming ? .orange : Color(.secondaryLabel))
            }
            
            Spacer()
            
            // Badges Stack
            VStack(alignment: .trailing, spacing: 4) {
                // Upcoming Badge
                if subscription.isUpcoming {
                    Text("Soon")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.2))
                        .foregroundColor(.orange)
                        .cornerRadius(8)
                }
                
                // Trial Badge
                if subscription.isTrial && !subscription.trialConvertedToPaid {
                    if subscription.trialWarning {
                        Text("Trial ends in \(subscription.trialDaysRemaining) days")
                            .font(.caption2)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.red.opacity(0.2))
                            .foregroundColor(.red)
                            .cornerRadius(8)
                    } else {
                        Text("Trial")
                            .font(.caption2)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.2))
                            .foregroundColor(.green)
                            .cornerRadius(8)
                    }
                }
                
                // Price Increase Badge
                if subscription.priceIncreased {
                    Text("+\(String(format: "$%.2f", subscription.priceIncreaseAmount))")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.2))
                        .foregroundColor(.orange)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(subscription.displayName), \(subscription.isYearly ? "\(String(format: "%.2f", subscription.cost)) dollars per year" : "\(String(format: "%.2f", subscription.monthlyCost)) dollars per month"), next billing \(subscription.formattedNextBillingDate)")
        .accessibilityHint("Swipe left for delete options, tap for details")
    }
}
