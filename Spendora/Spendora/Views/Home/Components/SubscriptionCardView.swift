//
//  SubscriptionCardView.swift
//

import SwiftUI

// MARK: - SubscriptionCardView

/**
 `SubscriptionCardView` renders a single subscription card with vibrant brand colors, rounded 20pt glass containers, and glowing icon circles.
 */
struct SubscriptionCardView: View {

    // MARK: - Properties

    let subscription: Subscription

    // MARK: - Body

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [cardColor, cardColor.opacity(0.75)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                    .shadow(color: cardColor.opacity(0.35), radius: 6, x: 0, y: 3)
                
                Image(systemName: cardIcon)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(width: 44)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(subscription.displayName)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    if subscription.isUpcoming {
                        Text("Due Soon")
                            .font(.system(size: 8, weight: .extrabold, design: .rounded))
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(Color(hex: "#0EA5E9").opacity(0.18))
                            .foregroundColor(Color(hex: "#0EA5E9"))
                            .cornerRadius(8)
                    }
                    
                    if subscription.isTrial && !subscription.trialConvertedToPaid {
                        Text("Trial")
                            .font(.system(size: 8, weight: .extrabold, design: .rounded))
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(Color(hex: "#F59E0B").opacity(0.18))
                            .foregroundColor(Color(hex: "#F59E0B"))
                            .cornerRadius(8)
                    }
                }
                
                HStack(spacing: 4) {
                    Text(CurrencyManager.shared.format(subscription.isOneTime ? subscription.cost : subscription.monthlyCost))
                        .font(.system(size: 14, weight: .heavy, design: .rounded))
                        .foregroundColor(.brandPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    if subscription.isOneTime {
                        Text("• Lifetime")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(.brandPurple)
                    } else {
                        Text("/month")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(.textSecondary)
                        
                        if subscription.isYearly {
                            Text("• Yearly")
                                .font(.system(size: 9, weight: .medium, design: .rounded))
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
                
                if !subscription.isOneTime {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 8, weight: .semibold))
                            .foregroundColor(.textSecondary)
                        
                        Text("Next: \(subscription.formattedNextBillingDate)")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(.textSecondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    }
                } else {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.brandTertiary)
                        
                        Text("One-Time Purchase")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(.brandTertiary)
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.textTertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            ZStack {
                Color.cardBackground
                LinearGradient(
                    colors: [cardColor.opacity(0.08), cardColor.opacity(0.02)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        )
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(cardColor.opacity(0.18), lineWidth: 1)
        )
    }
    
    // MARK: - Dynamic Icon & Color Resolvers
    private var matchingPreset: SubscriptionPreset? {
        SubscriptionPreset.all.first {
            $0.name.localizedCaseInsensitiveCompare(subscription.displayName) == .orderedSame ||
            subscription.displayName.localizedCaseInsensitiveContains($0.name)
        }
    }
    
    private var cardIcon: String {
        if let preset = matchingPreset {
            return preset.systemIcon
        }
        if let category = SubscriptionCategory(rawValue: subscription.category) {
            return category.icon
        }
        switch subscription.category.lowercased() {
        case "music": return "music.note"
        case "ai & tools", "ai", "tools": return "sparkles"
        case "entertainment", "streaming": return "tv.fill"
        case "productivity": return "doc.text.fill"
        case "health & fitness", "fitness", "health": return "figure.run"
        case "shopping": return "cart.fill"
        case "food & dining", "food": return "bag.fill"
        case "education": return "book.fill"
        case "services": return "gear"
        default: return "creditcard.fill"
        }
    }
    
    private var cardColor: Color {
        if let hex = subscription.colorHex, !hex.isEmpty {
            return Color(hex: hex)
        }
        if let preset = matchingPreset {
            return preset.color
        }
        switch subscription.category {
        case "Entertainment": return .categoryEntertainment
        case "Music": return Color(hex: "#1DB954")
        case "AI & Tools": return Color(hex: "#8B5CF6")
        case "Productivity": return .categoryProductivity
        case "Health & Fitness": return .categoryHealth
        case "Shopping": return .categoryShopping
        case "Food & Dining": return .categoryFood
        case "Education": return .categoryEducation
        case "Services": return Color(hex: "#0EA5E9")
        default: return Color(hex: "#6C63FF")
        }
    }
}
