//
//  YearlyReportView.swift
//

import SwiftUI
import Charts

// MARK: - YearlyReportView

struct YearlyReportView: View {
    let subscriptions: [Subscription]
    @Environment(\.dismiss) private var dismiss
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var showingShareSheet = false
    @State private var shareImage: UIImage?

    var totalMonthly: Double {
        subscriptions.reduce(0) { $0 + $1.monthlyCost }
    }

    var totalYearly: Double {
        subscriptions.reduce(0) { $0 + $1.yearlyCost }
    }

    var averageMonthly: Double {
        guard !subscriptions.isEmpty else { return 0 }
        return totalYearly / 12.0
    }

    var topCategory: String {
        let grouped = Dictionary(grouping: subscriptions) { $0.category }
        let totals = grouped.map { ($0.key, $0.value.reduce(0) { $0 + $1.monthlyCost }) }
        return totals.max { $0.1 < $1.1 }?.0 ?? "None"
    }

    var monthlyData: [(month: String, amount: Double)] {
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        return months.map { (month: $0, amount: totalMonthly) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Year Selector Header
                    YearSelectorBar(selectedYear: $selectedYear)
                    
                    // MARK: - Executive Financial Summary Card
                    ExecutiveYearlySummaryCard(
                        totalYearly: totalYearly,
                        averageMonthly: averageMonthly,
                        subscriptionCount: subscriptions.count,
                        topCategory: topCategory
                    )
                    
                    if !subscriptions.isEmpty {
                        // MARK: - Monthly Spending Trend Chart
                        ExecutiveMonthlyChart(monthlyData: monthlyData)
                        
                        // MARK: - Category Breakdown Table
                        ExecutiveCategoryTable(subscriptions: subscriptions)
                    }
                    
                    // MARK: - Share & Export Report Button
                    Button {
                        generateShareImage()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "square.and.arrow.up.fill")
                                .font(.headline)
                            Text("Export Executive Annual Statement")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [.brandPrimary, .brandSecondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(18)
                        .shadow(color: Color.brandPrimary.opacity(0.3), radius: 10, x: 0, y: 4)
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle("Annual Financial Report")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.brandPrimary)
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                if let image = shareImage {
                    ShareSheet(items: [image])
                }
            }
        }
    }

    private func generateShareImage() {
        let shareableView = ShareableYearlyReport(
            year: selectedYear,
            totalYearly: totalYearly,
            averageMonthly: averageMonthly,
            topCategory: topCategory
        )
        let renderer = ImageRenderer(content: shareableView)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            renderer.scale = windowScene.screen.scale
        }
        if let image = renderer.uiImage {
            shareImage = image
            showingShareSheet = true
        }
    }
}

// MARK: - Year Selector Bar

struct YearSelectorBar: View {
    @Binding var selectedYear: Int

    var body: some View {
        HStack {
            Button {
                selectedYear -= 1
            } label: {
                Image(systemName: "chevron.left.circle.fill")
                    .font(.title3)
                    .foregroundColor(.brandPrimary)
            }
            
            Spacer()
            
            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .foregroundColor(.brandPrimary)
                Text("\(selectedYear) Financial Year")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
            }
            
            Spacer()
            
            Button {
                selectedYear += 1
            } label: {
                Image(systemName: "chevron.right.circle.fill")
                    .font(.title3)
                    .foregroundColor(.brandPrimary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
    }
}

// MARK: - Executive Yearly Summary Card

struct ExecutiveYearlySummaryCard: View {
    let totalYearly: Double
    let averageMonthly: Double
    let subscriptionCount: Int
    let topCategory: String

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 4) {
                Text("ANNUAL SUBSCRIPTION COMMITMENT")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.textSecondary)
                    .tracking(1.5)
                
                Text(CurrencyManager.shared.format(totalYearly))
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)
            }
            
            Divider()
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Average / Month")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundColor(.textSecondary)
                    Text(CurrencyManager.shared.format(averageMonthly))
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.brandPrimary)
                }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 4) {
                    Text("Active Services")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundColor(.textSecondary)
                    Text("\(subscriptionCount)")
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Top Category")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundColor(.textSecondary)
                    Text(topCategory)
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.brandSecondary)
                }
            }
        }
        .padding(20)
        .background(Color.cardBackground)
        .cornerRadius(22)
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
    }
}

// MARK: - Executive Monthly Chart

struct ExecutiveMonthlyChart: View {
    let monthlyData: [(month: String, amount: Double)]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Monthly Run Rate Projection")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.textPrimary)
                Spacer()
                Text("12-Month Trend")
                    .font(.caption2)
                    .foregroundColor(.textSecondary)
            }
            
            Chart(monthlyData, id: \.month) { item in
                BarMark(
                    x: .value("Month", item.month),
                    y: .value("Amount", item.amount)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [.brandPrimary, .brandSecondary],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .cornerRadius(6)
            }
            .frame(height: 180)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .padding(18)
        .background(Color.cardBackground)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
    }
}

// MARK: - Executive Category Table

struct ExecutiveCategoryTable: View {
    let subscriptions: [Subscription]

    var totalSpend: Double {
        subscriptions.reduce(0) { $0 + $1.monthlyCost }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Category Financial Breakdown")
                .font(.system(.headline, design: .rounded))
                .foregroundColor(.textPrimary)
            
            let grouped = Dictionary(grouping: subscriptions) { $0.category }
            let sortedCategories = grouped.sorted {
                $0.value.reduce(0) { $0 + $1.monthlyCost } >
                $1.value.reduce(0) { $0 + $1.monthlyCost }
            }
            
            VStack(spacing: 10) {
                ForEach(sortedCategories, id: \.key) { category, subs in
                    let monthlyTotal = subs.reduce(0) { $0 + $1.monthlyCost }
                    let yearlyTotal = subs.reduce(0) { $0 + $1.yearlyCost }
                    let share = totalSpend > 0 ? (monthlyTotal / totalSpend) * 100 : 0
                    
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(category)
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.semibold)
                                .foregroundColor(.textPrimary)
                            
                            Text("\(subs.count) \(subs.count == 1 ? "subscription" : "subscriptions")")
                                .font(.caption2)
                                .foregroundColor(.textSecondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("\(CurrencyManager.shared.format(yearlyTotal))/yr")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.textPrimary)
                            
                            Text(String(format: "%.1f%% of total", share))
                                .font(.caption2)
                                .foregroundColor(.brandPrimary)
                        }
                    }
                    .padding(.vertical, 4)
                    
                    if category != sortedCategories.last?.key {
                        Divider()
                    }
                }
            }
        }
        .padding(18)
        .background(Color.cardBackground)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
    }
}
