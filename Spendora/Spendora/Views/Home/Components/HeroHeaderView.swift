//
//  HeroHeaderView.swift
//  Spendora
//

import SwiftUI

struct HeroHeaderView: View {
    let totalMonthly: Double
    let totalYearly: Double
    let count: Int
    
    private var budget: Double {
        BudgetService.shared.monthlyBudget
    }
    
    private var budgetRatio: Double {
        BudgetService.shared.progressRatio(currentSpending: totalMonthly)
    }
    
    private var budgetStatusText: String {
        BudgetService.shared.budgetStatus(currentSpending: totalMonthly).status
    }
    
    private var budgetStatusColor: Color {
        BudgetService.shared.budgetStatus(currentSpending: totalMonthly).color
    }

    var body: some View {
        VStack(spacing: 14) {
            // Top gradient line
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.brandPrimary, .brandSecondary, Color.purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 4)
                .cornerRadius(2)
                .padding(.horizontal, 16)
            
            HStack(alignment: .top, spacing: 12) {
                // Left: Monthly spend
                VStack(alignment: .leading, spacing: 4) {
                    Text("THIS MONTH")
                        .font(.system(.caption, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .tracking(1.5)
                    
                    Text(CurrencyManager.shared.format(totalMonthly))
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .contentTransition(.numericText())
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    if count > 0 {
                        Text("\(count) active \(count == 1 ? "subscription" : "subscriptions")")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                
                Spacer(minLength: 8)
                
                // Right: Mini stats
                VStack(alignment: .trailing, spacing: 6) {
                    PremiumStatPill(
                        icon: "calendar",
                        label: "Yearly",
                        value: CurrencyManager.shared.format(totalYearly)
                    )
                    
                    PremiumStatPill(
                        icon: "chart.line.uptrend.xyaxis",
                        label: "Avg",
                        value: CurrencyManager.shared.format(count > 0 ? totalMonthly / Double(count) : 0)
                    )
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 16)
            
            // Budget Progress Bar (If Budget Set)
            if budget > 0 {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Monthly Budget")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(Int(budgetRatio * 100))% used")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(budgetStatusColor)
                    }
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.secondary.opacity(0.15))
                                .frame(height: 8)
                            
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: budgetRatio > 0.9 ? [.orange, .red] : [.brandPrimary, .brandSecondary],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geo.size.width * CGFloat(budgetRatio), height: 8)
                                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: budgetRatio)
                        }
                    }
                    .frame(height: 8)
                    
                    Text(budgetStatusText)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(budgetStatusColor)
                }
                .padding(.horizontal, 16)
                .padding(.top, 4)
            }
        }
        .padding(.vertical, 16)
        .background(.ultraThinMaterial)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.systemBackground).opacity(0.8))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.3), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 5)
        .padding(.horizontal, 4)
    }
}
