//
//  HeroHeaderView.swift
//  Spendora
//

import SwiftUI

struct HeroHeaderView: View {
    let totalMonthly: Double
    let totalYearly: Double
    let count: Int
    
    var body: some View {
        VStack(spacing: 0) {
            // Top gradient bar
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.brandPrimary, .brandSecondary],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 4)
                .cornerRadius(2)
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            
            HStack(alignment: .top, spacing: 12) {
                // Left: Monthly spend
                VStack(alignment: .leading, spacing: 4) {
                    Text("THIS MONTH")
                        .font(.system(.caption, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .tracking(1.5)
                    
                    Text(CurrencyManager.shared.format(totalMonthly))
                        .font(.system(size: 32, weight: .bold, design: .rounded))
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
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .background(Color(.systemBackground))
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
        .padding(.horizontal, 4)
    }
}
