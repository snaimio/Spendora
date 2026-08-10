//
//  AIInsightsView.swift
//  Spendora
//

import SwiftUI

// MARK: - AIInsightsView

/**
 `AIInsightsView` delivers executive AI financial intelligence, portfolio audits, duplicate detection,
 and category spending analysis with Spendora Teal brand system.
 */
struct AIInsightsView: View {

    // MARK: - Properties

    let subscriptions: [Subscription]
    @Environment(\.dismiss) private var dismiss

    private var activeSubscriptions: [Subscription] {
        subscriptions.filter { !$0.isCancelled }
    }

    private var totalMonthly: Double {
        activeSubscriptions.reduce(0) { $0 + $1.monthlyCost }
    }

    private var totalYearly: Double {
        activeSubscriptions.reduce(0) { $0 + $1.yearlyCost }
    }

    private var fiveYearProjection: Double {
        totalYearly * 5.0
    }

    private var healthScore: Int {
        guard !activeSubscriptions.isEmpty else { return 100 }
        var score = 100
        
        let lowUsage = activeSubscriptions.filter { $0.usageRating <= 2 }
        score -= (lowUsage.count * 12)
        
        let categoryGrouped = Dictionary(grouping: activeSubscriptions) { $0.effectiveCategory }
        let duplicateCategories = categoryGrouped.filter { $0.value.count > 1 }
        score -= (duplicateCategories.count * 8)
        
        let activeTrials = activeSubscriptions.filter { $0.isTrial && !$0.trialConvertedToPaid }
        score -= (activeTrials.count * 5)
        
        return max(35, min(100, score))
    }

    private var healthStatusText: String {
        switch healthScore {
        case 85...100: return "Optimal Financial Health"
        case 70...84: return "Good • Moderate Optimization Found"
        default: return "Requires Attention • High Dollar Leakage"
        }
    }

    private var healthStatusColor: Color {
        switch healthScore {
        case 85...100: return Color(hex: "#00D4AA")
        case 70...84: return Color(hex: "#FFD93D")
        default: return Color(hex: "#FF6B6B")
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                SpendoraBrandBackgroundView()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // MARK: - Executive AI Health Banner
                        AIHealthBannerView(
                            healthScore: healthScore,
                            statusText: healthStatusText,
                            statusColor: healthStatusColor,
                            subscriptionCount: activeSubscriptions.count,
                            totalMonthly: totalMonthly,
                            totalYearly: totalYearly,
                            fiveYearProjection: fiveYearProjection
                        )
                        
                        if activeSubscriptions.isEmpty {
                            EmptyInsightsView()
                        } else {
                            // MARK: - Smart AI Audit Recommendations
                            VStack(alignment: .leading, spacing: 14) {
                                HStack(spacing: 6) {
                                    Image(systemName: "sparkles")
                                        .font(.headline)
                                        .foregroundColor(Color(hex: "#00D4AA"))
                                    Text("AI Financial Audits & Opportunities")
                                        .font(.system(.headline, design: .rounded))
                                        .foregroundColor(.textPrimary)
                                }
                                .padding(.horizontal, 4)
                                
                                // Audit 1: Duplicate / Overlapping Service Detector
                                let categoryGrouped = Dictionary(grouping: activeSubscriptions) { $0.effectiveCategory }
                                let overlappingCategories = categoryGrouped.filter { $0.value.count > 1 }
                                
                                if let topOverlap = overlappingCategories.max(by: { $0.value.count < $1.value.count }) {
                                    let combinedCost = topOverlap.value.reduce(0) { $0 + $1.monthlyCost }
                                    AIRecommendationCard(
                                        icon: "rectangle.stack.fill",
                                        iconColor: Color(hex: "#6C5CE7"),
                                        title: "Overlapping \(topOverlap.key) Services (\(topOverlap.value.count))",
                                        description: "You have \(topOverlap.value.count) active services in \(topOverlap.key) (\(topOverlap.value.map { $0.displayName }.joined(separator: ", "))). Combining or alternating these services could save you up to \(CurrencyManager.shared.format(combinedCost * 0.5))/month (\(CurrencyManager.shared.format(combinedCost * 6))/year).",
                                        badgeText: "Overlap Detected"
                                    )
                                }
                                
                                // Audit 2: Underused Subscriptions (VFM Audit)
                                let underused = activeSubscriptions.filter { $0.usageRating <= 2 }
                                if !underused.isEmpty {
                                    let totalWaste = underused.reduce(0) { $0 + $1.monthlyCost }
                                    AIRecommendationCard(
                                        icon: "exclamationmark.triangle.fill",
                                        iconColor: Color(hex: "#FF6B6B"),
                                        title: "Low Value-for-Money (\(underused.count) Services)",
                                        description: "Services with low rating: \(underused.map { $0.displayName }.joined(separator: ", ")). Cancelling these unneeded memberships saves \(CurrencyManager.shared.format(totalWaste))/month (\(CurrencyManager.shared.format(totalWaste * 12))/yr).",
                                        badgeText: "High Impact"
                                    )
                                }
                                
                                // Audit 3: Monthly to Yearly Conversion Arbitrage
                                let monthlyOnly = activeSubscriptions.filter { !$0.isYearly && !$0.isOneTime }
                                if !monthlyOnly.isEmpty {
                                    let estimatedYearlySavings = monthlyOnly.reduce(0) { $0 + ($1.yearlyCost * 0.16) }
                                    AIRecommendationCard(
                                        icon: "arrow.triangle.2.circlepath.circle.fill",
                                        iconColor: Color(hex: "#00D4AA"),
                                        title: "Switch Monthly Plans to Annual Upfront",
                                        description: "Converting \(monthlyOnly.count) monthly subscription(s) to annual billing unlocks an average 16% discount, saving ~\(CurrencyManager.shared.format(estimatedYearlySavings))/year.",
                                        badgeText: "Save ~16%"
                                    )
                                }
                                
                                // Audit 4: Active Free Trial Radar
                                let trials = activeSubscriptions.filter { $0.isTrial && !$0.trialConvertedToPaid }
                                if !trials.isEmpty {
                                    AIRecommendationCard(
                                        icon: "clock.badge.exclamationmark.fill",
                                        iconColor: Color(hex: "#FFD93D"),
                                        title: "Free Trial Expiration Radar",
                                        description: "You have \(trials.count) active trial(s) (\(trials.map { $0.displayName }.joined(separator: ", "))). Set advance reminders to prevent unexpected auto-charges.",
                                        badgeText: "Action Needed"
                                    )
                                }
                            }
                            
                            // MARK: - Category Allocation & Spend Weight
                            SpendingDistributionView(subscriptions: activeSubscriptions)
                            
                            // MARK: - Executive AI Financial Optimization Tips
                            AIOptimizationTipsView()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                }
            }
            .navigationTitle("AI Financial Insights")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#00D4AA"))
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
    let totalYearly: Double
    let fiveYearProjection: Double

    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: "sparkles")
                            .foregroundColor(Color(hex: "#00D4AA"))
                            .font(.headline)
                        
                        Text("SPENDORA AI ADVISOR")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#00D4AA"))
                            .tracking(1.2)
                    }
                    
                    Text("Portfolio Health Score")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    Text(statusText)
                        .font(.system(.caption, design: .rounded))
                        .fontWeight(.bold)
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
                .background(Color.secondary.opacity(0.2))
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Monthly Total")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundColor(.textSecondary)
                    Text(CurrencyManager.shared.format(totalMonthly))
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#00D4AA"))
                }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 2) {
                    Text("Yearly Commitment")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundColor(.textSecondary)
                    Text(CurrencyManager.shared.format(totalYearly))
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#00B4D8"))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("5-Yr Projection")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundColor(.textSecondary)
                    Text(CurrencyManager.shared.format(fiveYearProjection))
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#FFD93D"))
                }
            }
        }
        .padding(18)
        .spendora3DCard(cornerRadius: 20)
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
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
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
        .spendora3DCard(cornerRadius: 18)
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
            Text("Category Allocation & Spend Weight")
                .font(.system(.headline, design: .rounded))
                .foregroundColor(.textPrimary)
            
            let grouped = Dictionary(grouping: subscriptions) { $0.effectiveCategory }
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
        .spendora3DCard(cornerRadius: 20)
    }

    private func categoryColor(for category: String) -> Color {
        switch category {
        case "Entertainment": return .categoryEntertainment
        case "Music": return .categoryMusic
        case "AI & Tools": return .categoryAiTools
        case "Productivity": return .categoryProductivity
        case "Health & Fitness": return .categoryHealth
        case "Shopping": return .categoryShopping
        case "Food & Dining": return .categoryFood
        case "Education": return .categoryEducation
        case "Gaming": return .categoryGaming
        case "Utilities": return .categoryUtilities
        default: return .categoryOther
        }
    }
}

// MARK: - AI Optimization Tips View

struct AIOptimizationTipsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 6) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(Color(hex: "#FFD93D"))
                    .font(.headline)
                Text("Executive Financial Tips")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.textPrimary)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                TipRow(
                    number: "1",
                    title: "Family Plan Pooling",
                    description: "Share Apple One, Spotify, or YouTube Premium with family members to cut individual monthly costs by up to 50%."
                )
                
                TipRow(
                    number: "2",
                    title: "Rotate Streaming Services",
                    description: "Avoid subscribing to 4+ video streaming platforms simultaneously. Rotate monthly based on show releases."
                )
                
                TipRow(
                    number: "3",
                    title: "Annual Billing Arbitrage",
                    description: "Always audit subscriptions before renewal dates. Upfront yearly plans offer discounts equal to 2 free months per year."
                )
            }
        }
        .padding(18)
        .spendora3DCard(cornerRadius: 20)
    }
}

struct TipRow: View {
    let number: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#0F0F1A"))
                .frame(width: 24, height: 24)
                .background(Color(hex: "#00D4AA"))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                
                Text(description)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// MARK: - Empty Insights View

struct EmptyInsightsView: View {
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(hex: "#00D4AA").opacity(0.15))
                    .frame(width: 80, height: 80)
                Image(systemName: "sparkles")
                    .font(.system(size: 36))
                    .foregroundColor(Color(hex: "#00D4AA"))
            }
            
            Text("No Subscriptions Added")
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Text("Add your first subscription to generate AI-powered optimization insights and portfolio audits.")
                .font(.system(.body, design: .rounded))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
        .spendora3DCard(cornerRadius: 20)
    }
}
