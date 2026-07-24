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

// MARK: - Chart Style Enum
enum ChartStyle: String, CaseIterable {
    case bar = "Bar"
    case donut = "Donut"
}

struct SpendingChartView: View {
    let subscriptions: [Subscription]
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTimeframe: ChartTimeframe = .monthly
    @State private var selectedStyle: ChartStyle = .donut
    
    var chartData: [(label: String, amount: Double)] {
        switch selectedTimeframe {
        case .monthly:
            let categories = Dictionary(grouping: subscriptions) { $0.effectiveCategory }
            return categories.map { (key: String, value: [Subscription]) in
                let total = value.reduce(0) { $0 + $1.normalizedMonthlyCost }
                return (label: key, amount: total)
            }
            .sorted { $0.amount > $1.amount }
            
        case .yearly:
            let categories = Dictionary(grouping: subscriptions) { $0.effectiveCategory }
            return categories.map { (key: String, value: [Subscription]) in
                let total = value.reduce(0) { $0 + $1.normalizedYearlyCost }
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
struct SpendingDonutChart: View {
    let data: [(label: String, amount: Double)]
    let totalSpending: Double
    
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
