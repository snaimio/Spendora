//
//  ChallengesView.swift
//  Spendora
//

import SwiftUI

struct ChallengesView: View {
    let subscriptions: [Subscription]
    @Environment(\.dismiss) private var dismiss
    @State private var completedChallenges: Set<String> = []
    @State private var showingShareSheet = false
    @State private var shareImage: UIImage?
    
    var challenges: [Challenge] {
        let total = subscriptions.reduce(0) { $0 + $1.monthlyCost }
        let count = subscriptions.count
        let yearlyCount = subscriptions.filter { $0.isYearly }.count
        let trialCount = subscriptions.filter { $0.isTrial && !$0.trialConvertedToPaid }.count
        
        return [
            Challenge(
                id: "first",
                title: "First Subscription",
                description: "Add your first subscription",
                icon: "star.fill",
                isCompleted: count >= 1,
                color: .yellow
            ),
            Challenge(
                id: "five",
                title: "Subscription Collector",
                description: "Track 5 subscriptions",
                icon: "number.circle.fill",
                isCompleted: count >= 5,
                color: .blue
            ),
            Challenge(
                id: "ten",
                title: "Subscription Master",
                description: "Track 10 subscriptions",
                icon: "trophy.fill",
                isCompleted: count >= 10,
                color: .orange
            ),
            Challenge(
                id: "budget",
                title: "Budget Conscious",
                description: "Keep monthly spending under $50",
                icon: "dollarsign.circle.fill",
                isCompleted: total <= 50 && count > 0,
                color: .green
            ),
            Challenge(
                id: "yearly",
                title: "Yearly Planner",
                description: "Have 3 yearly subscriptions",
                icon: "calendar",
                isCompleted: yearlyCount >= 3,
                color: .purple
            ),
            Challenge(
                id: "trial",
                title: "Trial Tracker",
                description: "Track 2 active trials",
                icon: "clock.fill",
                isCompleted: trialCount >= 2,
                color: .orange
            ),
            Challenge(
                id: "saver",
                title: "Saver",
                description: "Have a savings score of 80+",
                icon: "star.circle.fill",
                isCompleted: calculateSavingsScore() >= 80 && count > 0,
                color: .yellow
            )
        ]
    }
    
    var completionPercentage: Int {
        let completed = challenges.filter { $0.isCompleted }.count
        return challenges.isEmpty ? 0 : (completed * 100) / challenges.count
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    ChallengeProgressView(percentage: completionPercentage)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(challenges) { challenge in
                            ChallengeCard(challenge: challenge)
                        }
                    }
                    
                    if challenges.filter({ $0.isCompleted }).count > 0 {
                        ShareReportButton {
                            generateShareImage()
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Challenges")
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
    
    private func calculateSavingsScore() -> Int {
        let total = subscriptions.reduce(0) { $0 + $1.monthlyCost }
        let count = subscriptions.count
        let countScore = max(0, 100 - (count * 5))
        let spendingScore = max(0, 100 - Int(total / 10))
        return min(100, (countScore + spendingScore) / 2)
    }
    
    private func generateShareImage() {
        let shareableView = ShareableChallenges(
            percentage: completionPercentage,
            challenges: challenges
        )
        
        let renderer = ImageRenderer(content: shareableView)
        
        // ✅ FIXED: Use windowScene instead of UIScreen.main
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            renderer.scale = windowScene.screen.scale
        }
        
        if let image = renderer.uiImage {
            shareImage = image
            showingShareSheet = true
        }
    }
}
