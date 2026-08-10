//
//  ShareableYearlyReport.swift
//  Spendora
//

import SwiftUI

// MARK: - ShareableYearlyReport (Apple HIG Branded Financial Statement)

struct ShareableYearlyReport: View {

    // MARK: - Properties

    let year: Int
    let totalYearly: Double
    let averageMonthly: Double
    let topCategory: String

    // MARK: - Body

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 10) {
                Image("SpendoraLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 36, height: 36)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                
                Text("Spendora Financial Statement")
                    .font(.headline)
                    .foregroundColor(Color(.label))
                
                Spacer()
                
                Text("\(year)")
                    .font(.title2.weight(.bold))
                    .foregroundColor(SpendoraTheme.accent)
            }

            Divider()

            VStack(spacing: 6) {
                Text("ANNUAL TOTAL EXPENDITURE")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(Color(.secondaryLabel))
                    .textCase(.uppercase)
                    .tracking(1.0)
                
                Text(CurrencyManager.shared.format(totalYearly))
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(Color(.label))
            }

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Monthly Avg")
                        .font(.caption2)
                        .foregroundColor(Color(.secondaryLabel))
                    Text(CurrencyManager.shared.format(averageMonthly))
                        .font(.headline.weight(.semibold))
                        .foregroundColor(SpendoraTheme.accentText)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Top Category")
                        .font(.caption2)
                        .foregroundColor(Color(.secondaryLabel))
                    Text(topCategory)
                        .font(.headline.weight(.semibold))
                        .foregroundColor(Color(.label))
                }
            }
            .padding(.top, 4)
            
            Text("Generated with Spendora")
                .font(.caption2)
                .foregroundColor(Color(.tertiaryLabel))
        }
        .padding(24)
        .frame(width: 360)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color(.separator), lineWidth: 0.5)
        )
    }
}
