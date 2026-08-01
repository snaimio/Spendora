//
//  ChartSummaryCards.swift
//

/**
 * Main/Core Functions & Purpose:
 * ChartSummaryCards component displaying total spending, category count, and top category breakdown cards for financial charts.
 */

import SwiftUI


// MARK: - ChartSummaryCards

/**
 `ChartSummaryCards` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for chartsummarycards handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `ChartSummaryCards` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct ChartSummaryCards: View {

    // MARK: - Properties

    let chartData: [(label: String, amount: Double)]  // chartData property
    let totalSpending: Double  // totalSpending property
    let selectedTimeframe: ChartTimeframe  // selectedTimeframe property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
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
