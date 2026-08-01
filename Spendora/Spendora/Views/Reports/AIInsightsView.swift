//
//  AIInsightsView.swift
//

import SwiftUI

// MARK: - AIInsightsView

struct AIInsightsView: View {
    let subscriptions: [Subscription]
    @Environment(\.dismiss) private var dismiss

    var totalMonthly: Double {
        subscriptions.reduce(0) { $0 + $1.monthlyCost }
    }

    var totalYearly: Double {
        subscriptions.reduce(0) { $0 + $1.yearlyCost }
    }

    // AI Health Score calculation (0 - 100)
    var healthScore: Int {
        guard !subscriptions.isEmpty else { return 100 }
        var score = 95
        let underused = subscriptions.filter { $0.usageRating <= 2 }.count
        score -= (underused * 8)
        let endingTrials = subscriptions.filter { $0.isTrial && !$0.trialConvertedToPaid }.count
        score -= (endingTrials * 5)
        if totalMonthly > 150 { score -= 5 }
        return max(40, min(100, score))
    }

    var healthStatusText: String {
        switch healthScore {
        case 85...100: return "Optimal Efficiency"
        case 70...84: return "Good - Minor Savings Found"
        default: return "Requires Attention"
        }
    }

    var healthStatusColor: Color {
        switch healthScore {
        case 85...100: return .green
        case 70...84: return .orange
        default: return .red
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Executive AI Health Banner
                    AIHealthBannerView(
                        healthScore: healthScore,
                        statusText: healthStatusText,
                        statusColor: healthStatusColor,
                        subscriptionCount: subscriptions.count,
                        totalMonthly: totalMonthly
                    )
                    
                    if subscriptions.isEmpty {
                        EmptyInsightsView()
                    } else {
                        // MARK: - Smart Recommendations Section
                        VStack(alignment: .leading, spacing: 14) {
                            Text("AI Actionable Recommendations")
                                .font(.system(.headline, design: .rounded))
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal, 4)
                            
                            // Recommendation 1: Underused subscriptions
                            let underused = subscriptions.filter { $0.usageRating <= 2 }
                            if !underused.isEmpty {
                                let totalWaste = underused.reduce(0) { $0 + $1.monthlyCost }
                                AIRecommendationCard(
                                    icon: "exclamationmark.triangle.fill",
                                    iconColor: .orange,
                                    title: "Underused Subscriptions (\(underused.count))",
                                    description: "You have low usage for \(underused.map { $0.displayName }.joined(separator: ", ")). Cancelling could save you \(CurrencyManager.shared.format(totalWaste))/month (\(CurrencyManager.shared.format(totalWaste * 12))/yr).",
                                    badgeText: "High Impact"
                                )
                            }
                            
                            // Recommendation 2: Monthly to Yearly conversion
                            let monthlyOnly = subscriptions.filter { !$0.isYearly }
                            if !monthlyOnly.isEmpty {
                                let estimatedYearlySavings = monthlyOnly.reduce(0) { $0 + ($1.yearlyCost * 0.15) }
                                AIRecommendationCard(
                                    icon: "arrow.triangle.2.circlepath.circle.fill",
                                    iconColor: .brandPrimary,
                                    title: "Switch to Yearly Billing",
                                    description: "Converting \(monthlyOnly.count) monthly plan(s) to annual billing can save an estimated \(CurrencyManager.shared.format(estimatedYearlySavings))/year.",
                                    badgeText: "Save ~15%"
                                )
                            }
                            
                            // Recommendation 3: Active Trial Expiring
                            let trials = subscriptions.filter { $0.isTrial && !$0.trialConvertedToPaid }
                            if !trials.isEmpty {
                                AIRecommendationCard(
                                    icon: "clock.badge.exclamationmark.fill",
                                    iconColor: .purple,
                                    title: "Active Free Trial Alert",
                                    description: "You have \(trials.count) active trial(s) (\(trials.map { $0.displayName }.joined(separator: ", "))). Set reminders to decide before automatic billing starts.",
                                    badgeText: "Action Needed"
                                )
                            }
                        }
                        
                        // MARK: - Category Weight Distribution Card
                        SpendingDistributionView(subscriptions: subscriptions)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle("AI Financial Insights")
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
        }
    }
}

// MARK: - AI Health Banner View

struct AIHealthBannerView: View {
    let healthScore: Int
    let statusText: String
    let statusColor: Color
    let subscriptionCount: Int
    let totalMonthly: Double

    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: "sparkles")
                            .foregroundColor(.brandPrimary)
                            .font(.headline)
                        
                        Text("SPENDORA AI ADVISOR")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(.brandPrimary)
                            .tracking(1.2)
                    }
                    
                    Text("Portfolio Health Score")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    Text(statusText)
                        .font(.system(.caption, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(statusColor)
                }
                
                Spacer()
                
                // Score Gauge Ring
                ZStack {
                    Circle()
                        .stroke(Color.secondary.opacity(0.15), lineWidth: 8)
                        .frame(width: 68, height: 68)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(healthScore) / 100.0)
                        .stroke(
                            LinearGradient(
                                colors: [statusColor, statusColor.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 68, height: 68)
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 0) {
                        Text("\(healthScore)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.textPrimary)
                        Text("/100")
                            .font(.system(size: 9, weight: .medium, design: .rounded))
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Monthly Run Rate")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundColor(.textSecondary)
                    Text(CurrencyManager.shared.format(totalMonthly))
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Active Services")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundColor(.textSecondary)
                    Text("\(subscriptionCount) Subscriptions")
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.brandPrimary)
                }
            }
        }
        .padding(18)
        .background(Color.cardBackground)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
    }
}

// MARK: - AI Recommendation Card

struct AIRecommendationCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    let badgeText: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 42, height: 42)
                Image(systemName: icon)
                    .font(.headline)
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(title)
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    Text(badgeText)
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(iconColor.opacity(0.15))
                        .foregroundColor(iconColor)
                        .cornerRadius(8)
                }
                
                Text(description)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
    }
}

// MARK: - Spending Distribution View

struct SpendingDistributionView: View {
    let subscriptions: [Subscription]

    var totalSpend: Double {
        subscriptions.reduce(0) { $0 + $1.monthlyCost }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Category Allocation")
                .font(.system(.headline, design: .rounded))
                .foregroundColor(.textPrimary)
            
            let grouped = Dictionary(grouping: subscriptions) { $0.category }
            let sortedCategories = grouped.sorted {
                $0.value.reduce(0) { $0 + $1.monthlyCost } >
                $1.value.reduce(0) { $0 + $1.monthlyCost }
            }
            
            ForEach(sortedCategories, id: \.key) { category, subs in
                let total = subs.reduce(0) { $0 + $1.monthlyCost }
                let percentage = totalSpend > 0 ? (total / totalSpend) * 100 : 0
                let color = categoryColor(for: category)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(category)
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(.textPrimary)
                        
                        Text("(\(subs.count))")
                            .font(.caption2)
                            .foregroundColor(.textSecondary)
                        
                        Spacer()
                        
                        Text("\(CurrencyManager.shared.format(total))")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.textPrimary)
                        
                        Text(String(format: "(%.0f%%)", percentage))
                            .font(.caption2)
                            .foregroundColor(.textSecondary)
                    }
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.secondary.opacity(0.12))
                                .frame(height: 8)
                            
                            Capsule()
                                .fill(color)
                                .frame(width: max(8, geo.size.width * CGFloat(percentage / 100.0)), height: 8)
                        }
                    }
                    .frame(height: 8)
                }
                .padding(.vertical, 4)
            }
        }
        .padding(18)
        .background(Color.cardBackground)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
    }

    private func categoryColor(for category: String) -> Color {
        switch category {
        case "Entertainment": return .categoryEntertainment
        case "Music": return Color(hex: "#1DB954")
        case "AI & Tools": return Color(hex: "#8B5CF6")
        case "Productivity": return .categoryProductivity
        case "Health & Fitness": return .categoryHealth
        case "Shopping": return .categoryShopping
        case "Food & Dining": return .categoryFood
        case "Education": return .categoryEducation
        case "Services": return Color(hex: "#0EA5E9")
        default: return Color(hex: "#6C63FF")
        }
    }
}

// MARK: - Empty Insights View

struct EmptyInsightsView: View {
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.brandPrimary.opacity(0.12))
                    .frame(width: 80, height: 80)
                Image(systemName: "sparkles")
                    .font(.system(size: 36))
                    .foregroundColor(.brandPrimary)
            }
            
            Text("No Subscriptions Added")
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Text("Add your first subscription to generate AI-powered optimization insights.")
                .font(.system(.body, design: .rounded))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
        .background(Color.cardBackground)
        .cornerRadius(20)
    }
}
