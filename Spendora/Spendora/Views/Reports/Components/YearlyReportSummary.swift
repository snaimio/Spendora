//
//  YearlyReportSummary.swift
//  Spendora
//

import SwiftUI

struct YearlyReportSummary: View {
    let totalYearly: Double
    let averageMonthly: Double
    
    var body: some View {
        HStack(spacing: 16) {
            YearlyStatCard(
                title: "Total Yearly",
                value: CurrencyManager.shared.format(totalYearly),
                icon: "calendar",
                color: Color.brandPrimary
            )
            
            YearlyStatCard(
                title: "Monthly Avg",
                value: CurrencyManager.shared.format(averageMonthly),
                icon: "chart.line.uptrend.xyaxis",
                color: Color.brandSecondary
            )
        }
    }
}
