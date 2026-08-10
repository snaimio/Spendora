//
//  HomeHeaderCards.swift
//  Spendora
//

import SwiftUI

// MARK: - HeroCardView (Revolut × Monzo Executive Dashboard Header)

/**
 `HeroCardView` presents the primary executive dashboard components formatted to Spendora's design system:
 1. `ThisMonthCardView`: Single 16pt rounded card with 40pt Bold monospaced figure, 4pt budget bar, and Next Charge section.
 2. `ExecutiveMetricsRow`: 3-Column balanced statistics (Yearly, Average, Total) in independent 12pt mini-cards.
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
        VStack(spacing: AppStyles.Spacing.md) {
            // CARD 1: Executive Monthly Spend Card
            ThisMonthCardView(
                totalMonthly: totalMonthly,
                totalYearly: totalYearly,
                count: count,
                subscriptionCount: subscriptionCount,
                nextSubscription: nextSubscription
            )
            
            // CARD 2: 3-Column Balanced Metric Cards (Yearly | Average | Total)
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
    @Environment(\.colorScheme) private var colorScheme

    private var monthlyBudget: Double {
        BudgetService.shared.monthlyBudget
    }

    private var budgetProgress: Double {
        monthlyBudget > 0 ? min(1.0, totalMonthly / monthlyBudget) : 0.0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 14) {
                // Section Header: THIS MONTH (11pt Semibold Tracking)
                HStack {
                    Text("THIS MONTH")
                        .font(AppStyles.Typography.label)
                        .foregroundColor(.textSecondary)
                        .tracking(1.2)
                    
                    Spacer()
                    
                    if monthlyBudget > 0 {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(budgetProgress >= 0.9 ? Color.brandDanger : Color.brandPrimary)
                                .frame(width: 6, height: 6)
                            
                            Text(String(format: "%.0f%% used", budgetProgress * 100))
                                .font(AppStyles.Typography.caption)
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.secondaryCardBackground)
                        .clipShape(Capsule())
                    }
                }

                // Main Monthly Spend Hero Amount (40pt Bold Monospaced)
                VStack(alignment: .leading, spacing: 4) {
                    Text(CurrencyManager.shared.format(totalMonthly))
                        .font(AppStyles.Typography.heroPrice)
                        .foregroundColor(.textPrimary)
                        .contentTransition(.numericText())
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                    
                    Text("\(count) active \(count == 1 ? "subscription" : "subscriptions")")
                        .font(AppStyles.Typography.subheadline)
                        .foregroundColor(.textSecondary)
                }
                
                // 4pt Continuous Capsule Budget Bar
                if monthlyBudget > 0 {
                    VStack(alignment: .leading, spacing: 6) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.secondaryCardBackground)
                                    .frame(height: 4)
                                
                                Capsule()
                                    .fill(
                                        budgetProgress >= 0.9
                                            ? Color.brandDanger
                                            : Color.brandPrimary
                                    )
                                    .frame(width: max(4, geo.size.width * CGFloat(budgetProgress)), height: 4)
                            }
                        }
                        .frame(height: 4)
                        
                        HStack {
                            Text("Budget: \(CurrencyManager.shared.format(monthlyBudget))")
                                .font(AppStyles.Typography.caption)
                                .foregroundColor(.textSecondary)
                            Spacer()
                            Text("\(CurrencyManager.shared.format(max(0, monthlyBudget - totalMonthly))) left")
                                .font(AppStyles.Typography.caption)
                                .foregroundColor(monthlyBudget >= totalMonthly ? .brandSuccess : .brandDanger)
                        }
                    }
                    .padding(.top, 2)
                }
            }
            .padding(AppStyles.Spacing.cardPadding)
            
            // Next Charge Spotlight Sub-Section
            if let next = nextSubscription {
                Divider()
                    .background(Color.cardBorder)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("NEXT CHARGE")
                            .font(AppStyles.Typography.label)
                            .foregroundColor(.textSecondary)
                            .tracking(1.0)
                        
                        Spacer()
                    }
                    
                    HStack(alignment: .center, spacing: 12) {
                        // Category Icon Container (40x40 with 12pt corner radius)
                        ZStack {
                            RoundedRectangle(cornerRadius: AppStyles.Radius.medium, style: .continuous)
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
                                .foregroundColor(.textPrimary)
                                .lineLimit(1)
                            
                            Text(next.formattedNextBillingDate)
                                .font(AppStyles.Typography.caption)
                                .foregroundColor(.textSecondary)
                        }
                        
                        Spacer()
                        
                        // Cost Figure
                        Text(CurrencyManager.shared.format(next.isOneTime ? next.cost : next.monthlyCost))
                            .font(Font.system(size: 16, weight: .semibold, design: .default).monospacedDigit())
                            .foregroundColor(.textPrimary)
                    }
                    
                    // Status Badge ALWAYS on its own new dedicated row
                    CountdownChip(daysRemaining: next.daysUntilBilling, isCancelled: next.isCancelled)
                }
                .padding(AppStyles.Spacing.cardPadding)
                .background(Color.secondaryCardBackground.opacity(0.5))
            }
        }
        .appleCard(cornerRadius: AppStyles.Radius.card)
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
                title: "YEARLY",
                value: CurrencyManager.shared.format(totalYearly)
            )
            
            MetricSubCard(
                title: "AVERAGE",
                value: CurrencyManager.shared.format(averageMonthly)
            )
            
            MetricSubCard(
                title: "TOTAL",
                value: "\(totalCount)"
            )
        }
    }
}

// MARK: - MetricSubCard (12pt Corner Radius Mini-Card)

struct MetricSubCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(AppStyles.Typography.label)
                .foregroundColor(.textSecondary)
                .tracking(0.6)
                .lineLimit(1)
            
            Text(value)
                .font(Font.system(size: 16, weight: .semibold, design: .default).monospacedDigit())
                .foregroundColor(.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.65)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .appleCard(cornerRadius: AppStyles.Radius.medium)
    }
}
