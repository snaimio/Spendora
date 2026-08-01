//
//  YearlyReportSummary.swift
//

import SwiftUI


// MARK: - YearlyReportSummary

/**
 `YearlyReportSummary` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for yearlyreportsummary handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `YearlyReportSummary` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct YearlyReportSummary: View {

    // MARK: - Properties

    let totalYearly: Double  // totalYearly property
    let averageMonthly: Double  // averageMonthly property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
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
