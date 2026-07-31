//
//  ChartSummaryCards.swift
//  Spendora
//
//  Capstone 2026 - Mobile Application Development
//  Author: Sheikh Naim
//

/**
 * Main/Core Functions & Purpose:
 * ChartSummaryCards component displaying total spending, category count, and top category breakdown cards for financial charts.
 */

import SwiftUI

struct ChartSummaryCards: View {
    let chartData: [(label: String, amount: Double)]
    let totalSpending: Double
    let selectedTimeframe: ChartTimeframe
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                StatCard(
                    icon: "chart.pie.fill",
                    title: "Total \(selectedTimeframe.rawValue)",
                    value: CurrencyManager.shared.format(totalSpending),
                    color: .brandPrimary
                )
                
                StatCard(
                    icon: "number.circle.fill",
                    title: "Categories",
                    value: "\(chartData.count)",
                    color: .brandSecondary
                )
            }
            .padding(.horizontal)
            
            if let topCategory = chartData.first {
                StatCard(
                    icon: "star.fill",
                    title: "Top Category",
                    value: topCategory.label,
                    subtitle: CurrencyManager.shared.format(topCategory.amount),
                    color: .yellow
                )
                .padding(.horizontal)
            }
        }
    }
}
