//
//  HomeHeaderCards.swift
//  Spendora
//

import SwiftUI

// MARK: - HeroCardView (Container for 2 Standalone Cards)

/**
 `HeroCardView` presents two distinct, standalone cards for executive clarity:
 1. `ThisMonthCardView`: Displays overall monthly spend with Emerald Green signature styling.
 2. `NextChargeSpotlightCardView`: Displays upcoming charge spotlight with Sunset Coral & Gold signature styling.
 */
struct HeroCardView: View {

    // MARK: - Properties

    let totalMonthly: Double
    let totalYearly: Double
    let count: Int
    let subscriptionCount: Int
    var nextSubscription: Subscription? = nil

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            // CARD 1: Executive Monthly Spend Card (Emerald Theme)
            ThisMonthCardView(
                totalMonthly: totalMonthly,
                totalYearly: totalYearly,
                count: count,
                subscriptionCount: subscriptionCount
            )
            
            // CARD 2: Next Charge Spotlight Card (Sunset Coral & Gold Theme)
            if let next = nextSubscription {
                NextChargeSpotlightCardView(subscription: next)
            }
        }
    }
}

// MARK: - Card 1: This Month Card View (Royal Emerald Theme)

struct ThisMonthCardView: View {
    let totalMonthly: Double
    let totalYearly: Double
    let count: Int
    let subscriptionCount: Int
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            // Top Accent Emerald Gradient Bar
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#10B981"), Color(hex: "#059669"), Color(hex: "#F59E0B")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 5)

            VStack(alignment: .leading, spacing: 14) {
                // Header Row
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color(hex: "#10B981"))
                        Text("THIS MONTH")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(.textSecondary)
                            .tracking(1.5)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 12))
                            .foregroundColor(colorScheme == .dark ? Color(hex: "#10B981") : Color(hex: "#047857"))
                        Text("Active Budget")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(colorScheme == .dark ? Color(hex: "#10B981") : Color(hex: "#047857"))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: "#10B981").opacity(0.14))
                    .cornerRadius(10)
                }

                // Main Spend Row & Stats
                HStack(alignment: .bottom, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(CurrencyManager.shared.format(totalMonthly))
                            .font(.system(size: 38, weight: .black, design: .rounded))
                            .foregroundColor(Color(hex: "#10B981"))
                            .contentTransition(.numericText())
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                        
                        if count > 0 {
                            Text("\(count) active \(count == 1 ? "subscription" : "subscriptions")")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.textSecondary)
                                .lineLimit(1)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    
                    Spacer(minLength: 8)
                    
                    // Side Quick Stats Pills
                    VStack(alignment: .trailing, spacing: 6) {
                        HeroPill(
                            icon: "calendar",
                            label: "Yearly",
                            value: CurrencyManager.shared.format(totalYearly),
                            color: Color(hex: "#0EA5E9")
                        )
                        
                        HeroPill(
                            icon: "chart.line.uptrend.xyaxis",
                            label: "Avg",
                            value: CurrencyManager.shared.format(subscriptionCount > 0 ? totalMonthly / Double(subscriptionCount) : 0),
                            color: Color(hex: "#8B5CF6")
                        )
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                }
            }
            .padding(18)
        }
        .background(Color.cardBackground)
        .cornerRadius(22)
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color(hex: "#10B981").opacity(0.25), lineWidth: 1.2)
        )
    }
}

// MARK: - Card 2: Next Charge Spotlight Card View (Sunset Coral & Gold Theme)

struct NextChargeSpotlightCardView: View {
    let subscription: Subscription
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            // Top Accent Sunset Coral & Gold Bar
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#FF6B6B"), Color(hex: "#F59E0B"), Color(hex: "#D4AF37")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 5)

            VStack(alignment: .leading, spacing: 14) {
                // Header Row
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "bell.badge.fill")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color(hex: "#F59E0B"))
                        
                        Text("NEXT CHARGE SPOTLIGHT")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(.textSecondary)
                            .tracking(1.5)
                    }
                    
                    Spacer()
                    
                    CountdownChip(daysRemaining: subscription.daysUntilBilling, isCancelled: subscription.isCancelled)
                }

                // Single Main Content Row (1 Single Locked Row - Name & Renewal Date on Left, Price on Right!)
                HStack(alignment: .center, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(subscription.displayName)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.textPrimary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.textSecondary)
                            
                            Text("Renewal: \(subscription.formattedNextBillingDate)")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.textSecondary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    
                    Spacer(minLength: 8)
                    
                    // Cost Figure (Single Locked Line on Right Side!)
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(CurrencyManager.shared.format(subscription.isOneTime ? subscription.cost : subscription.monthlyCost))
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundColor(Color(hex: "#F59E0B"))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                        
                        Text(subscription.isOneTime ? "Lifetime" : (subscription.isYearly ? "/yr" : "/mo"))
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(.textSecondary)
                    }
                    .fixedSize(horizontal: true, vertical: false)
                }
            }
            .padding(18)
        }
        .background(Color.cardBackground)
        .cornerRadius(22)
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color(hex: "#F59E0B").opacity(0.35), lineWidth: 1.2)
        )
    }
}

// MARK: - HeroPill

struct HeroPill: View {
    let icon: String
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundColor(color)
            Text(label)
                .font(.system(.caption2, design: .rounded))
                .foregroundColor(.textSecondary)
            Text(value)
                .font(.system(.caption, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.04), radius: 4)
        )
    }
}
