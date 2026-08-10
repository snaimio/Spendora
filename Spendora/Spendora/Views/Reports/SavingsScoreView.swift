//
//  SavingsScoreView.swift
//  Spendora
//

import SwiftUI

// MARK: - SavingsScoreView

/**
 `SavingsScoreView` delivers gamified financial health scores and actionable optimization recommendations
 styled with Spendora's 60-30-10 color strategy.
 */
struct SavingsScoreView: View {

    // MARK: - Properties

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
            result.append("You have \(count) active subscriptions. Auditing or canceling unused ones could save over \(CurrencyManager.shared.format(total * 0.25))/month.")
        }
        if total > 100 {
            result.append("You are committing \(CurrencyManager.shared.format(total))/month. Review recurring plans for annual discount conversion.")
        }
        let trials = subscriptions.filter { $0.isTrial && !$0.trialConvertedToPaid }
        if !trials.isEmpty {
            result.append("\(trials.count) free trial(s) ending soon. Set reminders to avoid surprise auto-renewals.")
        }
        if result.isEmpty {
            result.append("Outstanding work! Your recurring subscription spending is highly optimized.")
        }
        return result
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                SpendoraBrandBackgroundView()
                
                ScrollView {
                    VStack(spacing: AppStyles.Spacing.sectionSpacing) {
                        SavingsScoreHeaderView(
                            savingsScore: savingsScore,
                            recommendations: recommendations,
                            subscriptions: subscriptions
                        )
                        
                        ShareReportButton {
                            generateShareImage()
                        }
                    }
                    .padding(AppStyles.Spacing.large)
                }
            }
            .navigationTitle("Savings Score")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(AppStyles.Typography.body)
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
        let shareableView = ShareableScoreCard(
            score: savingsScore,
            count: subscriptions.count,
            total: subscriptions.reduce(0) { $0 + $1.monthlyCost }
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

// MARK: - SavingsScoreHeaderView

struct SavingsScoreHeaderView: View {
    let savingsScore: Int
    let recommendations: [String]
    let subscriptions: [Subscription]

    private var scoreColor: Color {
        switch savingsScore {
        case 80...100: return .brandPrimary
        case 60...79: return .brandAccent
        default: return .brandSecondary
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(scoreColor.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "star.circle.fill")
                        .foregroundColor(scoreColor)
                        .font(.title2)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("PORTFOLIO SCORE")
                        .font(AppStyles.Typography.micro)
                        .foregroundColor(.textSecondary)
                        .tracking(1.2)
                    
                    Text("Subscription Health")
                        .font(AppStyles.Typography.headline)
                        .foregroundColor(.textPrimary)
                }
                
                Spacer()
                
                Text("\(savingsScore)")
                    .font(Font.system(size: 34, weight: .black, design: .rounded))
                    .foregroundColor(scoreColor)
            }
            
            Divider()
                .background(Color.secondary.opacity(0.2))
            
            VStack(alignment: .leading, spacing: 12) {
                Text("OPTIMIZATION RECOMMENDATIONS")
                    .font(AppStyles.Typography.micro)
                    .foregroundColor(.textSecondary)
                    .tracking(1.0)
                
                ForEach(recommendations, id: \.self) { recommendation in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.brandPrimary)
                            .padding(.top, 2)
                        
                        Text(recommendation)
                            .font(AppStyles.Typography.caption)
                            .foregroundColor(.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .padding(AppStyles.Spacing.cardPadding)
        .spendora3DCard(cornerRadius: AppStyles.Radius.card)
    }
}
