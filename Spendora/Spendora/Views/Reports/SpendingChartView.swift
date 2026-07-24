//
//  SpendingChartView.swift
//  Spendora
//

import SwiftUI
import Charts

// MARK: - Chart Timeframe Enum
enum ChartTimeframe: String, CaseIterable {
    case monthly = "Monthly"
    case yearly = "Yearly"
}

struct SpendingChartView: View {
    let subscriptions: [Subscription]
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTimeframe: ChartTimeframe = .monthly
    
    var chartData: [(label: String, amount: Double)] {
        switch selectedTimeframe {
        case .monthly:
            let categories = Dictionary(grouping: subscriptions) { $0.category }
            return categories.map { (key: String, value: [Subscription]) in
                let total = value.reduce(0) { $0 + $1.monthlyCost }
                return (label: key, amount: total)
            }
            .sorted { $0.amount > $1.amount }
            
        case .yearly:
            let categories = Dictionary(grouping: subscriptions) { $0.category }
            return categories.map { (key: String, value: [Subscription]) in
                let total = value.reduce(0) { $0 + $1.yearlyCost }
                return (label: key, amount: total)
            }
            .sorted { $0.amount > $1.amount }
        }
    }
    
    var totalSpending: Double {
        chartData.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Picker("Timeframe", selection: $selectedTimeframe) {
                    ForEach(ChartTimeframe.allCases, id: \.self) { timeframe in
                        Text(timeframe.rawValue).tag(timeframe)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                if subscriptions.isEmpty {
                    EmptyChartView()
                } else {
                    SpendingBarChart(data: chartData)
                    
                    ChartSummaryCards(
                        chartData: chartData,
                        totalSpending: totalSpending,
                        selectedTimeframe: selectedTimeframe
                    )
                }
                
                Spacer()
            }
            .padding(.vertical)
            .navigationTitle("Spending Chart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // ✅ FIXED: Done button with brand primary color
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

// MARK: - Spending Bar Chart
struct SpendingBarChart: View {
    let data: [(label: String, amount: Double)]
    
    var body: some View {
        Chart(data, id: \.label) { item in
            BarMark(
                x: .value("Category", item.label),
                y: .value("Spending", item.amount)
            )
            .foregroundStyle(by: .value("Category", item.label))
            .cornerRadius(8)
        }
        .frame(height: 300)
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

// MARK: - Chart Summary Cards
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
