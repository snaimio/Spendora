//
//  HomeHeaderCards.swift
//  Spendora
//

import SwiftUI

// MARK: - HeroCardView (60-30-10 Coral Fire & Warm Cream Architecture)

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
        VStack(spacing: SpendoraTheme.Spacing.md) {
            // CARD 1: Executive Monthly Spend Card (20pt radius)
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
                // Section Header: THIS MONTH (11pt semibold uppercase #FF8E53)
                HStack {
                    Text("THIS MONTH")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(SpendoraTheme.Colors.coralWarm)
                        .tracking(1.2)
                    
                    Spacer()
                    
                    if monthlyBudget > 0 {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(budgetProgress >= 0.9 ? SpendoraTheme.Colors.danger : SpendoraTheme.Colors.coral)
                                .frame(width: 6, height: 6)
                            
                            Text(String(format: "%.0f%% used", budgetProgress * 100))
                                .font(SpendoraTheme.Typography.caption)
                                .foregroundColor(SpendoraTheme.Colors.textSecondary)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(SpendoraTheme.Colors.coralTint)
                        .clipShape(Capsule())
                    }
                }

                // Main Monthly Spend Hero Amount (52pt bold monospaced)
                VStack(alignment: .leading, spacing: 4) {
                    Text(CurrencyManager.shared.format(totalMonthly))
                        .font(SpendoraTheme.Typography.heroAmount)
                        .foregroundColor(SpendoraTheme.Colors.textPrimary)
                        .contentTransition(.numericText())
                        .lineLimit(1)
                        .minimumScaleFactor(0.55)
                    
                    Text("\(count) active \(count == 1 ? "subscription" : "subscriptions")")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(SpendoraTheme.Colors.textSecondary)
                }
                
                // Capsule Budget Bar
                if monthlyBudget > 0 {
                    VStack(alignment: .leading, spacing: 6) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(SpendoraTheme.Colors.coralTint)
                                    .frame(height: 5)
                                
                                Capsule()
                                    .fill(
                                        budgetProgress >= 0.9
                                            ? SpendoraTheme.Colors.danger
                                            : SpendoraTheme.Colors.coral
                                    )
                                    .frame(width: max(5, geo.size.width * CGFloat(budgetProgress)), height: 5)
                            }
                        }
                        .frame(height: 5)
                        
                        HStack {
                            Text("Budget: \(CurrencyManager.shared.format(monthlyBudget))")
                                .font(SpendoraTheme.Typography.caption)
                                .foregroundColor(SpendoraTheme.Colors.textSecondary)
                            Spacer()
                            Text("\(CurrencyManager.shared.format(max(0, monthlyBudget - totalMonthly))) left")
                                .font(SpendoraTheme.Typography.caption)
                                .foregroundColor(monthlyBudget >= totalMonthly ? SpendoraTheme.Colors.success : SpendoraTheme.Colors.danger)
                        }
                    }
                    .padding(.top, 2)
                }
            }
            .padding(SpendoraTheme.Spacing.lg)
            
            // Next Charge Section inside hero card below 0.5pt divider
            if let next = nextSubscription {
                Divider()
                    .background(SpendoraTheme.Colors.border)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("NEXT CHARGE")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(SpendoraTheme.Colors.coralWarm)
                            .tracking(1.0)
                        
                        Spacer()
                    }
                    
                    HStack(alignment: .center, spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(next.categoryEnum.color.opacity(0.15))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: UniqueSubscriptionThemeHelper.resolveIcon(for: next))
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(next.categoryEnum.color)
                        }
                        
                        // Service name 17pt semibold
                        VStack(alignment: .leading, spacing: 2) {
                            Text(next.displayName)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(SpendoraTheme.Colors.textPrimary)
                                .lineLimit(1)
                            
                            Text(next.formattedNextBillingDate)
                                .font(SpendoraTheme.Typography.caption)
                                .foregroundColor(SpendoraTheme.Colors.textSecondary)
                        }
                        
                        Spacer()
                        
                        // Cost coral colored #FF6B6B
                        Text(CurrencyManager.shared.format(next.isOneTime ? next.cost : next.monthlyCost))
                            .font(Font.system(size: 16, weight: .semibold, design: .default).monospacedDigit())
                            .foregroundColor(SpendoraTheme.Colors.coral)
                    }
                    
                    // Status Badge Dedicated Row
                    CountdownChip(daysRemaining: next.daysUntilBilling, isCancelled: next.isCancelled)
                }
                .padding(SpendoraTheme.Spacing.lg)
                .background(SpendoraTheme.Colors.coralTint.opacity(0.4))
            }
        }
        .spendoraCard(cornerRadius: SpendoraTheme.Radius.hero)
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

// MARK: - MetricSubCard (3 Equal Mini-Cards)

struct MetricSubCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Label 10pt uppercase #FF8E53
            Text(title)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(SpendoraTheme.Colors.coralWarm)
                .tracking(0.8)
                .lineLimit(1)
            
            // Value 17pt semibold dark
            Text(value)
                .font(Font.system(size: 17, weight: .semibold, design: .default).monospacedDigit())
                .foregroundColor(SpendoraTheme.Colors.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.65)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .spendoraCard(cornerRadius: SpendoraTheme.Radius.subCard)
    }
}
