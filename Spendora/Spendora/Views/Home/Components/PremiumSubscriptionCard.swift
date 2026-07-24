//
//  PremiumSubscriptionCard.swift
//  Spendora
//

import SwiftUI

struct PremiumSubscriptionCard: View {
    let subscription: Subscription
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 14) {
            // Premium Icon with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                categoryColor.opacity(0.2),
                                categoryColor.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 52, height: 52)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [categoryColor, categoryColor.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: categoryIcon)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(subscription.displayName)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    if subscription.isUpcoming {
                        PremiumBadge(text: "Soon", color: Color(hex: "#FFE66D"))
                    }
                    
                    if subscription.isTrial && !subscription.trialConvertedToPaid {
                        PremiumBadge(text: "Trial", color: Color(hex: "#FF6B6B"))
                    }
                }
                
                HStack(spacing: 6) {
                    Text(CurrencyManager.shared.format(subscription.monthlyCost))
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.brandPrimary)
                    
                    Text("/month")
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    if subscription.isYearly {
                        Text("• Yearly")
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    
                    Text("Next: \(subscription.formattedNextBillingDate)")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary.opacity(0.4))
                
                if subscription.isUpcoming {
                    Text("Due soon")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundColor(Color(hex: "#FFE66D"))
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 2)
        )
        .scaleEffect(isPressed ? 0.97 : 1.0)
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
