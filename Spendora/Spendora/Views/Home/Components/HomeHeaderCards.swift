//
//  HomeHeaderCards.swift
//  Spendora
//

import SwiftUI

// MARK: - HeroCardView (Executive Dashboard Hero & Spotlight Cards)

/**
 `HeroCardView` presents the primary executive dashboard components:
 1. `ThisMonthCardView`: Hero gradient section (#00D4AA → #00B4D8 → #6C5CE7), 42pt Black Hero price, Budget progress bar, and Yearly/Avg mini-cards.
 2. `NextChargeSpotlightCardView`: Spotlight upcoming renewal card with countdown chip on a dedicated row.
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
        VStack(spacing: AppStyles.Spacing.large) {
            // CARD 1: Executive Monthly Spend Hero Card (Teal → Blue → Purple Gradient)
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

    private var monthlyBudget: Double {
        BudgetService.shared.monthlyBudget
    }

    private var budgetProgress: Double {
        monthlyBudget > 0 ? min(1.0, totalMonthly / monthlyBudget) : 0.0
    }

    var body: some View {
        VStack(spacing: 0) {
            // Top Accent Spendora Hero Gradient Bar (#00D4AA → #00B4D8 → #6C5CE7)
            Rectangle()
                .fill(Color.gradientHero)
                .frame(height: 5)

            VStack(alignment: .leading, spacing: AppStyles.Spacing.cardPadding) {
                // Header Row: Label & Active Budget Pill
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.brandPrimary)
                        Text("THIS MONTH")
                            .font(AppStyles.Typography.micro)
                            .foregroundColor(.textSecondary)
                            .tracking(1.5)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 11))
                            .foregroundColor(.brandPrimary)
                        Text("Active Budget")
                            .font(AppStyles.Typography.micro)
                            .foregroundColor(.brandPrimary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.brandPrimary.opacity(0.14))
                    .cornerRadius(AppStyles.Radius.chip)
                }

                // Main Monthly Spend Hero Amount (42pt Black Monospaced)
                VStack(alignment: .leading, spacing: AppStyles.Spacing.element) {
                    Text(CurrencyManager.shared.format(totalMonthly))
                        .font(AppStyles.Typography.heroPrice)
                        .foregroundColor(.brandPrimary)
                        .contentTransition(.numericText())
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                    
                    if count > 0 {
                        Text("\(count) active \(count == 1 ? "subscription" : "subscriptions") total")
                            .font(AppStyles.Typography.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
                
                // Budget Progress Bar
                if monthlyBudget > 0 {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Monthly Budget: \(CurrencyManager.shared.format(monthlyBudget))")
                                .font(AppStyles.Typography.caption)
                                .foregroundColor(.textSecondary)
                            
                            Spacer()
                            
                            Text(String(format: "%.0f%% Used", budgetProgress * 100))
                                .font(AppStyles.Typography.micro)
                                .foregroundColor(budgetProgress >= 0.9 ? .brandSecondary : .brandPrimary)
                        }
                        
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.secondary.opacity(0.15))
                                    .frame(height: 6)
                                
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: budgetProgress >= 0.9 ? [.brandWarning, .brandSecondary] : [.brandPrimary, .brandTertiary],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: max(6, geo.size.width * CGFloat(budgetProgress)), height: 6)
                            }
                        }
                        .frame(height: 6)
                    }
                    .padding(.vertical, 2)
                }
                
                // Embedded 2-Column Mini Metric Cards (Yearly Total & Avg Per Sub)
                HStack(spacing: 12) {
                    MetricSubCard(
                        icon: "calendar.badge.clock",
                        title: "Yearly Total",
                        value: CurrencyManager.shared.format(totalYearly),
                        color: .brandTertiary
                    )
                    
                    MetricSubCard(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Avg Per Sub",
                        value: CurrencyManager.shared.format(averageMonthlyCost),
                        color: .brandPurple
                    )
                }
            }
            .padding(AppStyles.Spacing.cardPadding)
        }
        .background(Color.cardBackground)
        .cornerRadius(AppStyles.Radius.hero)
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: AppStyles.Radius.hero, style: .continuous)
                .stroke(Color.brandPrimary.opacity(0.25), lineWidth: 1.2)
        )
    }
}

// MARK: - Card 2: Next Charge Spotlight Card View

struct NextChargeSpotlightCardView: View {
    let subscription: Subscription
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            // Top Accent Sunset Bar (#FF6B6B → #FFD93D)
            Rectangle()
                .fill(Color.gradientSunset)
                .frame(height: 5)

            VStack(alignment: .leading, spacing: 14) {
                // Header Row: Label & Countdown Badge
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "bell.badge.fill")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.brandAccent)
                        
                        Text("NEXT CHARGE SPOTLIGHT")
                            .font(AppStyles.Typography.micro)
                            .foregroundColor(.textSecondary)
                            .tracking(1.5)
                    }
                    
                    Spacer()
                }

                // Spotlight Content Row
                HStack(alignment: .center, spacing: 14) {
                    // Emblem Circle Icon
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [subscription.categoryEnum.color, subscription.categoryEnum.color.opacity(0.75)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)
                            .shadow(color: subscription.categoryEnum.color.opacity(0.3), radius: 4, y: 2)
                        
                        Image(systemName: UniqueSubscriptionThemeHelper.resolveIcon(for: subscription))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    // Subscription Name & Next Billing Date
                    VStack(alignment: .leading, spacing: 3) {
                        Text(subscription.displayName)
                            .font(AppStyles.Typography.headline)
                            .foregroundColor(.textPrimary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 11))
                                .foregroundColor(.textSecondary)
                            Text("Renewal: \(subscription.formattedNextBillingDate)")
                                .font(AppStyles.Typography.caption)
                                .foregroundColor(.textSecondary)
                                .lineLimit(1)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    
                    // Cost Figure (Coral Red)
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(CurrencyManager.shared.format(subscription.isOneTime ? subscription.cost : subscription.monthlyCost))
                            .font(Font.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.brandSecondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                        
                        Text(subscription.isOneTime ? "Lifetime" : (subscription.isYearly ? "/yr" : "/mo"))
                            .font(AppStyles.Typography.caption2)
                            .foregroundColor(.textSecondary)
                    }
                    .fixedSize(horizontal: true, vertical: false)
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: AppStyles.Radius.card)
                        .fill(colorScheme == .dark ? Color.white.opacity(0.04) : Color(hex: "#FFFDF5"))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AppStyles.Radius.card)
                        .stroke(Color.brandAccent.opacity(0.3), lineWidth: 1)
                )
                
                // Countdown chip ALWAYS on its own new dedicated row
                CountdownChip(daysRemaining: subscription.daysUntilBilling, isCancelled: subscription.isCancelled)
            }
            .padding(AppStyles.Spacing.cardPadding)
        }
        .background(Color.cardBackground)
        .cornerRadius(AppStyles.Radius.hero)
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: AppStyles.Radius.hero, style: .continuous)
                .stroke(Color.brandAccent.opacity(0.35), lineWidth: 1.2)
        )
    }
}

// MARK: - MetricSubCard (Embedded Mini Container)

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
                    .font(AppStyles.Typography.micro)
                    .foregroundColor(.textSecondary)
                    .lineLimit(1)
            }
            
            Text(value)
                .font(Font.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppStyles.Radius.medium)
                .fill(colorScheme == .dark ? Color.white.opacity(0.04) : Color.black.opacity(0.025))
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppStyles.Radius.medium)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}
