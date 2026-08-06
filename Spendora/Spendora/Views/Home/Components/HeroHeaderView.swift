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
 `HeroHeaderView` renders the executive summary hero card styled after Apple Wallet & Apple Health hero cards,
 featuring Apple's signature blue-to-indigo gradient, time period toggle (`Monthly ⌄`, `Yearly ⌄`), monthly average, active count, and budget progress.
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
        case .monthly: return "monthly avg."
        case .yearly: return "yearly total"
        case .total: return "total run rate"
        }
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            // Header Top Brand Bar (Apple Fitness Style Header)
            HStack {
                HStack(spacing: 8) {
                    Image("AppLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .shadow(color: Color(hex: "#007AFF").opacity(0.4), radius: 6, x: 0, y: 3)
                    
                    Text("SPENDORA")
                        .font(.system(size: 15, weight: .black, design: .rounded))
                        .tracking(2.4)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "#007AFF"), Color(hex: "#5856D6")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                Spacer()
                
                // Period Menu Dropdown (Apple iOS 18 Menu Pill)
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
                    .foregroundColor(Color(hex: "#007AFF"))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(Color(hex: "#007AFF").opacity(0.12))
                    .cornerRadius(14)
                }
            }
            .padding(.horizontal, 16)
            
            // Executive Apple Card Banner (Apple Wallet Hero Card Style)
            VStack(alignment: .leading, spacing: 18) {
                HStack(alignment: .center, spacing: 16) {
                    // Left Figure: Spending Average
                    VStack(alignment: .leading, spacing: 4) {
                        Text(CurrencyManager.shared.format(displayedAmount))
                            .font(.system(size: 38, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .contentTransition(.numericText())
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                        
                        Text(periodLabel)
                            .font(.system(size: 13, weight: .bold, design: .rounded))
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
                            .font(.system(size: 38, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(count == 1 ? "subscription" : "subscriptions")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.88))
                    }
                }
                
                // Budget Progress Bar (Apple Health Progress Ring Style)
                if budget > 0 {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Monthly Budget (\(CurrencyManager.shared.format(budget)))")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(.white.opacity(0.92))
                            Spacer()
                            Text("\(Int(budgetRatio * 100))% used")
                                .font(.system(size: 11, weight: .black, design: .rounded))
                                .foregroundColor(budgetRatio > 0.9 ? Color(hex: "#FF453A") : Color(hex: "#30D158"))
                        }
                        
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.white.opacity(0.22))
                                    .frame(height: 8)
                                
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: budgetRatio > 0.9 ? [Color(hex: "#FF9F0A"), Color(hex: "#FF453A")] : [Color(hex: "#30D158"), Color(hex: "#64D2FF")],
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
            .background(
                LinearGradient(
                    colors: [Color(hex: "#007AFF"), Color(hex: "#5856D6"), Color(hex: "#40C8E0")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(24)
            .shadow(color: Color(hex: "#007AFF").opacity(0.38), radius: 18, x: 0, y: 8)
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
            )
            .padding(.horizontal, 16)
        }
    }
}
