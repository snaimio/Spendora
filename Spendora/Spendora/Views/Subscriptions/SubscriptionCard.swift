//
//  SubscriptionCard.swift
//  Spendora
//

import SwiftUI

struct SubscriptionCard: View {
    let subscription: Subscription
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 14) {
            // Category Icon - More vibrant
            ZStack {
                Circle()
                    .fill(categoryColor.opacity(0.2))
                    .frame(width: 48, height: 48)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [categoryColor, categoryColor.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 38, height: 38)
                
                Image(systemName: categoryIcon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(subscription.displayName)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    if subscription.isUpcoming {
                        Text("Soon")
                            .font(.system(size: 8, weight: .bold, design: .rounded))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color(hex: "#FFE66D").opacity(0.2))
                            .foregroundColor(Color(hex: "#FFE66D"))
                            .cornerRadius(8)
                    }
                    
                    if subscription.isTrial && !subscription.trialConvertedToPaid {
                        Text("Trial")
                            .font(.system(size: 8, weight: .bold, design: .rounded))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color(hex: "#FF6B6B").opacity(0.2))
                            .foregroundColor(Color(hex: "#FF6B6B"))
                            .cornerRadius(8)
                    }
                }
                
                HStack(spacing: 4) {
                    Text(CurrencyManager.shared.format(subscription.monthlyCost))
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.brandPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Text("/month")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    if subscription.isYearly {
                        Text("• Yearly")
                            .font(.system(size: 11, weight: .regular, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    
                    Text("Next: \(subscription.formattedNextBillingDate)")
                        .font(.system(size: 11, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary.opacity(0.5))
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(
                    color: Color.black.opacity(0.05),
                    radius: 10,
                    x: 0,
                    y: 2
                )
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
