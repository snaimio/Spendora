/**
 * Main/Core Functions & Purpose:
 * YearlyReportSubviews component file containing MonthlyTrendChartView and TopCategoryView for financial report visualization.
 */

import SwiftUI
import Charts

// MARK: - Monthly Trend Chart
struct MonthlyTrendChartView: View {
    let monthlyData: [(month: String, amount: Double)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Monthly Trend")
                .font(.headline)
                .padding(.horizontal)
            
            Chart(monthlyData, id: \.month) { item in
                LineMark(
                    x: .value("Month", item.month),
                    y: .value("Spending", item.amount)
                )
                .foregroundStyle(Color.brandPrimary)
                
                AreaMark(
                    x: .value("Month", item.month),
                    y: .value("Spending", item.amount)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.brandPrimary.opacity(0.3), Color.brandPrimary.opacity(0.05)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                PointMark(
                    x: .value("Month", item.month),
                    y: .value("Spending", item.amount)
                )
                .foregroundStyle(Color.brandPrimary)
            }
            .frame(height: 200)
            .padding(.horizontal)
        }
    }
}

// MARK: - Top Category View
struct TopCategoryView: View {
    let topCategory: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Top Category")
                .font(.headline)
                .padding(.horizontal)
            
            HStack {
                Text(topCategory)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("Highest spending category")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}
