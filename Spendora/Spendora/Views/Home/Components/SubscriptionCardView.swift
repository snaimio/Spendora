/**
 * Main/Core Functions & Purpose:
 * SubscriptionCardView component displaying individual subscription details, icon, trial/renewal badges, monthly cost, and next billing date.
 */

import SwiftUI

struct SubscriptionCardView: View {
    let subscription: Subscription
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [categoryColor, categoryColor.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                
                Image(systemName: categoryIcon)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(subscription.displayName)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    if subscription.isUpcoming {
                        Text("Soon")
                            .font(.system(size: 7, weight: .bold, design: .rounded))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(hex: "#FFE66D").opacity(0.2))
                            .foregroundColor(Color(hex: "#FFE66D"))
                            .cornerRadius(6)
                    }
                    
                    if subscription.isTrial && !subscription.trialConvertedToPaid {
                        Text("Trial")
                            .font(.system(size: 7, weight: .bold, design: .rounded))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(hex: "#FF6B6B").opacity(0.15))
                            .foregroundColor(Color(hex: "#FF6B6B"))
                            .cornerRadius(6)
                    }
                }
                
                HStack(spacing: 4) {
                    Text(CurrencyManager.shared.format(subscription.monthlyCost))
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.brandPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    Text("/month")
                        .font(.system(size: 10, weight: .regular, design: .rounded))
                        .foregroundColor(.textSecondary)
                    
                    if subscription.isYearly {
                        Text("• Yearly")
                            .font(.system(size: 9, weight: .regular, design: .rounded))
                            .foregroundColor(.textSecondary)
                    }
                }
                
                HStack(spacing: 3) {
                    Image(systemName: "calendar")
                        .font(.system(size: 7))
                        .foregroundColor(.textSecondary)
                    
                    Text("Next: \(subscription.formattedNextBillingDate)")
                        .font(.system(size: 9, weight: .regular, design: .rounded))
                        .foregroundColor(.textSecondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            Spacer(minLength: 4)
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.textSecondary.opacity(0.3))
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
        )
    }
    
    private var categoryIcon: String {
        SubscriptionCategory(rawValue: subscription.category)?.icon ?? "tag.fill"
    }
    
    private var categoryColor: Color {
        switch subscription.category {
        case "Entertainment": return .categoryEntertainment
        case "Productivity": return .categoryProductivity
        case "Health & Fitness": return .categoryHealth
        case "Shopping": return .categoryShopping
        case "Food & Dining": return .categoryFood
        case "Education": return .categoryEducation
        default: return .categoryOther
        }
    }
}
