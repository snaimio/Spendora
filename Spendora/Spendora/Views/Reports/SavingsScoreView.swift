//
//  SavingsScoreView.swift
//  Spendora
//

import SwiftUI

struct SavingsScoreView: View {
    let subscriptions: [Subscription]
    @Environment(\.dismiss) private var dismiss
    @State private var showingShareSheet = false
    @State private var shareImage: UIImage?
    
    var savingsScore: Int {
        let total = subscriptions.reduce(0) { $0 + $1.monthlyCost }
        let count = subscriptions.count
        let countScore = max(0, 100 - (count * 5))
        let spendingScore = max(0, 100 - Int(total / 10))
        return min(100, (countScore + spendingScore) / 2)
    }
    
    var recommendations: [String] {
        var result: [String] = []
        let total = subscriptions.reduce(0) { $0 + $1.monthlyCost }
        let count = subscriptions.count
        
        if count > 5 {
            result.append("📉 You have \(count) subscriptions. Consider canceling unused ones.")
        }
        if total > 100 {
            result.append("💰 You're spending over $100/month. Review your subscriptions.")
        }
        let trials = subscriptions.filter { $0.isTrial && !$0.trialConvertedToPaid }
        if !trials.isEmpty {
            result.append("⏰ \(trials.count) trial(s) ending soon. Don't forget to cancel if not needed.")
        }
        if result.isEmpty {
            result.append("🌟 Great job! Your subscription spending is under control.")
        }
        return result
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    SavingsScoreHeaderView(
                        savingsScore: savingsScore,
                        recommendations: recommendations,
                        subscriptions: subscriptions
                    )
                    
                    ShareReportButton {
                        generateShareImage()
                    }
                }
                .padding()
            }
            .navigationTitle("Savings Score")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // ✅ ADDED DONE BUTTON
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
        let renderer = ImageRenderer(
            content: ShareableScoreCard(
                score: savingsScore,
                count: subscriptions.count,
                total: subscriptions.reduce(0) { $0 + $1.monthlyCost }
            )
        )
        if let image = renderer.uiImage {
            shareImage = image
            showingShareSheet = true
        }
    }
}

// MARK: - Savings Score Header
struct SavingsScoreHeaderView: View {
    let savingsScore: Int
    let recommendations: [String]
    let subscriptions: [Subscription]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "star.circle.fill")
                    .foregroundColor(.yellow)
                    .font(.title2)
                
                Text("Savings Score")
                    .font(.headline)
                
                Spacer()
                
                Text("\(savingsScore)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(savingsScore > 70 ? .green : .orange)
            }
            
            Divider()
            
            ForEach(recommendations, id: \.self) { recommendation in
                Text(recommendation)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
    }
}
