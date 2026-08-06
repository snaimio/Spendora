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
 `HeroHeaderView` renders the executive summary hero card with vibrant blue gradients,
 time period toggle (`Monthly ⌄`, `Yearly ⌄`), monthly average, active count, and budget progress.
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
            // Header Top Brand Bar
            HStack {
                HStack(spacing: 8) {
                    Image("AppLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .shadow(color: Color(hex: "#6366F1").opacity(0.4), radius: 6, x: 0, y: 3)
                    
                    Text("SPENDORA")
                        .font(.system(size: 14, weight: .black, design: .rounded))
                        .tracking(2.2)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "#6366F1"), Color(hex: "#8B5CF6")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                Spacer()
                
                // Period Menu Dropdown (Inspired by SubX Screenshot 3)
                Menu {
                    Picker("Period", selection: $selectedPeriod) {
                        ForEach(BillingPeriodFilter.allCases) { period in
                            Text(period.rawValue).tag(period)
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(selectedPeriod.rawValue)
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .foregroundColor(.brandPrimary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.brandPrimary.opacity(0.12))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 16)
            
            // Executive Hero Banner Card
            VStack(alignment: .leading, spacing: 16) {
                // Top Executive Figures Split (Inspired by SubX Screenshot 3)
                HStack(alignment: .center, spacing: 16) {
                    // Left Figure: Spending Average
                    VStack(alignment: .leading, spacing: 4) {
                        Text(CurrencyManager.shared.format(displayedAmount))
                            .font(.system(size: 34, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .contentTransition(.numericText())
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                        
                        Text(periodLabel)
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.85))
                    }
                    
                    Spacer()
                    
                    // Vertical Separator Divider
                    Rectangle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 1, height: 42)
                    
                    Spacer()
                    
                    // Right Figure: Subscription Count
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("\(count)")
                            .font(.system(size: 34, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(count == 1 ? "subscription" : "subscriptions")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.85))
                    }
                }
                
                // Budget Progress Bar (If Budget Set)
                if budget > 0 {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Monthly Budget (\(CurrencyManager.shared.format(budget)))")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))
                            Spacer()
                            Text("\(Int(budgetRatio * 100))% used")
                                .font(.system(size: 11, weight: .black, design: .rounded))
                                .foregroundColor(budgetRatio > 0.9 ? Color(hex: "#FF4757") : Color(hex: "#2ED573"))
                        }
                        
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(height: 8)
                                
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: budgetRatio > 0.9 ? [Color(hex: "#FFA502"), Color(hex: "#FF4757")] : [Color(hex: "#2ED573"), Color(hex: "#1E90FF")],
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
            .padding(20)
            .background(
                LinearGradient(
                    colors: [Color(hex: "#6366F1"), Color(hex: "#8B5CF6"), Color(hex: "#4F46E5")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(24)
            .shadow(color: Color(hex: "#6366F1").opacity(0.35), radius: 16, x: 0, y: 8)
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .padding(.horizontal, 16)
        }
    }
}
