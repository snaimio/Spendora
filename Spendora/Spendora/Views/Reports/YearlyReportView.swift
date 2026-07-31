//
//  YearlyReportView.swift
//  Spendora
//

import SwiftUI
import Charts

struct YearlyReportView: View {
    let subscriptions: [Subscription]
    @Environment(\.dismiss) private var dismiss
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
                    YearSelectorView(selectedYear: $selectedYear)
                    
                    YearlyReportSummary(
                        totalYearly: totalYearly,
                        averageMonthly: averageMonthly
                    )
                    
                    if !subscriptions.isEmpty {
                        MonthlyTrendChartView(monthlyData: monthlyData)
                    }
                    
                    if topCategory != "None" {
                        TopCategoryView(topCategory: topCategory)
                    }
                    
                    ShareReportButton {
                        generateShareImage()
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Yearly Report")
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
        
        // ✅ FIXED: Use windowScene instead of UIScreen.main (deprecated)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            renderer.scale = windowScene.screen.scale
        }
        
        if let image = renderer.uiImage {
            shareImage = image
            showingShareSheet = true
        } else {
            print("Failed to generate share image")
        }
    }
}

// MARK: - Year Selector
struct YearSelectorView: View {
    @Binding var selectedYear: Int
    
    var body: some View {
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
            
            Button {
                selectedYear += 1
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.brandPrimary)
            }
        }
        .padding(.horizontal)
    }
}
