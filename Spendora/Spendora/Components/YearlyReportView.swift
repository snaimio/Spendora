//
//  YearlyReportView.swift
//  Spendora
//

import SwiftUI
import Charts

struct YearlyReportView: View {
    let subscriptions: [Subscription]
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var showingShareSheet = false
    @State private var shareImage: UIImage?
    
    var monthlyData: [(month: String, amount: Double)] {
        let calendar = Calendar.current
        let currentDate = Date()
        var result: [(month: String, amount: Double)] = []
        
        for i in 0..<12 {
            guard let date = calendar.date(byAdding: .month, value: -i, to: currentDate) else {
                continue
            }
            
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MMM"
            let month = monthFormatter.string(from: date)
            
            // Calculate total for this month (using current data since historical data isn't available)
            let total = subscriptions.reduce(0) { $0 + $1.monthlyCost }
            result.append((month: month, amount: total))
        }
        
        return result.reversed()
    }
    
    var totalYearly: Double {
        subscriptions.reduce(0) { $0 + $1.yearlyCost }
    }
    
    var averageMonthly: Double {
        guard !subscriptions.isEmpty else { return 0 }
        return totalYearly / 12
    }
    
    var topCategory: String {
        let grouped = Dictionary(grouping: subscriptions) { $0.category }
        let totals = grouped.map { ($0.key, $0.value.reduce(0) { $0 + $1.monthlyCost }) }
        return totals.max { $0.1 < $1.1 }?.0 ?? "None"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Year Selector
                    HStack {
                        Button {
                            selectedYear -= 1
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.brandPrimary)
                        }
                        
                        Spacer()
                        
                        Text("\(selectedYear)")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button {
                            selectedYear += 1
                        } label: {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.brandPrimary)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Summary Cards
                    HStack(spacing: 16) {
                        YearlyStatCard(
                            title: "Total Yearly",
                            value: CurrencyManager.shared.format(totalYearly),
                            icon: "calendar",
                            color: .brandPrimary
                        )
                        
                        YearlyStatCard(
                            title: "Monthly Avg",
                            value: CurrencyManager.shared.format(averageMonthly),
                            icon: "chart.line.uptrend.xyaxis",
                            color: .brandSecondary
                        )
                    }
                    
                    // Monthly Trend Chart
                    if !subscriptions.isEmpty {
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
                    
                    // Top Category
                    if topCategory != "None" {
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
                    
                    // Share Button
                    Button {
                        generateShareImage()
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share Yearly Report")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Yearly Report")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingShareSheet) {
                if let image = shareImage {
                    ShareSheet(items: [image])
                }
            }
        }
    }
    
    private func generateShareImage() {
        let renderer = ImageRenderer(
            content: ShareableYearlyReport(
                year: selectedYear,
                totalYearly: totalYearly,
                averageMonthly: averageMonthly,
                topCategory: topCategory
            )
        )
        
        if let image = renderer.uiImage {
            shareImage = image
            showingShareSheet = true
        }
    }
}

// MARK: - Yearly Stat Card
struct YearlyStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.headline)
                    .fontWeight(.bold)
            }
            Spacer()
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 5)
    }
}

// MARK: - Shareable Yearly Report
struct ShareableYearlyReport: View {
    let year: Int
    let totalYearly: Double
    let averageMonthly: Double
    let topCategory: String
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("\(year) Spending Report")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Image(systemName: "creditcard.and.123")
                .font(.system(size: 50))
                .foregroundStyle(Color.primaryGradient)
            
            VStack(spacing: 16) {
                HStack {
                    Text("Total Yearly")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(CurrencyManager.shared.format(totalYearly))
                        .font(.title3)
                        .fontWeight(.bold)
                }
                
                HStack {
                    Text("Monthly Average")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(CurrencyManager.shared.format(averageMonthly))
                        .font(.title3)
                        .fontWeight(.bold)
                }
                
                if topCategory != "None" {
                    HStack {
                        Text("Top Category")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(topCategory)
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            
            Text("Generated by Spendora")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
        .frame(width: 350, height: 450)
        .background(Color(.systemBackground))
    }
}
