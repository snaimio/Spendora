//
//  YearlyReportSubviews.swift
//

/**
 * Main/Core Functions & Purpose:
 * YearlyReportSubviews component file containing MonthlyTrendChartView and TopCategoryView for financial report visualization.
 */

import SwiftUI
import Charts

// MARK: - Monthly Trend Chart

// MARK: - MonthlyTrendChartView

/**
 `MonthlyTrendChartView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for monthlytrendchartview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `MonthlyTrendChartView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct MonthlyTrendChartView: View {

    // MARK: - Properties

    let monthlyData: [(month: String, amount: Double)]  // monthlyData property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
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

// MARK: - TopCategoryView

/**
 `TopCategoryView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for topcategoryview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `TopCategoryView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct TopCategoryView: View {

    // MARK: - Properties

    let topCategory: String  // topCategory property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
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
