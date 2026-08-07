//
//  HomeHeaderCards.swift
//  Spendora
//

import SwiftUI

// MARK: - HeroCardView (Container for 2 Standalone Executive Cards)

/**
 `HeroCardView` presents two distinct, standalone cards with embedded sub-card metrics for maximum visual clarity:
 1. `ThisMonthCardView`: Executive monthly spend with embedded Yearly & Average sub-cards.
 2. `NextChargeSpotlightCardView`: Dedicated spotlight card for the imminent upcoming renewal.
 */
struct HeroCardView: View {

    // MARK: - Properties

    let totalMonthly: Double
    let totalYearly: Double
    let count: Int
    let subscriptionCount: Int
    var nextSubscription: Subscription? = nil

    private var averageMonthlyCost: Double {
        subscriptionCount > 0 ? totalMonthly / Double(subscriptionCount) : 0
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            // CARD 1: Executive Monthly Spend Card (with Embedded Mini Cards)
            ThisMonthCardView(
                totalMonthly: totalMonthly,
                totalYearly: totalYearly,
                count: count,
                subscriptionCount: subscriptionCount,
                averageMonthlyCost: averageMonthlyCost
            )
            
            // CARD 2: Next Charge Spotlight Card
            if let next = nextSubscription {
                NextChargeSpotlightCardView(subscription: next)
            }
        }
    }
}

// MARK: - Card 1: This Month Executive Spend Card View

struct ThisMonthCardView: View {
    let totalMonthly: Double
    let totalYearly: Double
    let count: Int
    let subscriptionCount: Int
    let averageMonthlyCost: Double
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

            VStack(alignment: .leading, spacing: 16) {
                // Header Row: Icon, Title & Active Budget Chip
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
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(hex: "#10B981").opacity(0.14))
                    .cornerRadius(10)
                }

                // Main Monthly Spend Hero Amount
                VStack(alignment: .leading, spacing: 2) {
                    Text(CurrencyManager.shared.format(totalMonthly))
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#10B981"))
                        .contentTransition(.numericText())
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                    
                    if count > 0 {
                        Text("\(count) active \(count == 1 ? "subscription" : "subscriptions") total")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(.textSecondary)
                    }
                }
                
                // Embedded 2-Column Mini Metric Cards (Yearly & Average)
                HStack(spacing: 12) {
                    MetricSubCard(
                        icon: "calendar.badge.clock",
                        title: "Yearly Run-Rate",
                        value: CurrencyManager.shared.format(totalYearly),
                        color: Color(hex: "#0EA5E9")
                    )
                    
                    MetricSubCard(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Avg Per Sub",
                        value: CurrencyManager.shared.format(averageMonthlyCost),
                        color: Color(hex: "#8B5CF6")
                    )
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

// MARK: - Card 2: Next Charge Spotlight Card View

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
                // Header Row: Icon, Title & Countdown Badge
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

                // Embedded Clean Spotlight Sub-Card
                HStack(alignment: .center, spacing: 14) {
                    // Emblem Circle Icon
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#F59E0B"), Color(hex: "#D4AF37")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)
                            .shadow(color: Color(hex: "#F59E0B").opacity(0.3), radius: 4, y: 2)
                        
                        Image(systemName: UniqueSubscriptionThemeHelper.resolveIcon(for: subscription))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(hex: "#0F0F1A"))
                    }
                    
                    // Subscription Name & Next Billing Date
                    VStack(alignment: .leading, spacing: 3) {
                        Text(subscription.displayName)
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.textPrimary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 11))
                                .foregroundColor(.textSecondary)
                            Text("Renewal: \(subscription.formattedNextBillingDate)")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundColor(.textSecondary)
                                .lineLimit(1)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    
                    // Cost Figure
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(CurrencyManager.shared.format(subscription.isOneTime ? subscription.cost : subscription.monthlyCost))
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#F59E0B"))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                        
                        Text(subscription.isOneTime ? "Lifetime" : (subscription.isYearly ? "/yr" : "/mo"))
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(.textSecondary)
                    }
                    .fixedSize(horizontal: true, vertical: false)
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(colorScheme == .dark ? Color.white.opacity(0.04) : Color(hex: "#FFFDF5"))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "#F59E0B").opacity(0.2), lineWidth: 1)
                )
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

// MARK: - MetricSubCard (Embedded Clean Mini Card)

struct MetricSubCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(color)
                Text(title)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(.textSecondary)
                    .lineLimit(1)
            }
            
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(colorScheme == .dark ? Color.white.opacity(0.04) : Color.black.opacity(0.025))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}
