//
//  SpendingChartView.swift
//  Spendora
//

import SwiftUI
import Charts

struct SpendingChartView: View {
    let subscriptions: [Subscription]
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTimeframe: Timeframe = .monthly
    
    enum Timeframe: String, CaseIterable {
        case monthly = "Monthly"
        case yearly = "Yearly"
    }
    
    var chartData: [(label: String, amount: Double)] {
        switch selectedTimeframe {
        case .monthly:
            return monthlyChartData
        case .yearly:
            return yearlyChartData
        }
    }
    
    var monthlyChartData: [(label: String, amount: Double)] {
        let categories = Dictionary(grouping: subscriptions) { $0.category }
        return categories.map { (category, subs) in
            let total = subs.reduce(0) { $0 + $1.monthlyCost }
            return (label: category, amount: total)
        }.sorted { $0.amount > $1.amount }
    }
    
    var yearlyChartData: [(label: String, amount: Double)] {
        let categories = Dictionary(grouping: subscriptions) { $0.category }
        return categories.map { (category, subs) in
            let total = subs.reduce(0) { $0 + $1.yearlyCost }
            return (label: category, amount: total)
        }.sorted { $0.amount > $1.amount }
    }
    
    var totalSpending: Double {
        chartData.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Timeframe Picker
                Picker("Timeframe", selection: $selectedTimeframe) {
                    ForEach(Timeframe.allCases, id: \.self) { timeframe in
                        Text(timeframe.rawValue).tag(timeframe)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                if subscriptions.isEmpty {
                    EmptyChartView()
                } else {
                    // Chart
                    Chart(chartData, id: \.label) { item in
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
                    
                    // Summary Cards
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
                        
                        if let topCategory = chartData.first {
                            StatCard(
                                icon: "star.fill",
                                title: "Top Category",
                                value: topCategory.label,
                                subtitle: CurrencyManager.shared.format(topCategory.amount),
                                color: .yellow
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding(.vertical)
            .navigationTitle("Spending Chart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct EmptyChartView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No data to display")
                .font(.headline)
            
            Text("Add subscriptions to see your spending breakdown")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 60)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .padding()
    }
}

#Preview {
    SpendingChartView(subscriptions: [])
}
