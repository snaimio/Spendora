//
//  NextChargeCard.swift
//  Spendora
//

import SwiftUI

struct NextChargeCard: View {
    let subscription: Subscription
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Premium Icon with gradient
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [categoryColor.opacity(0.12), categoryColor.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [categoryColor, categoryColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: "clock.fill")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Next Charge")
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .tracking(1)
                
                Text(subscription.displayName)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.primary)
                
                HStack(spacing: 6) {
                    Text(CurrencyManager.shared.format(subscription.monthlyCost))
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.bold)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text(subscription.formattedNextBillingDate)
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Days remaining badge
            let days = subscription.daysUntilBilling
            if days >= 0 && days <= 7 {
                PremiumDaysBadge(days: days)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [.brandPrimary.opacity(0.15), .brandSecondary.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
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

// MARK: - Premium Days Badge
struct PremiumDaysBadge: View {
    let days: Int
    
    var body: some View {
        VStack(spacing: 2) {
            if days == 0 {
                Text("Today")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
            } else {
                Text("\(days)")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                Text("days")
                    .font(.system(size: 8, weight: .semibold, design: .rounded))
                    .tracking(1)
            }
        }
        .foregroundColor(days <= 1 ? .red : .orange)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill((days <= 1 ? Color.red : Color.orange).opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            (days <= 1 ? Color.red : Color.orange).opacity(0.2),
                            lineWidth: 1
                        )
                )
        )
    }
}
