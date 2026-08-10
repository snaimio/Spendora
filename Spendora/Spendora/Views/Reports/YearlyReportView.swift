//
//  YearlyReportView.swift
//  Spendora
//

import SwiftUI
import Charts

// MARK: - ReportChartVariation Enum

enum ReportChartVariation: String, CaseIterable, Identifiable {
    case monthlyRunRate = "Monthly Bar"
    case categoryDonut = "Category Donut"
    case areaTrend = "Area Trend"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .monthlyRunRate: return "chart.bar.fill"
        case .categoryDonut: return "chart.pie.fill"
        case .areaTrend: return "chart.xyaxis.line"
        }
    }
}

// MARK: - YearlyReportView (Apple HIG Dynamic Annual Financial Report)

struct YearlyReportView: View {
    let subscriptions: [Subscription]
    @Environment(\.dismiss) private var dismiss
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var selectedVariation: ReportChartVariation = .monthlyRunRate
    @State private var showingShareSheet = false
    @State private var shareImage: UIImage?

    private let monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    // MARK: - Year-Aware Computations

    /// Subscriptions that were active at any point during the selected year
    private var activeSubscriptionsForYear: [Subscription] {
        let calendar = Calendar.current
        return subscriptions.filter { sub in
            let createdYear = calendar.component(.year, from: sub.createdAt)
            
            // If subscription was created in a future year beyond selectedYear, exclude it
            if createdYear > selectedYear {
                return false
            }
            
            // If subscription was cancelled before selectedYear started, exclude it
            if sub.isCancelled, let cancelDate = sub.cancellationDate {
                let cancelYear = calendar.component(.year, from: cancelDate)
                if cancelYear < selectedYear {
                    return false
                }
            }
            
            return true
        }
    }

    /// Monthly cost breakdown for the 12 months of selectedYear
    private var monthlyData: [(month: String, amount: Double)] {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        return (1...12).map { monthIndex in
            let monthName = monthNames[monthIndex - 1]
            
            let monthSpend = activeSubscriptionsForYear.reduce(0.0) { sum, sub in
                let createdYear = calendar.component(.year, from: sub.createdAt)
                let createdMonth = calendar.component(.month, from: sub.createdAt)
                
                // If created during selectedYear but after this month, don't charge (unless in future year projection)
                if selectedYear == createdYear && monthIndex < createdMonth && selectedYear <= currentYear {
                    return sum
                }
                
                // If cancelled during selectedYear before this month, don't charge
                if sub.isCancelled, let cancelDate = sub.cancellationDate {
                    let cancelYear = calendar.component(.year, from: cancelDate)
                    let cancelMonth = calendar.component(.month, from: cancelDate)
                    if cancelYear == selectedYear && monthIndex > cancelMonth {
                        return sum
                    }
                }
                
                if sub.isOneTime {
                    return (createdYear == selectedYear && createdMonth == monthIndex) ? sum + sub.cost : sum
                } else if sub.isYearly {
                    let renewMonth = calendar.component(.month, from: sub.nextBillingDate)
                    // Charges in the annual renewal month
                    return (renewMonth == monthIndex) ? sum + sub.cost : sum
                } else {
                    // Regular monthly recurring subscription
                    return sum + sub.monthlyCost
                }
            }
            
            return (month: monthName, amount: monthSpend)
        }
    }

    private var totalYearly: Double {
        monthlyData.reduce(0.0) { $0 + $1.amount }
    }

    private var averageMonthly: Double {
        totalYearly / 12.0
    }

    private var categoryData: [(category: String, amount: Double)] {
        let calendar = Calendar.current
        var categoryTotals: [String: Double] = [:]
        
        for sub in activeSubscriptionsForYear {
            let cat = sub.effectiveCategory
            let subAnnualSpend: Double
            if sub.isOneTime {
                let createdYear = calendar.component(.year, from: sub.createdAt)
                subAnnualSpend = (createdYear == selectedYear) ? sub.cost : 0.0
            } else if sub.isYearly {
                subAnnualSpend = sub.cost
            } else {
                subAnnualSpend = sub.monthlyCost * 12.0
            }
            
            if subAnnualSpend > 0 {
                categoryTotals[cat, default: 0.0] += subAnnualSpend
            }
        }
        
        return categoryTotals.map { (category: $0.key, amount: $0.value) }
            .sorted { $0.amount > $1.amount }
    }

    private var topCategory: String {
        categoryData.first?.category ?? "None"
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SpendoraTheme.sectionSpacing) {
                    // MARK: - Year Selector Header
                    YearSelectorBar(selectedYear: $selectedYear)
                    
                    // MARK: - Executive Financial Summary Card
                    ExecutiveYearlySummaryCard(
                        year: selectedYear,
                        totalYearly: totalYearly,
                        averageMonthly: averageMonthly,
                        subscriptionCount: activeSubscriptionsForYear.count,
                        topCategory: topCategory
                    )
                    
                    if !activeSubscriptionsForYear.isEmpty && totalYearly > 0 {
                        // MARK: - Chart Variation Picker Segment
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Financial Visualizations")
                                    .font(.headline)
                                    .foregroundColor(Color(.label))
                                Spacer()
                            }
                            
                            Picker("Chart Variation", selection: $selectedVariation) {
                                ForEach(ReportChartVariation.allCases) { variation in
                                    Label(variation.rawValue, systemImage: variation.icon)
                                        .tag(variation)
                                }
                            }
                            .pickerStyle(.segmented)
                            
                            // Dynamic Chart Variation View
                            switch selectedVariation {
                            case .monthlyRunRate:
                                ExecutiveMonthlyChart(monthlyData: monthlyData, year: selectedYear)
                            case .categoryDonut:
                                ReportDonutChart(categoryData: categoryData, totalYearly: totalYearly)
                            case .areaTrend:
                                ReportAreaTrendChart(monthlyData: monthlyData, year: selectedYear)
                            }
                        }
                        
                        // MARK: - Category Breakdown Table
                        ExecutiveCategoryTable(categoryData: categoryData, totalYearly: totalYearly)
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "calendar.badge.exclamationmark")
                                .font(.system(size: 40))
                                .foregroundColor(Color(.secondaryLabel))
                            Text("No Subscriptions in \(selectedYear)")
                                .font(.headline)
                                .foregroundColor(Color(.label))
                            Text("There were no active subscriptions or renewal commitments recorded for this financial year.")
                                .font(.subheadline)
                                .foregroundColor(Color(.secondaryLabel))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous)
                                .stroke(Color(.separator), lineWidth: 0.5)
                        )
                    }
                    
                    // MARK: - Share & Export Report Button
                    Button {
                        generateShareImage()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.up.fill")
                                .font(.system(size: 15, weight: .semibold))
                            Text("Export \(selectedYear) Executive Statement")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(SpendoraTheme.accent)
                        .clipShape(RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous))
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, SpendoraTheme.cardPadding)
                .padding(.vertical, 16)
            }
            .background(Color(.systemBackground).ignoresSafeArea())
            .navigationTitle("Annual Financial Report")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(SpendoraTheme.accent)
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
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    selectedYear -= 1
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(SpendoraTheme.accent)
                    .frame(width: 36, height: 36)
                    .background(SpendoraTheme.accentTint)
                    .clipShape(Circle())
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .foregroundColor(SpendoraTheme.accent)
                Text("\(selectedYear) Financial Year")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(Color(.label))
            }
            
            Spacer()
            
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    selectedYear += 1
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(SpendoraTheme.accent)
                    .frame(width: 36, height: 36)
                    .background(SpendoraTheme.accentTint)
                    .clipShape(Circle())
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous)
                .stroke(Color(.separator), lineWidth: 0.5)
        )
    }
}

// MARK: - Executive Yearly Summary Card

struct ExecutiveYearlySummaryCard: View {
    let year: Int
    let totalYearly: Double
    let averageMonthly: Double
    let subscriptionCount: Int
    let topCategory: String

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 6) {
                Text("\(year) ANNUAL SUBSCRIPTION COMMITMENT")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(.secondaryLabel))
                    .textCase(.uppercase)
                    .tracking(1.0)
                
                Text(CurrencyManager.shared.format(totalYearly))
                    .font(.system(size: 38, weight: .semibold, design: .rounded))
                    .monospacedDigit()
                    .foregroundColor(Color(.label))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            
            Divider()
            
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Average / Month")
                        .font(.caption)
                        .foregroundColor(Color(.secondaryLabel))
                    Text(CurrencyManager.shared.format(averageMonthly))
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .monospacedDigit()
                        .foregroundColor(SpendoraTheme.accentText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 3) {
                    Text("Active Services")
                        .font(.caption)
                        .foregroundColor(Color(.secondaryLabel))
                    Text("\(subscriptionCount)")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(.label))
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 3) {
                    Text("Top Category")
                        .font(.caption)
                        .foregroundColor(Color(.secondaryLabel))
                    Text(topCategory)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(.label))
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
            }
        }
        .padding(SpendoraTheme.cardPadding)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous)
                .stroke(Color(.separator), lineWidth: 0.5)
        )
    }
}

// MARK: - Executive Monthly Chart

struct ExecutiveMonthlyChart: View {
    let monthlyData: [(month: String, amount: Double)]
    let year: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("\(year) Monthly Spending Distribution")
                    .font(.headline)
                    .foregroundColor(Color(.label))
                Spacer()
                Text("12-Month Run")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(Color(.secondaryLabel))
            }
            
            Chart(monthlyData, id: \.month) { item in
                BarMark(
                    x: .value("Month", item.month),
                    y: .value("Amount", item.amount)
                )
                .foregroundStyle(SpendoraTheme.accent)
                .cornerRadius(4)
            }
            .frame(height: 180)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .padding(SpendoraTheme.cardPadding)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous)
                .stroke(Color(.separator), lineWidth: 0.5)
        )
    }
}

// MARK: - Report Donut Chart

struct ReportDonutChart: View {
    let categoryData: [(category: String, amount: Double)]
    let totalYearly: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Category Spending Share")
                .font(.headline)
                .foregroundColor(Color(.label))
            
            ZStack {
                Chart(categoryData, id: \.category) { item in
                    SectorMark(
                        angle: .value("Spending", item.amount),
                        innerRadius: .ratio(0.65),
                        angularInset: 1.5
                    )
                    .cornerRadius(4)
                    .foregroundStyle(by: .value("Category", item.category))
                }
                .frame(height: 200)
                
                VStack(spacing: 2) {
                    Text("ANNUAL SPEND")
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                        .foregroundColor(Color(.secondaryLabel))
                    Text(CurrencyManager.shared.format(totalYearly))
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .monospacedDigit()
                        .foregroundColor(Color(.label))
                }
            }
        }
        .padding(SpendoraTheme.cardPadding)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous)
                .stroke(Color(.separator), lineWidth: 0.5)
        )
    }
}

// MARK: - Report Area Trend Chart

struct ReportAreaTrendChart: View {
    let monthlyData: [(month: String, amount: Double)]
    let year: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("\(year) Annual Trend Projection")
                    .font(.headline)
                    .foregroundColor(Color(.label))
                Spacer()
                Text("Area Trend")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(Color(.secondaryLabel))
            }
            
            Chart(monthlyData, id: \.month) { item in
                AreaMark(
                    x: .value("Month", item.month),
                    y: .value("Amount", item.amount)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [SpendoraTheme.accent.opacity(0.4), SpendoraTheme.accent.opacity(0.05)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                LineMark(
                    x: .value("Month", item.month),
                    y: .value("Amount", item.amount)
                )
                .foregroundStyle(SpendoraTheme.accent)
                .lineStyle(StrokeStyle(lineWidth: 2.5))
            }
            .frame(height: 180)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .padding(SpendoraTheme.cardPadding)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous)
                .stroke(Color(.separator), lineWidth: 0.5)
        )
    }
}

// MARK: - Executive Category Table

struct ExecutiveCategoryTable: View {
    let categoryData: [(category: String, amount: Double)]
    let totalYearly: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Category Financial Breakdown")
                .font(.headline)
                .foregroundColor(Color(.label))
            
            VStack(spacing: 8) {
                ForEach(categoryData, id: \.category) { item in
                    let share = totalYearly > 0 ? (item.amount / totalYearly) * 100 : 0
                    
                    HStack(alignment: .center) {
                        Text(item.category)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color(.label))
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("\(CurrencyManager.shared.format(item.amount))/yr")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .monospacedDigit()
                                .foregroundColor(Color(.label))
                            
                            Text(String(format: "%.1f%% of total", share))
                                .font(.caption2.weight(.medium))
                                .foregroundColor(SpendoraTheme.accentText)
                        }
                    }
                    .padding(.vertical, 4)
                    
                    if item.category != categoryData.last?.category {
                        Divider()
                    }
                }
            }
        }
        .padding(SpendoraTheme.cardPadding)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: SpendoraTheme.cardRadius, style: .continuous)
                .stroke(Color(.separator), lineWidth: 0.5)
        )
    }
}

// MARK: - Shareable Yearly Report Canvas

struct ShareableYearlyReport: View {
    let year: Int
    let totalYearly: Double
    let averageMonthly: Double
    let topCategory: String

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image("SpendoraLogo")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                Text("Spendora Financial Statement")
                    .font(.headline)
                Spacer()
                Text("\(year)")
                    .font(.title2.weight(.bold))
                    .foregroundColor(SpendoraTheme.accent)
            }

            Divider()

            VStack(spacing: 6) {
                Text("ANNUAL TOTAL EXPENDITURE")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Text(CurrencyManager.shared.format(totalYearly))
                    .font(.system(size: 36, weight: .bold, design: .rounded))
            }

            HStack {
                VStack {
                    Text("Monthly Avg")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(CurrencyManager.shared.format(averageMonthly))
                        .font(.headline)
                }
                Spacer()
                VStack {
                    Text("Top Category")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(topCategory)
                        .font(.headline)
                }
            }
        }
        .padding(24)
        .frame(width: 360)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
