//
//  HeroHeaderView.swift
//

import SwiftUI

// MARK: - HeroHeaderView

/**
 `HeroHeaderView` renders the main dashboard executive summary hero card with vibrant gradients,
 high-contrast typography, live currency formatting, budget progress bar, and glass stat pills.
 */
struct HeroHeaderView: View {

    // MARK: - Properties

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

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            // Header Top Bar with App Logo
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
                
                // Active Subscriptions Count Pill
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color(hex: "#10B981"))
                        .frame(width: 6, height: 6)
                    Text("\(count) Active")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.cardBackground)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal, 16)
            
            // Executive Hero Spending Card
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("TOTAL MONTHLY RUN RATE")
                            .font(.system(size: 11, weight: .heavy, design: .rounded))
                            .foregroundColor(.white.opacity(0.85))
                            .tracking(1.2)
                        
                        Text(CurrencyManager.shared.format(totalMonthly))
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .contentTransition(.numericText())
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                    
                    Spacer()
                    
                    // Glass Stat Pills (Yearly & Avg)
                    VStack(alignment: .trailing, spacing: 6) {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 10, weight: .bold))
                            Text("Yr: \(CurrencyManager.shared.format(totalYearly))")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.18))
                        .cornerRadius(10)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: 10, weight: .bold))
                            Text("Avg: \(CurrencyManager.shared.format(count > 0 ? totalMonthly / Double(count) : 0))")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.18))
                        .cornerRadius(10)
                    }
                }
                
                // Budget Progress Bar
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
                    .padding(.top, 4)
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
