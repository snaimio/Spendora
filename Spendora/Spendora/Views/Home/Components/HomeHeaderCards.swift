//
//  HomeHeaderCards.swift
//  Spendora
//

import SwiftUI

// MARK: - HeroCardView (Apple Native 12pt Inset Secondary Surface)

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
        VStack(spacing: SpendoraTheme.sectionSpacing) {
            // A. Hero Spend Card (12pt Radius, secondarySystemBackground, 16pt Padding)
            ThisMonthCardView(
                totalMonthly: totalMonthly,
                totalYearly: totalYearly,
                count: count,
                subscriptionCount: subscriptionCount,
                nextSubscription: nextSubscription
            )
            
            // B. Stat Row (HStack(spacing: 10) three equal cards)
            ExecutiveMetricsRow(
                totalYearly: totalYearly,
                averageMonthly: averageMonthlyCost,
                totalCount: count
            )
        }
    }
}

// MARK: - ThisMonthCardView (Apple Native Hero Card)

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
            VStack(alignment: .leading, spacing: 14) {
                // Top Header: "THIS MONTH"
                HStack(alignment: .center) {
                    Text("THIS MONTH")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                    
                    Spacer()
                    
                    if monthlyBudget > 0 {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(budgetProgress >= 0.9 ? Color(.systemRed) : SpendoraTheme.accent)
                                .frame(width: 6, height: 6)
                            
                            Text(String(format: "%.0f%% used", budgetProgress * 100))
                                .font(.caption.weight(.semibold))
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color(.tertiarySystemBackground))
                        .clipShape(Capsule())
                    }
                }

                // Monthly Total — 52pt Bold Rounded Monospaced in Color(.label)
                VStack(alignment: .leading, spacing: 4) {
                    Text(CurrencyManager.shared.format(totalMonthly))
                        .font(SpendoraTheme.heroNumber)
                        .foregroundColor(Color(.label))
                        .contentTransition(.numericText())
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    Text("\(count) active \(count == 1 ? "subscription" : "subscriptions")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Native Capsule Budget Indicator
                if monthlyBudget > 0 {
                    VStack(alignment: .leading, spacing: 6) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color(.tertiarySystemBackground))
                                    .frame(height: 4)
                                
                                Capsule()
                                    .fill(
                                        budgetProgress >= 0.9
                                            ? Color(.systemRed)
                                            : SpendoraTheme.accent
                                    )
                                    .frame(width: max(4, geo.size.width * CGFloat(budgetProgress)), height: 4)
                            }
                        }
                        .frame(height: 4)
                        
                        HStack {
                            Text("Budget: \(CurrencyManager.shared.format(monthlyBudget))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("\(CurrencyManager.shared.format(max(0, monthlyBudget - totalMonthly))) left")
                                .font(.caption)
                                .foregroundColor(monthlyBudget >= totalMonthly ? SpendoraTheme.accent : Color(.systemRed))
                        }
                    }
                    .padding(.top, 2)
                }
            }
            .padding(SpendoraTheme.cardPadding)
            
            // Next Charge Row below native Divider()
            if let next = nextSubscription {
                Divider()
                
                HStack(alignment: .center, spacing: 12) {
                    // Icon 40x40pt .background(Color(.tertiarySystemBackground))
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color(.tertiarySystemBackground))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: UniqueSubscriptionThemeHelper.resolveIcon(for: next))
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(next.categoryEnum.color)
                    }
                    
                    // Name .font(.headline), Date .font(.caption).foregroundColor(.secondary)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(next.displayName)
                            .font(.headline)
                            .foregroundColor(Color(.label))
                            .lineLimit(1)
                        
                        Text(next.formattedNextBillingDate)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Cost cardAmount in accent color
                    Text(CurrencyManager.shared.format(next.isOneTime ? next.cost : next.monthlyCost))
                        .font(SpendoraTheme.cardAmount)
                        .foregroundColor(SpendoraTheme.accent)
                }
                .padding(SpendoraTheme.cardPadding)
            }
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous))
    }
}

// MARK: - ExecutiveMetricsRow (Stat Row: 3 Equal Cards)

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

// MARK: - MetricSubCard (12pt Radius, secondarySystemBackground, label / statNumber)

struct MetricSubCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .lineLimit(1)
            
            Text(value)
                .font(SpendoraTheme.statNumber)
                .foregroundColor(Color(.label))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .padding(12)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous))
    }
}
