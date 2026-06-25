//
//  AIInsightsView.swift
//  Spendora
//

import SwiftUI

struct AIInsightsView: View {
    let subscriptions: [Subscription]
    
    var totalSpending: Double {
        subscriptions.reduce(0) { $0 + $1.monthlyCost }
    }
    
    var averagePerSubscription: Double {
        guard !subscriptions.isEmpty else { return 0 }
        return totalSpending / Double(subscriptions.count)
    }
    
    var topCategory: String {
        let grouped = Dictionary(grouping: subscriptions) { $0.category }
        let categoryTotals = grouped.map { (cat, subs) in
            (category: cat, total: subs.reduce(0) { $0 + $1.monthlyCost })
        }
        return categoryTotals.max { $0.total < $1.total }?.category ?? "None"
    }
    
    var activeTrials: Int {
        subscriptions.filter { $0.isTrial && !$0.trialConvertedToPaid && $0.trialDaysRemaining > 0 }.count
    }
    
    var expiringTrials: Int {
        subscriptions.filter { $0.trialWarning }.count
    }
    
    var priceIncreasedCount: Int {
        subscriptions.filter { $0.priceIncreased }.count
    }
    
    var insights: [String] {
        var result: [String] = []
        
        // Spending insight
        if totalSpending > 100 {
            result.append("💡 You're spending over \(formatCurrency(totalSpending))/month on subscriptions. Consider reviewing which ones you actually use.")
        } else if totalSpending > 50 {
            result.append("📊 Your subscription spending is \(formatCurrency(totalSpending))/month. Track which services you use most.")
        }
        
        // Count insight
        if subscriptions.count > 10 {
            result.append("⚠️ You have \(subscriptions.count) active subscriptions. The average person uses only 4-5 regularly.")
        } else if subscriptions.count > 5 {
            result.append("📱 You have \(subscriptions.count) subscriptions. Make sure each one provides value.")
        }
        
        // Yearly insight
        let yearlyCount = subscriptions.filter { $0.isYearly }.count
        if yearlyCount > 3 {
            result.append("📅 You have \(yearlyCount) yearly subscriptions. Calculate if monthly would be cheaper for little-used services.")
        }
        
        // Trial insight
        if activeTrials > 0 {
            result.append("⏰ You have \(activeTrials) active trial\(activeTrials > 1 ? "s" : ""). \(expiringTrials > 0 ? "\(expiringTrials) ending soon!" : "Don't forget to cancel if not needed.")")
        }
        
        // Price increase insight
        if priceIncreasedCount > 0 {
            result.append("📈 \(priceIncreasedCount) subscription\(priceIncreasedCount > 1 ? "s have" : " has") increased in price. Review if still worth the cost.")
        }
        
        // Category insight
        if topCategory != "None" {
            result.append("🎯 Your highest spending category is \(topCategory) at \(formatCurrency(categoryTotal(topCategory)))/month.")
        }
        
        // Positive insight
        if result.isEmpty {
            result.append("✅ Your subscription spending looks healthy! Keep tracking to stay on top of your finances.")
        }
        
        return result
    }
    
    func categoryTotal(_ category: String) -> Double {
        subscriptions.filter { $0.category == category }.reduce(0) { $0 + $1.monthlyCost }
    }
    
    func formatCurrency(_ amount: Double) -> String {
        return String(format: "$%.2f", amount)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(.purple)
                Text("AI Spending Insights")
                    .font(.headline)
            }
            
            Divider()
            
            ForEach(insights, id: \.self) { insight in
                HStack(alignment: .top, spacing: 12) {
                    Text("•")
                        .foregroundColor(.purple)
                    Text(insight)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}
