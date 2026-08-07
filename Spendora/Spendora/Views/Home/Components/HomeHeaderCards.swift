//
//  HomeHeaderCards.swift
//  Spendora
//

import SwiftUI

// MARK: - HeroCardView (Container for 2 Standalone Cards)

/**
 `HeroCardView` presents two distinct, standalone cards for executive clarity:
 1. `ThisMonthCardView`: Displays overall monthly spend, active count, yearly commitment & monthly average.
 2. `NextChargeSpotlightCardView`: Dedicated luxury card highlighting upcoming charge details with zero text truncation.
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
            // CARD 1: Executive Monthly Spend Card
            ThisMonthCardView(
                totalMonthly: totalMonthly,
                totalYearly: totalYearly,
                count: count,
                subscriptionCount: subscriptionCount
            )
            
            // CARD 2: Standalone Next Charge Spotlight Card (Adaptive Light/Dark Mode Palette!)
            if let next = nextSubscription {
                NextChargeSpotlightCardView(subscription: next)
            }
        }
    }
}

// MARK: - Card 1: This Month Card View

struct ThisMonthCardView: View {
    let totalMonthly: Double
    let totalYearly: Double
    let count: Int
    let subscriptionCount: Int
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            // Top Accent Brand Gradient Bar
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
                        Image(systemName: "calendar")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(colorScheme == .dark ? Color(hex: "#D4AF37") : Color(hex: "#C2410C"))
                        Text("THIS MONTH")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(.textSecondary)
                            .tracking(1.5)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 12))
                            .foregroundColor(colorScheme == .dark ? Color(hex: "#D4AF37") : Color(hex: "#B45309"))
                        Text("Active Budget")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(colorScheme == .dark ? Color(hex: "#D4AF37") : Color(hex: "#B45309"))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        colorScheme == .dark
                            ? Color(hex: "#D4AF37").opacity(0.16)
                            : Color(hex: "#FEF3C7")
                    )
                    .cornerRadius(10)
                }

                // Main Spend Row & Stats
                HStack(alignment: .bottom, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(CurrencyManager.shared.format(totalMonthly))
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                            .foregroundColor(.textPrimary)
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
                .stroke(Color.secondary.opacity(0.12), lineWidth: 1)
        )
    }
}

// MARK: - Card 2: Next Charge Spotlight Card View (Adaptive Light & Dark Palette!)

struct NextChargeSpotlightCardView: View {
    let subscription: Subscription
    @Environment(\.colorScheme) private var colorScheme

    private var dateTextColor: Color {
        colorScheme == .dark ? Color(hex: "#D4AF37") : Color(hex: "#B45309")
    }

    private var headerIconColor: Color {
        colorScheme == .dark ? Color(hex: "#F59E0B") : Color(hex: "#C2410C")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header Row: Icon, Title & Status Badge
            HStack(alignment: .center) {
                HStack(spacing: 6) {
                    Image(systemName: "bell.badge.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(headerIconColor)
                    
                    Text("NEXT CHARGE SPOTLIGHT")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(dateTextColor)
                        .tracking(1.2)
                }
                
                Spacer()
                
                CountdownChip(daysRemaining: subscription.daysUntilBilling, isCancelled: subscription.isCancelled)
            }
            
            Divider()
                .background(dateTextColor.opacity(0.25))
            
            // Subscription Name (Prominent 22pt Bold Text)
            Text(subscription.displayName)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            // Cost & Cycle Row (Vibrant Coral 20pt Heavy Black Font)
            HStack(spacing: 6) {
                Text(CurrencyManager.shared.format(subscription.isOneTime ? subscription.cost : subscription.monthlyCost))
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundColor(Color(hex: "#FF6B6B"))
                
                if subscription.isOneTime {
                    Text("• Lifetime")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(dateTextColor)
                } else {
                    Text("/month")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.textSecondary)
                    
                    if subscription.isYearly {
                        Text("• Yearly Plan")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(dateTextColor)
                    }
                }
            }
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
            
            // Renewal Date Row (16pt Bold Signature Gold - 1 Single Locked Line!)
            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(dateTextColor)
                
                Text("Renewal Date: \(subscription.formattedNextBillingDate)")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(dateTextColor)
            }
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
        }
        .padding(18)
        .background(
            colorScheme == .dark
                ? LinearGradient(
                    colors: [Color(hex: "#1E293B"), Color(hex: "#0F0F1A")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                : LinearGradient(
                    colors: [Color.white, Color(hex: "#FAFAFA")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
        )
        .cornerRadius(22)
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.2 : 0.05), radius: 12, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(
                    colorScheme == .dark
                        ? LinearGradient(
                            colors: [Color(hex: "#D4AF37").opacity(0.6), Color(hex: "#D4AF37").opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        : LinearGradient(
                            colors: [Color(hex: "#F59E0B").opacity(0.4), Color(hex: "#F59E0B").opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                    lineWidth: 1.5
                )
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
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
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
