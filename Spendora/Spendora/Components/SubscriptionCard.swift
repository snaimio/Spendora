//
//  SubscriptionCard.swift
//  Spendora
//

import SwiftUI

struct SubscriptionCard: View {
    let subscription: Subscription
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Category Icon
            ZStack {
                Circle()
                    .fill(categoryColor.opacity(0.15))
                    .frame(width: 52, height: 52)
                
                Circle()
                    .fill(categoryColor.opacity(0.25))
                    .frame(width: 44, height: 44)
                
                Image(systemName: categoryIcon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(categoryColor)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(subscription.displayName)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.primary)
                
                HStack(spacing: 8) {
                    if subscription.isYearly {
                        Text(CurrencyManager.shared.format(subscription.cost))
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.secondary)
                        Text("/year")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                        
                        Text("•")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(CurrencyManager.shared.format(subscription.monthlyCost))
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                        Text("/mo")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    } else {
                        Text(CurrencyManager.shared.format(subscription.monthlyCost))
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.primary)
                        Text("/month")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 10))
                    Text("Next: \(subscription.formattedNextBillingDate)")
                        .font(.system(size: 12))
                }
                .foregroundColor(subscription.isUpcoming ? Color.brandAccent : .secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .onTapGesture {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            withAnimation {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                }
            }
        }
    }
    
    private var categoryIcon: String {
        SubscriptionCategory(rawValue: subscription.category)?.icon ?? "tag.fill"
    }
    
    private var categoryColor: Color {
        switch subscription.category {
        case "Entertainment": return Color.categoryEntertainment
        case "Productivity": return Color.categoryProductivity
        case "Health & Fitness": return Color.categoryHealth
        case "Shopping": return Color.categoryShopping
        case "Food & Dining": return Color.categoryFood
        case "Education": return Color.categoryEducation
        default: return Color.categoryOther
        }
    }
}
