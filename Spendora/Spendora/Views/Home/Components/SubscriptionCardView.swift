//
//  SubscriptionCardView.swift
//

/**
 * Main/Core Functions & Purpose:
 * SubscriptionCardView component displaying individual subscription details, icon, trial/renewal badges, monthly cost, and next billing date.
 */

import SwiftUI


// MARK: - SubscriptionCardView

/**
 `SubscriptionCardView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for subscriptioncardview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `SubscriptionCardView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct SubscriptionCardView: View {

    // MARK: - Properties

    let subscription: Subscription  // subscription property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [cardColor, cardColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                    .shadow(color: cardColor.opacity(0.3), radius: 4, x: 0, y: 2)
                
                Image(systemName: cardIcon)
                    .font(.system(size: 14, weight: .semibold))
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
