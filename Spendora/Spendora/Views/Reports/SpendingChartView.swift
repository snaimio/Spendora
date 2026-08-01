//
//  SpendingChartView.swift
//

import SwiftUI
import Charts

// MARK: - Chart Timeframe Enum

// MARK: - ChartTimeframe

/**
 `ChartTimeframe` is a enum that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for charttimeframe handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `ChartTimeframe` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
enum ChartTimeframe: String, CaseIterable {

    // MARK: - Properties

    case monthly = "Monthly"
    case yearly = "Yearly"
}

// MARK: - Chart Style Enum

// MARK: - ChartStyle

/**
 `ChartStyle` is a enum that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for chartstyle handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `ChartStyle` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
enum ChartStyle: String, CaseIterable {

    // MARK: - Properties

    case bar = "Bar"
    case donut = "Donut"
}


// MARK: - SpendingChartView

/**
 `SpendingChartView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for spendingchartview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `SpendingChartView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct SpendingChartView: View {

    // MARK: - Properties

    let subscriptions: [Subscription]  // subscriptions property
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTimeframe: ChartTimeframe = .monthly
    @State private var selectedStyle: ChartStyle = .donut
    
    var chartData: [(label: String, amount: Double)] {  // chartData property
        switch selectedTimeframe {
        case .monthly:
            let categories = Dictionary(grouping: subscriptions) { $0.effectiveCategory }
            return categories.map { (key: String, value: [Subscription]) in
                let total = value.reduce(0.0) { $0 + $1.monthlyCost }
                return (label: key, amount: total)
            }
            .sorted { $0.amount > $1.amount }
            
        case .yearly:
            let categories = Dictionary(grouping: subscriptions) { $0.effectiveCategory }
            return categories.map { (key: String, value: [Subscription]) in
                let total = value.reduce(0.0) { $0 + $1.yearlyCost }
                return (label: key, amount: total)
            }
            .sorted { $0.amount > $1.amount }
        }
    }
    
    var totalSpending: Double {  // totalSpending property
        chartData.reduce(0.0) { $0 + $1.amount }
    }
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                HStack(spacing: 12) {
                    Picker("Timeframe", selection: $selectedTimeframe) {
                        ForEach(ChartTimeframe.allCases, id: \.self) { timeframe in
                            Text(timeframe.rawValue).tag(timeframe)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Picker("Style", selection: $selectedStyle) {
                        ForEach(ChartStyle.allCases, id: \.self) { style in
                            Text(style.rawValue).tag(style)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.horizontal)
                
                if subscriptions.isEmpty {
                    EmptyChartView()
                } else {
                    if selectedStyle == .bar {
                        SpendingBarChart(data: chartData)
                    } else {
                        SpendingDonutChart(data: chartData, totalSpending: totalSpending)
                    }
                    
                    ChartSummaryCards(
                        chartData: chartData,
                        totalSpending: totalSpending,
                        selectedTimeframe: selectedTimeframe
                    )
                }
                
                Spacer()
            }
            .padding(.vertical)
            .navigationTitle("Spending Breakdown")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.brandPrimary)
                }
            }
        }
    }
}

// MARK: - Spending Donut Chart

// MARK: - SpendingDonutChart

/**
 `SpendingDonutChart` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for spendingdonutchart handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `SpendingDonutChart` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct SpendingDonutChart: View {

    // MARK: - Properties

    let data: [(label: String, amount: Double)]  // data property
    let totalSpending: Double  // totalSpending property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        ZStack {
            Chart(data, id: \.label) { item in
                SectorMark(
                    angle: .value("Spending", item.amount),
                    innerRadius: .ratio(0.65),
                    angularInset: 1.5
                )
                .cornerRadius(5)
                .foregroundStyle(by: .value("Category", item.label))
            }
            .frame(height: 280)
            .padding(.horizontal)
            
            VStack(spacing: 4) {
                Text("TOTAL")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                Text(CurrencyManager.shared.format(totalSpending))
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
            }
        }
    }
}

// MARK: - Spending Bar Chart

// MARK: - SpendingBarChart

/**
 `SpendingBarChart` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for spendingbarchart handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `SpendingBarChart` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct SpendingBarChart: View {

    // MARK: - Properties

    let data: [(label: String, amount: Double)]  // data property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        Chart(data, id: \.label) { item in
            BarMark(
                x: .value("Category", item.label),
                y: .value("Spending", item.amount)
            )
            .foregroundStyle(by: .value("Category", item.label))
            .cornerRadius(8)
        }
        .frame(height: 280)
        .padding(.horizontal)
        .chartLegend(.hidden)
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel()
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .chartYAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisValueLabel()
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
