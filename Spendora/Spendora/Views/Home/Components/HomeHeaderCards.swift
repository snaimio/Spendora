//
//  HomeHeaderCards.swift
//  Spendora
//

import SwiftUI

// MARK: - HeroCardView (Golden UX 20pt Radius & 52pt Hero Architecture)

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
            // HERO SPEND CARD (20pt radius, white, coral shadow)
            ThisMonthCardView(
                totalMonthly: totalMonthly,
                totalYearly: totalYearly,
                count: count,
                subscriptionCount: subscriptionCount,
                nextSubscription: nextSubscription
            )
            
            // STAT ROW (3 equal cards with 10pt spacing)
            ExecutiveMetricsRow(
                totalYearly: totalYearly,
                averageMonthly: averageMonthlyCost,
                totalCount: count
            )
        }
    }
}

// MARK: - ThisMonthCardView (Top Priority Hero Element)

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
                // Top row: "THIS MONTH" 11pt semibold uppercase #FF8E53 + right coral budget pill
                HStack(alignment: .center) {
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
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(SpendoraTheme.Colors.coral)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(SpendoraTheme.Colors.coralTint)
                        .clipShape(Capsule())
                    }
                }

                // Middle: monthly total 52pt bold monospaced — owns the screen
                VStack(alignment: .leading, spacing: 4) {
                    Text(CurrencyManager.shared.format(totalMonthly))
                        .font(SpendoraTheme.Typography.heroAmount)
                        .foregroundColor(SpendoraTheme.Colors.textPrimary)
                        .contentTransition(.numericText())
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    // Below total: "X active subscriptions" 14pt secondary
                    Text("\(count) active \(count == 1 ? "subscription" : "subscriptions")")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(SpendoraTheme.Colors.textSecondary)
                }
                
                // Capsule Budget Progress Bar
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
            
            // Next charge section inside hero card below 0.5pt divider #F0EBE3
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
                        // Leading service icon 44x44 rounded
                        ZStack {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(next.categoryEnum.color.opacity(0.15))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: UniqueSubscriptionThemeHelper.resolveIcon(for: next))
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(next.categoryEnum.color)
                        }
                        
                        // Service name 17pt semibold, date 13pt secondary
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
                        
                        // Cost 17pt semibold coral monospaced
                        Text(CurrencyManager.shared.format(next.isOneTime ? next.cost : next.monthlyCost))
                            .font(Font.system(size: 17, weight: .semibold, design: .default).monospacedDigit())
                            .foregroundColor(SpendoraTheme.Colors.coral)
                    }
                    
                    // Status badge on next charge row
                    CountdownChip(daysRemaining: next.daysUntilBilling, isCancelled: next.isCancelled)
                        .padding(.top, 2)
                }
                .padding(SpendoraTheme.Spacing.lg)
                .background(SpendoraTheme.Colors.coralTint.opacity(0.35))
            }
        }
        .spendoraCard(cornerRadius: SpendoraTheme.Radius.hero)
    }
}

// MARK: - ExecutiveMetricsRow (Stat Row: 3 Equal Mini-Cards)

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

// MARK: - MetricSubCard (12pt Radius, 12pt Padding, 10pt Label #FF8E53, 18pt Bold Value)

struct MetricSubCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(SpendoraTheme.Colors.coralWarm)
                .tracking(0.8)
                .lineLimit(1)
            
            Text(value)
                .font(Font.system(size: 18, weight: .bold, design: .default).monospacedDigit())
                .foregroundColor(SpendoraTheme.Colors.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .padding(12)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .spendoraCard(cornerRadius: SpendoraTheme.Radius.subCard)
    }
}
