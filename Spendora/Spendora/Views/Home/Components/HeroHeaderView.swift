//
//  HeroHeaderView.swift
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
 `HeroHeaderView` renders the main dashboard executive summary hero card styled with DIRECTION A: GLASSMORPHISM + AURORA gradient mesh,
 38pt Black animated pricing, time period dropdown toggle (`Monthly ⌄`, `Yearly ⌄`), vertical divider stats, and budget progress.
 */
struct HeroHeaderView: View {

    // MARK: - Properties

    let totalMonthly: Double
    let totalYearly: Double
    let count: Int
    
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
        case .monthly: return "monthly run rate"
        case .yearly: return "yearly commitment"
        case .total: return "total expenditure"
        }
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            // Header Top Brand Bar
            HStack {
                HStack(spacing: 8) {
                    Image("AppLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .shadow(color: Color(hex: "#6366F1").opacity(0.4), radius: 6, x: 0, y: 3)
                    
                    Text("SPENDORA")
                        .font(.system(size: 15, weight: .black, design: .rounded))
                        .tracking(2.4)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "#6366F1"), Color(hex: "#8B5CF6")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
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
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                        Image(systemName: "chevron.down")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .foregroundColor(.brandPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(Color.brandPrimary.opacity(0.12))
                    .cornerRadius(14)
                }
            }
            .padding(.horizontal, 16)
            
            // Executive Aurora Glass Hero Banner Card
            VStack(alignment: .leading, spacing: 18) {
                HStack(alignment: .center, spacing: 16) {
                    // Left Figure: Spending Average (38pt Hero Typography)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(CurrencyManager.shared.format(displayedAmount))
                            .font(AppStyles.Typography.hero)
                            .foregroundColor(.white)
                            .contentTransition(.numericText())
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                        
                        Text(periodLabel)
                            .font(AppStyles.Typography.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.88))
                    }
                    
                    Spacer()
                    
                    // Vertical Separator Divider
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 1, height: 46)
                    
                    Spacer()
                    
                    // Right Figure: Subscription Count
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("\(count)")
                            .font(AppStyles.Typography.hero)
                            .foregroundColor(.white)
                        
                        Text(count == 1 ? "subscription" : "subscriptions")
                            .font(AppStyles.Typography.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.88))
                    }
                }
                
                // Budget Progress Bar
                if budget > 0 {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Monthly Budget (\(CurrencyManager.shared.format(budget)))")
                                .font(AppStyles.Typography.footnote)
                                .fontWeight(.bold)
                                .foregroundColor(.white.opacity(0.92))
                            Spacer()
                            Text("\(Int(budgetRatio * 100))% used")
                                .font(AppStyles.Typography.footnote)
                                .fontWeight(.black)
                                .foregroundColor(budgetRatio > 0.9 ? Color(hex: "#F43F5E") : Color(hex: "#10B981"))
                        }
                        
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.white.opacity(0.22))
                                    .frame(height: 8)
                                
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: budgetRatio > 0.9 ? [Color(hex: "#F59E0B"), Color(hex: "#F43F5E")] : [Color(hex: "#10B981"), Color(hex: "#0EA5E9")],
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
            }
            .padding(22)
            .background(Color.gradientAurora)
            .cornerRadius(20)
            .shadow(color: Color(hex: "#6366F1").opacity(0.38), radius: 18, x: 0, y: 8)
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
            )
            .padding(.horizontal, 16)
        }
    }
}
