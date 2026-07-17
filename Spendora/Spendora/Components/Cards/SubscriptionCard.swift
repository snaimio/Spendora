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
            // Premium Icon with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                categoryColor.opacity(0.15),
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
                            colors: [categoryColor, categoryColor.opacity(0.7)],
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
                    
                    if subscription.isUpcoming {
                        Badge(text: "Soon", color: .orange)
                    }
                    
                    if subscription.isTrial && !subscription.trialConvertedToPaid {
                        Badge(text: "Trial", color: .purple)
                    }
                }
                
                HStack(spacing: 6) {
                    Text(CurrencyManager.shared.format(subscription.monthlyCost))
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                    
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
                }
            }
            
            Spacer()
            
            // Price indicator (like SubX)
            VStack(alignment: .trailing, spacing: 2) {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary.opacity(0.4))
                
                if subscription.isUpcoming {
                    Text("Due soon")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundColor(.orange)
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

struct Badge: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 9, weight: .bold, design: .rounded))
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(8)
    }
}
