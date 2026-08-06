//
//  HeroHeaderView.swift
//  Spendora
//

import SwiftUI

// MARK: - BillingPeriodFilter Enum

enum BillingPeriodFilter: String, CaseIterable, Identifiable {
    case monthly = "Monthly"
    case yearly = "Yearly"
    case total = "Total"
    
    var id: String { rawValue }
}

// MARK: - HeroHeaderView

/**
 `HeroHeaderView` renders the main executive dashboard hero card featuring:
 - Signature Bold Teal Gradient (#00D4AA → #00B4D8 → #6C5CE7)
 - 38pt Black Hero Price Counter
 - Period Selector Dropdown (Monthly ⌄, Yearly ⌄)
 - Budget Progress Bar
 - Next Charge Card with proper multi-line layout rules (Name prominent 20pt Bold, due days on NEW ROW!)
 */
struct HeroHeaderView: View {

    // MARK: - Properties

    let totalMonthly: Double
    let totalYearly: Double
    let subscriptionCount: Int
    let nextSubscription: Subscription?
    
    @State private var selectedPeriod: BillingPeriodFilter = .monthly

    private var budget: Double {
        BudgetService.shared.monthlyBudget
    }
    
    private var budgetRatio: Double {
        BudgetService.shared.progressRatio(currentSpending: totalMonthly)
    }

    private var displayedAmount: Double {
        switch selectedPeriod {
        case .monthly: return totalMonthly
        case .yearly: return totalYearly
        case .total: return totalYearly
        }
    }

    private var periodLabel: String {
        switch selectedPeriod {
        case .monthly: return "THIS MONTH"
        case .yearly: return "YEARLY COMMITMENT"
        case .total: return "TOTAL EXPENDITURE"
        }
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            // Executive Hero Banner Card
            VStack(alignment: .leading, spacing: 18) {
                // Header Row: Period Menu & Active Count
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                            .font(.system(size: 13, weight: .bold))
                        Text(periodLabel)
                            .font(AppStyles.Typography.footnote)
                            .fontWeight(.bold)
                            .tracking(1.5)
                    }
                    .foregroundColor(.white.opacity(0.85))
                    
                    Spacer()
                    
                    // Period Menu Dropdown Pill
                    Menu {
                        Picker("Period", selection: $selectedPeriod) {
                            ForEach(BillingPeriodFilter.allCases) { period in
                                Text(period.rawValue).tag(period)
                            }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(selectedPeriod.rawValue)
                                .font(AppStyles.Typography.caption2)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)
                    }
                }
                
                // Hero Price & Subscription Count
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(CurrencyManager.shared.format(displayedAmount))
                            .font(AppStyles.Typography.heroPrice)
                            .foregroundColor(.white)
                            .contentTransition(.numericText())
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                        
                        Text("\(subscriptionCount) \(subscriptionCount == 1 ? "active subscription" : "active subscriptions")")
                            .font(AppStyles.Typography.caption)
                            .foregroundColor(.white.opacity(0.85))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: 11, weight: .bold))
                            Text("Avg: \(CurrencyManager.shared.format(subscriptionCount > 0 ? totalMonthly / Double(subscriptionCount) : 0))")
                                .font(AppStyles.Typography.caption2)
                        }
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.18))
                        .cornerRadius(8)
                        
                        Text("Yearly: \(CurrencyManager.shared.format(totalYearly))")
                            .font(AppStyles.Typography.caption2)
                            .foregroundColor(.white.opacity(0.85))
                            .lineLimit(1)
                    }
                }
                
                // Budget Progress Bar
                if budget > 0 {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Monthly Budget (\(CurrencyManager.shared.format(budget)))")
                                .font(AppStyles.Typography.footnote)
                                .fontWeight(.bold)
                                .foregroundColor(.white.opacity(0.9))
                            Spacer()
                            Text("\(Int(budgetRatio * 100))% used")
                                .font(AppStyles.Typography.caption2)
                                .foregroundColor(budgetRatio > 0.9 ? Color(hex: "#FF6B6B") : Color(hex: "#FFD93D"))
                        }
                        
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.white.opacity(0.22))
                                    .frame(height: 8)
                                
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: budgetRatio > 0.9 ? [Color(hex: "#FFD93D"), Color(hex: "#FF6B6B")] : [Color(hex: "#00D4AA"), Color(hex: "#FFD93D")],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: max(0, min(geo.size.width, geo.size.width * CGFloat(budgetRatio))), height: 8)
                            }
                        }
                        .frame(height: 8)
                    }
                    .padding(.top, 2)
                }
                
                // Next Charge Section Card (Proper Multi-Line Layout Structure)
                if let next = nextSubscription {
                    Divider()
                        .background(Color.white.opacity(0.25))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        // ROW 1: Header Label (Caption 12pt Semibold)
                        HStack(spacing: 5) {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(hex: "#FFD93D"))
                            
                            Text("NEXT CHARGE")
                                .font(AppStyles.Typography.caption2)
                                .foregroundColor(.white.opacity(0.85))
                                .tracking(1.2)
                        }
                        
                        // ROW 2: Subscription Name (Title 3 20pt Bold - PROMINENT)
                        Text(next.displayName)
                            .font(AppStyles.Typography.title3)
                            .foregroundColor(.white)
                            .lineLimit(1)
                        
                        // ROW 3: Cost & Billing Date (Body 16pt Regular)
                        Text("\(CurrencyManager.shared.format(next.isOneTime ? next.cost : next.monthlyCost)) • \(next.formattedNextBillingDate)")
                            .font(AppStyles.Typography.body)
                            .foregroundColor(.white.opacity(0.9))
                        
                        // ROW 4: Status Badge ("Due in X days") - NEW ROW!
                        CountdownChip(daysRemaining: next.daysUntilBilling)
                            .padding(.top, 2)
                    }
                }
            }
            .padding(20)
            .background(Color.gradientHero)
            .cornerRadius(22)
            .shadow(color: Color(hex: "#00D4AA").opacity(0.35), radius: 18, x: 0, y: 8)
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
            )
            .padding(.horizontal, 16)
        }
    }
}
