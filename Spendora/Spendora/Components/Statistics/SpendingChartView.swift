//
//  SpendingChartView.swift
//  Spendora
//

import SwiftUI

struct SpendingChartView: View {
    let subscriptions: [Subscription]

    var categoryData: [(category: String, amount: Double)] {
        let grouped = Dictionary(grouping: subscriptions) { $0.category }

        return grouped.map { (category, subs) in
            let total = subs.reduce(0) { $0 + $1.monthlyCost }
            return (category: category, amount: total)
        }
        .sorted { $0.amount > $1.amount }
    }

    var maxAmount: Double {
        categoryData.map { $0.amount }.max() ?? 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.blue)

                Text("Spending by Category")
                    .font(.headline)
            }

            // Chart Content
            if categoryData.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "chart.bar")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)

                    Text("Add subscriptions to see charts")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(categoryData, id: \.category) { item in
                        HStack {
                            Text(item.category)
                                .font(.caption)
                                .frame(width: 100, alignment: .leading)

                            GeometryReader { geometry in
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(colorForCategory(item.category))
                                    .frame(
                                        width: max(
                                            geometry.size.width * (item.amount / maxAmount),
                                            20
                                        ),
                                        height: 24
                                    )
                            }
                            .frame(height: 24)

                            Text(String(format: "$%.2f", item.amount))
                                .font(.caption)
                                .fontWeight(.semibold)
                                .frame(width: 60, alignment: .trailing)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .padding(.horizontal)
    }

    private func colorForCategory(_ category: String) -> Color {
        switch category {
        case "Entertainment":
            return .blue

        case "Productivity":
            return .green

        case "Health & Fitness":
            return .red

        case "Shopping":
            return .orange

        case "Food & Dining":
            return .purple

        case "Education":
            return .teal

        default:
            return .gray
        }
    }
}
