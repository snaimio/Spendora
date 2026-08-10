//
//  HomeHeaderCards.swift
//  Spendora
//

import SwiftUI

// MARK: - HeroCardView (Slate & Rose-Gold Executive Dashboard Header)

/**
 `HeroCardView` presents the primary executive dashboard components formatted to Spendora's luxury dark standards:
 1. `ThisMonthCardView`: Glassmorphic #1C1C1E card with large white spend figure, rose-gold budget progress bar, and Next Charge section.
 2. `ExecutiveMetricsRow`: 3-Column balanced statistics (Yearly, Average, Total).
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
        VStack(spacing: AppStyles.Spacing.medium) {
            // CARD 1: Executive Monthly Spend Card
            ThisMonthCardView(
                totalMonthly: totalMonthly,
                totalYearly: totalYearly,
                count: count,
                subscriptionCount: subscriptionCount,
                nextSubscription: nextSubscription
            )
            
            // CARD 2: 3-Column Metric Tiles (Yearly | Average | Total)
            ExecutiveMetricsRow(
                totalYearly: totalYearly,
                averageMonthly: averageMonthlyCost,
                totalCount: count
            )
        }
    }
}

// MARK: - Card 1: This Month Executive Card View

struct ThisMonthCardView: View {
    let totalMonthly: Double
    let totalYearly: Double
    let count: Int
    let subscriptionCount: Int
    var nextSubscription: Subscription? = nil

    private var monthlyBudget: Double {
        BudgetService.shared.monthlyBudget
    }

    private var budgetProgress: Double {
        monthlyBudget > 0 ? min(1.0, totalMonthly / monthlyBudget) : 0.0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                // Section Header: THIS MONTH (11pt Semibold Tracking)
                HStack {
                    Text("THIS MONTH")
                        .font(AppStyles.Typography.micro)
                        .foregroundColor(.textSecondary)
                        .tracking(1.2)
                    
                    Spacer()
                    
                    if monthlyBudget > 0 {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(budgetProgress >= 0.9 ? Color.brandSecondary : Color.brandPrimary)
                                .frame(width: 6, height: 6)
                            
                            Text(String(format: "%.0f%% used", budgetProgress * 100))
                                .font(AppStyles.Typography.caption2)
                                .foregroundColor(.textSecondary)
                        }
                    }
                }

                // Main Monthly Spend Hero Amount (42pt Bold White Monospaced)
                VStack(alignment: .leading, spacing: 4) {
                    Text(CurrencyManager.shared.format(totalMonthly))
                        .font(AppStyles.Typography.heroPrice)
                        .foregroundColor(.white)
                        .contentTransition(.numericText())
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                    
                    Text("\(count) active \(count == 1 ? "subscription" : "subscriptions")")
                        .font(AppStyles.Typography.subheadline)
                        .foregroundColor(.textSecondary)
                }
                
                // Rose-Gold Budget Progress Bar
                if monthlyBudget > 0 {
                    VStack(alignment: .leading, spacing: 6) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.white.opacity(0.08))
                                    .frame(height: 5)
                                
                                Capsule()
                                    .fill(
                                        budgetProgress >= 0.9
                                            ? Color.brandSecondary
                                            : Color.brandPrimary
                                    )
                                    .frame(width: max(6, geo.size.width * CGFloat(budgetProgress)), height: 5)
                            }
                        }
                        .frame(height: 5)
                        
                        HStack {
                            Text("Budget: \(CurrencyManager.shared.format(monthlyBudget))")
                                .font(AppStyles.Typography.caption)
                                .foregroundColor(.textSecondary)
                            Spacer()
                            Text("\(CurrencyManager.shared.format(max(0, monthlyBudget - totalMonthly))) left")
                                .font(AppStyles.Typography.caption)
                                .foregroundColor(monthlyBudget >= totalMonthly ? .brandSuccess : .brandSecondary)
                        }
                    }
                    .padding(.top, 2)
                }
            }
            .padding(AppStyles.Spacing.cardPadding)
            
            // Next Charge Spotlight Sub-Section
            if let next = nextSubscription {
                Divider()
                    .background(Color(hex: "#2C2C2E"))
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("NEXT CHARGE")
                            .font(AppStyles.Typography.micro)
                            .foregroundColor(.textSecondary)
                            .tracking(1.0)
                        
                        Spacer()
                    }
                    
                    HStack(alignment: .center, spacing: 12) {
                        // Category Icon Emblem
                        ZStack {
                            Circle()
                                .fill(next.categoryEnum.color.opacity(0.15))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: UniqueSubscriptionThemeHelper.resolveIcon(for: next))
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(next.categoryEnum.color)
                        }
                        
                        // Name & Renewal Date
                        VStack(alignment: .leading, spacing: 2) {
                            Text(next.displayName)
                                .font(AppStyles.Typography.headline)
                                .foregroundColor(.white)
                                .lineLimit(1)
                            
                            Text(next.formattedNextBillingDate)
                                .font(AppStyles.Typography.caption)
                                .foregroundColor(.textSecondary)
                        }
                        
                        Spacer()
                        
                        // Cost Figure
                        Text(CurrencyManager.shared.format(next.isOneTime ? next.cost : next.monthlyCost))
                            .font(Font.system(size: 17, weight: .semibold, design: .default).monospacedDigit())
                            .foregroundColor(.white)
                    }
                    
                    // Status Badge ALWAYS on its own new dedicated row
                    CountdownChip(daysRemaining: next.daysUntilBilling, isCancelled: next.isCancelled)
                }
                .padding(AppStyles.Spacing.cardPadding)
                .background(Color.white.opacity(0.02))
            }
        }
        .appleCard(cornerRadius: AppStyles.Radius.hero)
    }
}

// MARK: - 3-Column Balanced Metric Cards Row

struct ExecutiveMetricsRow: View {
    let totalYearly: Double
    let averageMonthly: Double
    let totalCount: Int

    var body: some View {
        HStack(spacing: 10) {
            MetricSubCard(
                title: "Yearly",
                value: CurrencyManager.shared.format(totalYearly)
            )
            
            MetricSubCard(
                title: "Average",
                value: CurrencyManager.shared.format(averageMonthly)
            )
            
            MetricSubCard(
                title: "Total",
                value: "\(totalCount)"
            )
        }
    }
}

// MARK: - MetricSubCard (Apple Minimalist Slate Container)

struct MetricSubCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(AppStyles.Typography.micro)
                .foregroundColor(.textSecondary)
                .lineLimit(1)
            
            Text(value)
                .font(Font.system(size: 16, weight: .semibold, design: .default).monospacedDigit())
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.65)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .appleCard(cornerRadius: AppStyles.Radius.medium)
    }
}
